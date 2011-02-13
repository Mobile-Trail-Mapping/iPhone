//
//  ServiceAccountManager.m
//  MTM
//
//  Created by Tim Ekl on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Security/Security.h>

#import "ServiceAccountManager.h"
#import "ServiceAccount.h"

static ServiceAccountManager * sharedInstance = nil;

@implementation ServiceAccountManager

- (NSArray *)serviceAccounts {
    NSMutableArray * accounts = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    
    // Basic parameters of the keychain search
    NSMutableDictionary * keychainQuery = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
    [keychainQuery setValue:(id)kSecClassInternetPassword forKey:(id)kSecClass];
    [keychainQuery setValue:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
    [keychainQuery setValue:(id)kSecMatchLimitAll forKey:(id)kSecMatchLimit];
    
    // Fetch results
    NSArray * keychainResults = nil;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)(&keychainResults));
    if(status == noErr) {
        // Build account instance for each result
        for(NSDictionary * accountDict in keychainResults) {
            NSString * username = [accountDict valueForKey:(id)kSecAttrSubject];
            NSString * password = [[[NSString alloc] initWithData:[accountDict valueForKey:(id)kSecValueData] encoding:NSUTF8StringEncoding] autorelease];
            NSString * protocol = [accountDict valueForKey:(id)kSecAttrProtocol];
            NSString * server = [accountDict valueForKey:(id)kSecAttrServer];
            NSString * path = [accountDict valueForKey:(id)kSecAttrPath];
            NSURL * serviceURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@%@", protocol, server, path]];
            
            ServiceAccount * account = [[[ServiceAccount alloc] initWithUsername:username password:password serviceURL:serviceURL] autorelease];
            account.keychainUUID = [accountDict valueForKey:(id)kSecAttrComment];
            [accounts addObject:account];
        }
    } else {
        NSLog(@"Failed to retrieve accounts: %@", [self errorForOSStatus:status]);
    }
    
    return accounts;
}

- (ServiceAccount *)activeServiceAccount {
    return nil;
}

- (NSString *)newUUID {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString * uuidString = (NSString *)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [uuidString autorelease];
}

- (NSString *)errorForOSStatus:(OSStatus)status {
    switch(status) {
        case errSecUnimplemented: return @"Function unimplemented"; break;
        case errSecParam: return @"Invalid parameters"; break;
        case errSecAllocate: return @"Could not allocate memory"; break;
        case errSecNotAvailable: return @"No trust results available"; break;
        case errSecAuthFailed: return @"Authorization failed"; break;
        case errSecDuplicateItem: return @"Item already exists"; break;
        case errSecItemNotFound: return @"Item not found"; break;
        case errSecInteractionNotAllowed: return @"Security server interaction not allowed"; break;
        case errSecDecode: return @"Could not decode data"; break;
        default: return @"Unknown error"; break;
    }
    return nil; // Should never get here
}

- (void)addAccount:(ServiceAccount *)account {
    // Instantiate new keychain object dictionary
    NSMutableDictionary * keychainQuery = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
    
    // Set up required object key-value pairs
    [keychainQuery setValue:(id)kSecClassInternetPassword forKey:(id)kSecClass];
    
    // Set up optional object key-value pairs
    [keychainQuery setValue:[[account serviceURL] scheme] forKey:(id)kSecAttrProtocol];
    [keychainQuery setValue:[[account serviceURL] host] forKey:(id)kSecAttrServer];
    [keychainQuery setValue:[[account serviceURL] path] forKey:(id)kSecAttrPath];
    [keychainQuery setValue:[account username] forKey:(id)kSecAttrAccount];
    [keychainQuery setValue:[[account password] dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
    [keychainQuery setValue:[self newUUID] forKey:(id)kSecAttrComment];
    
    //NSLog(@"About to add keychain item: %@", keychainDict);
    
    // Save the account in the keychain
    OSStatus status = SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    if(status != noErr) {
        NSLog(@"Failed to add keychain item: %@", [self errorForOSStatus:status]);
    }
}

- (void)removeAccount:(ServiceAccount *)account {
    // Instantiate query keychain dictionary
    NSMutableDictionary * keychainQuery = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
    
    // Set up required key-value pairs
    [keychainQuery setValue:(id)kSecClassInternetPassword forKey:(id)kSecClass];
    
    // Set up optional search parameters
    if([account keychainUUID] != nil) {
        [keychainQuery setValue:[account keychainUUID] forKey:(id)kSecAttrComment];
    } else {
        [keychainQuery setValue:[[account serviceURL] scheme] forKey:(id)kSecAttrProtocol];
        [keychainQuery setValue:[[account serviceURL] host] forKey:(id)kSecAttrServer];
        [keychainQuery setValue:[[account serviceURL] path] forKey:(id)kSecAttrPath];
        [keychainQuery setValue:[account username] forKey:(id)kSecAttrAccount];
        [keychainQuery setValue:[[account password] dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
    }
    
    // Remove the account from the keychain
    OSStatus status = SecItemDelete((CFDictionaryRef)keychainQuery);
    if(status != noErr) {
        NSLog(@"Failed to remove keychain item: %@", [self errorForOSStatus:status]);
    }
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