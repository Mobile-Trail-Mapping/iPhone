//
//  NetworkOperation.m
//  MTM
//
//  Created by Tim Ekl on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetworkOperation.h"

#import "NetworkOperationManager.h"
#import "ServiceAccountManager.h"

/**
 * Private methods used for data conversion when constructing or interfacing
 * with a NetworkOperation.
 */
@interface NetworkOperation(Conversions)

/**
 * Convert the given data dictionary to a URL-encoded query string suitable
 * for use in GET requests.
 *
 * Items in the dictionary not easily castable to strings (e.g. UIImages) will
 * be ignored.
 */
- (NSString *)HTTPQueryStringForGETRequestFromDictionary:(NSDictionary *)dict;

/**
 * Convert the given data dictionary to a query string suitable for use in
 * GET requests, magicked into an NSData container.
 *
 * @see NetworkOperation#HTTPQueryStringForGetRequestFromDictionary
 */
- (NSData *)HTTPBodyForGETRequestFromDictionary:(NSDictionary *)dict;

/**
 * Convert the given data dictionary to an NSData object containing
 * encoded and partitioned query-ready information.
 *
 * This method makes a best effort to stuff every item from the dictionary
 * into the resulting data object using POST multipart formatting and
 * a predefined boundary. No guarantees, though.
 */
- (NSData *)HTTPBodyForPOSTRequestFromDictionary:(NSDictionary *)dict multipartBoundary:(NSString *)aBoundary;

@end

@implementation NetworkOperation

@synthesize delegates = _delegates;
@synthesize requestType = _requestType;
@synthesize returnType = _returnType;
@synthesize authenticate = _authenticate;
@synthesize endpoint = _endpoint;
@synthesize requestData = _requestData;
@synthesize label = _label;

#pragma mark - Operations

- (void)execute {
    for(id<NetworkOperationDelegate> delegate in self.delegates) {
        if([delegate respondsToSelector:@selector(operationBegan:)]) {
            [delegate operationBegan:self];
        }
    }
    [[NetworkOperationManager sharedManager] operationBegan:self];
    
    NSURL * serviceBase = [[[ServiceAccountManager sharedManager] activeServiceAccount] serviceURL];
    NSURL * URL = [serviceBase URLByAppendingPathComponent:self.endpoint];
    
    self.requestData = [[self.requestData mutableCopy] autorelease];
    _request = [[NSMutableURLRequest alloc] initWithURL:URL];
    if(self.requestType == kNetworkOperationRequestTypeGet) {
        [_request setHTTPMethod:@"GET"];
        [_request setHTTPBody:[self HTTPBodyForGETRequestFromDictionary:self.requestData]];
    } else if(self.requestType == kNetworkOperationRequestTypePost) {
        if(self.authenticate) {
            NSString * username = [[[ServiceAccountManager sharedManager] activeServiceAccount] username];
            NSString * passwordHash = [[[ServiceAccountManager sharedManager] activeServiceAccount] passwordSHA1];
            
            [self.requestData setValue:(id)username forKey:@"user"];
            [self.requestData setValue:(id)passwordHash forKey:@"pwhash"];
        }
        
        NSString * boundary = @"POSTRequestBoundary";
        [_request setHTTPMethod:@"POST"];
        [_request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField: @"Content-Type"];
        [_request setHTTPBody:[self HTTPBodyForPOSTRequestFromDictionary:self.requestData multipartBoundary:boundary]];
    } else {
        NSLog(@"Unknown request type - refusing to execute network operation");
        
        NSError * operationError = [[[NSError alloc] initWithDomain:@"MTM-NetworkOperation" code:kNetworkOperationErrorUnrecognizedRequestType userInfo:nil] autorelease];
        for(id<NetworkOperationDelegate> delegate in self.delegates) {
            if([delegate respondsToSelector:@selector(operation:didFailWithError:)]) {
                [delegate operation:self didFailWithError:operationError];
            }
        }
        [[NetworkOperationManager sharedManager] operation:self didFailWithError:operationError];
        
        return;
    }
    
    _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:NO];
    _returnData = [[NSMutableData alloc] initWithCapacity:10];
    [_connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [_connection start];
}

- (void)cancel {
    [_connection cancel];
    
    NSError * operationError = [[[NSError alloc] initWithDomain:@"MTM-NetworkOperation" code:kNetworkOperationErrorCanceled userInfo:nil] autorelease];
    
    for(id<NetworkOperationDelegate> delegate in self.delegates) {
        if([delegate respondsToSelector:@selector(operation:didFailWithError:)]) {
            [delegate operation:self didFailWithError:operationError];
        }
    }
    [[NetworkOperationManager sharedManager] operation:self didFailWithError:operationError];
}

#pragma mark - Data manipulation

