//
//  NetworkOperation.m
//  MTM
//
//  Created by Tim Ekl on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetworkOperation.h"


@implementation NetworkOperation

@synthesize delegates = _delegates;
@synthesize requestType = _requestType;
@synthesize endpoint = _endpoint;
@synthesize data = _data;

- (id)init {
    if((self = [super init])) {
        self.requestType = kNetworkOperationRequestTypeUnspecified;
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
    
    [super dealloc]
}

@end
