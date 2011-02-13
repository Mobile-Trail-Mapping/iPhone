//
//  ServiceAccountManager.m
//  MTM
//
//  Created by Tim Ekl on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ServiceAccountManager.h"
#import "ServiceAccount.h"

static ServiceAccountManager * sharedInstance = nil;

@implementation ServiceAccountManager

- (NSArray *)serviceAccounts {
    NSMutableArray * accounts = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    
    return accounts;
}

- (ServiceAccount *)activeServiceAccount {
    return nil;
}

#pragma mark - Singleton methods

+ (ServiceAccountManager *)sharedManager {
    @synchronized(self)
    {
        if (sharedInstance == nil)
            sharedInstance = [[ServiceAccountManager alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    // Can't be released
    return UINT_MAX;  
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end