- (NSString *)HTTPQueryStringForGETRequestFromDictionary:(NSDictionary *)dict {
    NSMutableString * queryString = [[[NSMutableString alloc] initWithCapacity:10] autorelease];
    for(NSString * key in dict) {
        if([queryString length] == 0) {
            [queryString appendString:@"?"];
        }
        if([queryString length] > 1) {
            [queryString appendString:@"&"];
        }
        [queryString appendFormat:@"%@=%@", key, [dict valueForKey:key]];
    }
    return [queryString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}

- (NSData *)HTTPBodyForGETRequestFromDictionary:(NSDictionary *)dict {
    return [[self HTTPQueryStringForGETRequestFromDictionary:dict] dataUsingEncoding:NSASCIIStringEncoding];
}

- (NSData *)HTTPBodyForPOSTRequestFromDictionary:(NSDictionary *)dict multipartBoundary:(NSString *)aBoundary {
    NSMutableData *myData = [NSMutableData dataWithCapacity:1];
    NSString *myBoundary = [NSString stringWithFormat:@"--%@\r\n", aBoundary];
    
    for(id key in dict) {
        id myValue = [dict valueForKey:key];
        [myData appendData:[myBoundary dataUsingEncoding:NSUTF8StringEncoding]];
        //if ([myValue class] == [NSString class]) {
        if ([myValue isKindOfClass:[NSString class]]) {
            [myData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [myData appendData:[[NSString stringWithFormat:@"%@", myValue] dataUsingEncoding:NSUTF8StringEncoding]];
        } else if(([myValue isKindOfClass:[NSURL class]]) && ([myValue isFileURL])) {
            [myData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, [[myValue path] lastPathComponent]] dataUsingEncoding:NSUTF8StringEncoding]];
            [myData appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [myData appendData:[NSData dataWithContentsOfFile:[myValue path]]];
        } else if(([myValue isKindOfClass:[NSData class]])) {
            [myData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, key] dataUsingEncoding:NSUTF8StringEncoding]];
            [myData appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [myData appendData:myValue];
        } // eof if()
        
        [myData appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    } // eof for()
    [myData appendData:[[NSString stringWithFormat:@"--%@--\r\n", aBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return myData;
}

#pragma mark - NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_returnData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSDictionary * userInfo = [[[NSDictionary alloc] initWithObjectsAndKeys:error, @"innerError", nil] autorelease];
    NSError * operationError = [[[NSError alloc] initWithDomain:@"MTM-NetworkOperation" code:kNetworkOperationErrorConnectionFailed userInfo:userInfo] autorelease];
    
    for(id<NetworkOperationDelegate> delegate in self.delegates) {
        if([delegate respondsToSelector:@selector(operation:didFailWithError:)]) {
            [delegate operation:self didFailWithError:operationError];
        }
    }
    [[NetworkOperationManager sharedManager] operation:self didFailWithError:operationError];
    
    [_connection release];
    _connection = nil;
    [_returnData release];
    _returnData = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    id result = nil;
    
    if(self.returnType == kNetworkOperationReturnTypeData) {
        result = _returnData;
    } else if(self.returnType == kNetworkOperationReturnTypeImage) {
        result = [UIImage imageWithData:_returnData];
    } else if(self.returnType == kNetworkOperationReturnTypeString) {
        result = [[[NSString alloc] initWithData:_returnData encoding:NSASCIIStringEncoding] autorelease];
    } else {
        NSLog(@"Unrecognized return type - refusing to return from network operation");
        
        NSError * operationError = [[[NSError alloc] initWithDomain:@"MTM-NetworkOperation" code:kNetworkOperationErrorUnrecognizedReturnType userInfo:nil] autorelease];
        for(id<NetworkOperationDelegate> delegate in self.delegates) {
            if([delegate respondsToSelector:@selector(operation:didFailWithError:)]) {
                [delegate operation:self didFailWithError:operationError];
            }
        }
        [[NetworkOperationManager sharedManager] operation:self didFailWithError:operationError];
        
        return;
    }
    
    for(id<NetworkOperationDelegate> delegate in self.delegates) {
        if([delegate respondsToSelector:@selector(operation:completedWithResult:)]) {
            [delegate operation:self completedWithResult:result];
        }
    }
    [[NetworkOperationManager sharedManager] operation:self completedWithResult:result];
    
    [_connection release];
    _connection = nil;
    [_returnData release];
    _returnData = nil;
}

#pragma mark - Delegate handling

- (void)addDelegate:(id<NetworkOperationDelegate>)delegate {
    if(![self.delegates containsObject:delegate]) {
        [self.delegates addObject:delegate];
    }
}

- (void)removeDelegate:(id<NetworkOperationDelegate>)delegate {
    [self.delegates removeObject:delegate];
}

#pragma mark - Lifecycle

- (id)init {
    if((self = [super init])) {
        self.requestType = kNetworkOperationRequestTypeUnspecified;
        self.returnType = kNetworkOperationReturnTypeData;
        self.delegates = [[[NSMutableSet alloc] initWithCapacity:2] autorelease];
        self.endpoint = @"";
        self.requestData = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
        self.label = nil;
    }
    return self;
}

- (void)dealloc {
    [_delegates release];
    [_endpoint release];
    [_requestData release];
    [_returnData release];
    [_request release];
    [_connection release];
    [_label release];
    
    [super dealloc];
}

@end
