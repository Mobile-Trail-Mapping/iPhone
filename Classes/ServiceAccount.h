//
//  ServiceAccount.h
//  MTM
//
//  Created by Tim Ekl on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Encapsulates information about a single service account available to users
 * of the MTM application. A "service account" comprises a URL that hosts
 * an instance of the MTM server and a username/password pair for that server.
 *
 * The ServiceAccount object has no built-in persistence, and is meant to store
 * service account information in memory only; persistence is handled by the
 * iOS keychain through the ServiceAccountManager class.
 *
 * @see ServiceAccountManager
 */
@interface ServiceAccount : NSObject {
@private
    NSString * _username;
    NSString * _password;
    NSURL * _serviceURL;
    NSString * _keychainUUID;
}

/**
 * The username to use for authentication with this service account.
 */
@property (nonatomic, retain) NSString * username;

/**
 * The password to use for authentication with this service account.
 */
@property (nonatomic, retain) NSString * password;

/**
 * The URL at which an instance of the MTM server is located for this
 * service account.
 */
@property (nonatomic, retain) NSURL * serviceURL;

/**
 * The internal UUID that matches this instance of ServiceAccount to its
 * corresponding entry in the keychain.
 */
@property (nonatomic, retain) NSString * keychainUUID;

/**
 * The password for this service account, hashed through a UTF-8 implementation
 * of SHA-1.
 */
- (NSString *)passwordSHA1;

/**
 * Create a new service account and populate it with the given arguments.
 */
- (id)initWithUsername:(NSString *)username password:(NSString *)password serviceURL:(NSURL *)serviceURL;

/**
 * Check whether this service account is the same as another service account.
 * This comparison works as follows:
 *  1. If this account and the other account share the same non-nil keychain
 *     UUID, returns YES.
 *  2. If one account has a nil keychain UUID but the other is non-nil, or
 *     the two keychain UUIDs are different, returns NO.
 *  3. If both accounts have a nil keychain UUID, but have all the same
 *     property values, returns YES.
 *  4. If both accounts have a nil keychain UUID, but their property values
 *     differ, returns NO.
 */
- (BOOL)isEqualToServiceAccount:(ServiceAccount *)other;

@end
