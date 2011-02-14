//
//  NetworkOperation.m
//  MTM
//
//  Created by Tim Ekl on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetworkOperation.h"
#import "NetworkOperationDelegate.h"

@implementation NetworkOperation

@synthesize delegates = _delegates;
@synthesize requestType = _requestType;
@synthesize returnType = _returnType;
@synthesize endpoint = _endpoint;
@synthesize data = _data;

#pragma mark - Operations

- (void)execute {
    
}

- (void)cancel {
    
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
        self.data = [NSDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    [_delegates release];
    [_endpoint release];
    [_data release];
    
    [super dealloc];
}

@end
