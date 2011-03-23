//
//  StoredSettingsManager.h
//  MTM
//
//  Created by Tim Ekl on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

/**
 * Singleton class responsible for storing and providing access to application
 * settings. Does not provide any access to information that is kept in the 
 * keychain (e.g. usernames or passwords) or cached for mapping (e.g. trail 
 * objects).
 */
@interface StoredSettingsManager : NSObject {
@private
    BOOL _isFirstRun;
    NSString * _activeServiceAccountUUID;
    MKMapType _mapType;
    BOOL _mapZoomsToUserLocation;
}

/**
 * Whether or not this is the first time the MTM application has been run.
 *
 * This property is <em>not</em> automatically updated by the
 * StoredSettingsManager - instead it is programmatically changed in the
 * MTMAppDelegate.
 */
@property (nonatomic, assign) BOOL isFirstRun;

/**
 * The UUID of the active ServiceAccount instance currently handling 
 * credentials and authentication. Service accounts are primarily handled
 * through the ServiceAccountManager class; this property simply declares
 * which account to use when a default is needed.
 *
 * If no value for this property is set, no service account is currently
 * active, and no authentication requests will succeed.
 *
 * @see ServiceAccount
 * @see ServiceAccount#keychainUUID
 * @see ServiceAccountManager
 */
@property (nonatomic, retain) NSString * activeServiceAccountUUID;

/**
 * The type of map to show the user on the primary map screen.
 */
@property (nonatomic, assign) MKMapType mapType;

/**
 * Whether or not the primary map view zooms to user location on application
 * startup.
 */
@property (nonatomic, assign) BOOL mapZoomsToUserLocation;

/**
 * The shared instance of this singleton class. Used to access an instance
 * of StoredSettingsManager, which can then be used to gain access to
 * individual stored settings.
 */
+ (StoredSettingsManager *)sharedManager;

/**
 * Read all stored settings from their backing plist file. This
 * method is called once when StoredSettingsManager is first instatiated,
 * populating all settings through the manager. It may be called at any
 * point subsequent to force a re-read of all settings.
 */
- (void)readSettingsFromFile;

/**
 * Write all stored settings to their backing plist file. This method is
 * called from MTMAppDelegate before the application terminates to save all
 * settings back to disk; it may be called at any time prior to that in order
 * to force a save (e.g. before a potentially dangerous or long-running
 * operation).
 */
- (void)writeSettingsToFile;

@end
