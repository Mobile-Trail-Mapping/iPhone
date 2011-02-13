//
//  ServiceAccountManager.h
//  MTM
//
//  Created by Tim Ekl on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ServiceAccount;

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
 * Retrieve the currently active ServiceAccount. The "active" service
 * account refers to the one whose settings appear in the settings page;
 * its credentials and URL are used for all server interaction, including
 * any authentication that needs to be performed.
 */
- (ServiceAccount *)activeServiceAccount;

/**
 * Store the information in the provided ServiceAccount in the keychain.
 * This method does no deduplication; if the provided account already exists,
 * it will still be stored separately.
 */
- (void)addAccount:(ServiceAccount *)account;

/**
 * Remove the given ServiceAccount from the keychain and discard its
 * information. If multiple service accounts exist that match the provided
 * object, only the first will be discarded.
 */
- (void)removeAccount:(ServiceAccount *)account;

@end
