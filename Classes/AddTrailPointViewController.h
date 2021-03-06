//
//  AddTrailPointViewController.h
//  MTM
//
//  Created by Tim Ekl on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "MTMSettingsViewController.h"

@class Trail;
@class Condition;

@interface AddTrailPointViewController : MTMSettingsViewController <CLLocationManagerDelegate> {
@private
    CLLocationManager * _locationManager;
    
    CLLocationCoordinate2D _currentLocation;
    
    NSString * _pointTitle;
    NSString * _pointDesc;
    Condition * _pointCondition;
    
    Trail * _pointTrail;
    NSString * _pointCategory;
}

/**
 * The location to be used in the new point. Initially set from the current
 * device location, but may be user-updated to any geographical coordinate.
 */
@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;

/**
 * The title to be used for the new point.
 */
@property (nonatomic, retain) NSString * pointTitle;

/**
 * The description to be used for the new point.
 */
@property (nonatomic, retain) NSString * pointDesc;

/**
 * The condition to be used for the new point.
 */
@property (nonatomic, retain) Condition * pointCondition;

/**
 * The Trail object that will own the new point.
 */
@property (nonatomic, retain) Trail * pointTrail;

/**
 * The category string that will be used for the new point.
 */
@property (nonatomic, retain) NSString * pointCategory;

@end
