//
//  ServiceAccountManager.h
//  MTM
//
//  Created by Tim Ekl on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ServiceAccount.h"

/**
 * Singleton class responsible for handling keychain access, credentials, and
 * remote authentication information used in interactions with the MTM
 * server. Does not provide information stored insecurely in the settings
 * plist file (e.g. first run information, location preferences) or in 
 * core data (e.g. trail cache information).
 */
@interface ServiceAccountManager : NSObject {
@private
    
}

/**
 * The shared instance of this singleton class. Used to access an instance
 * of ServiceAccountManager, which can then be used to gain access to
 * individual stored settings.
 */
+ (ServiceAccountManager *)sharedManager;

/**
 * Retrieve a list of all service accounts available for authentication
 * against remote endpoints. The array provided contains instances of the
 * ServiceAccount class.
 */
- (NSArray *)serviceAccounts;

/**
 * Retrieve the service account that matches the given account for all
 * its properties. This method provides a convenient way to populate the
 * ServiceAccount#keychainUUID field for a service account.
 */
- (ServiceAccount *)serviceAccountMatchingAccount:(ServiceAccount *)account;

/**
 * Retrieve the currently active ServiceAccount. The "active" service
 * account refers to the one whose settings appear in the settings page;
 * its credentials and URL are used for all server interaction, including
 * any authentication that needs to be performed.
 */
- (ServiceAccount *)activeServiceAccount;

/**
 * Set the given service account to be active.
 */
- (void)setActiveServiceAccount:(ServiceAccount *)account;

/**
 * Store the information in the provided ServiceAccount in the keychain.
 * This method does no deduplication; if the provided account already exists,
 * it will still be stored separately.
 */
- (void)addAccount:(ServiceAccount *)account;

/**
 * Refresh the information stored in the keychain for the given ServiceAccount
 * with new data stored in memory. This method relies upon the given account
 * having its ServiceAccount#keychainUUID property set correctly; without
 * a UUID, it does no updating.
 */
- (void)updateAccount:(ServiceAccount *)account;

/**
 * Remove the given ServiceAccount from the keychain and discard its
 * information. This method will remove at most one account at a time,
 * searching as follows:
 *
 *  - If the account has its ServiceAccount#keychainUUID property set to
 *    a non-nil value, the method will remove the keychain data that matches
 *    that UUID. If no UUID in the keychain matches, no account is removed.
 *  - If the account has a nil value for its ServiceAccount#keychainUUID
 *    property, the method will search for the first keychain data that matches
 *    all other properties of the account (service URL, username, and
 *    password), removing the first account that matches all three. If no
 *    such keychain account exists, no account is removed.
 */
- (void)removeAccount:(ServiceAccount *)account;

/**
 * Get a human-readable description of the given OSStatus code. Used primarily
 * to show results of keychain queries in application logs.
 */
- (NSString *)errorForOSStatus:(OSStatus)status;

@end
