//
//  ServiceAccount.m
//  MTM
//
//  Created by Tim Ekl on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ServiceAccount.h"


@implementation ServiceAccount

@synthesize username = _username;
@synthesize password = _password;
@synthesize serviceURL = _serviceURL;
@synthesize keychainUUID = _keychainUUID;

- (id)initWithUsername:(NSString *)username password:(NSString *)password serviceURL:(NSURL *)serviceURL {
    if((self = [super init])) {
        self.username = username;
        self.password = password;
        self.serviceURL = serviceURL;
    }
    return self;
}

- (void)dealloc {
    [_username release];
    [_password release];
    [_serviceURL release];
    
    [super dealloc];
}

@end
