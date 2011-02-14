//
//  ServiceAccount.m
//  MTM
//
//  Created by Tim Ekl on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ServiceAccount.h"

#import <CommonCrypto/CommonDigest.h>

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

- (NSString *)passwordSHA1 {
    const char *cstr = [self.password cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.password.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString * output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

- (void)dealloc {
    [_username release];
    [_password release];
    [_serviceURL release];
    
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"{account <%@>: %@/%@ at %@}", self.keychainUUID, self.username, self.password, [self.serviceURL absoluteString]];
}

@end
