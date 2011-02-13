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

@end
