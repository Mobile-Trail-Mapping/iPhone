//
//  AddTrailViewController.h
//  MTM
//
//  Created by Tim Ekl on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "MTMSettingsViewController.h"

/**
 * Custom add object interface for a new Trail.
 */
@interface AddTrailViewController : MTMSettingsViewController <CLLocationManagerDelegate> {
@private
    NSString * _trailName;
    
    CLLocationManager * _locationManager;
    
    CLLocationCoordinate2D _currentLocation;
}

/**
 * The name of the trail to be created.
 */
@property (nonatomic, retain) NSString * trailName;

/**
 * The location to be used in the new point. Initially set from the current
 * device location, but may be user-updated to any geographical coordinate.
 */
@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;

@end
