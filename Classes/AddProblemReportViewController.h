//
//  AddProblemReportViewController.h
//  MTM
//
//  Created by Tim Ekl on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "MTMSettingsViewController.h"
#import "NetworkOperationDelegate.h"

@class NetworkOperation;

/**
 * Custom subclass of MTMSettingsViewController used to gather details and
 * submit a problem report for a trail. Allows for users to enter a problem
 * title, description, and take a photo.
 */
@interface AddProblemReportViewController : MTMSettingsViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate, NetworkOperationDelegate> {
@private
    CLLocationManager * _locationManager;
    
    CLLocationCoordinate2D _currentLocation;
    
    NSString * _problemTitle;
    NSString * _problemDesc;
    
    UIImage * _problemPhoto;
    NSDate * _problemPhotoDate;
    
    NetworkOperation * _submitOperation;
}

/**
 * The location to be used in the new point. Initially set from the current
 * device location, but may be user-updated to any geographical coordinate.
 */
@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;

@property (nonatomic, retain) NSString * problemTitle;
@property (nonatomic, retain) NSString * problemDesc;

@property (nonatomic, retain) UIImage * problemPhoto;

/**
 * Attempt to enable the "Submit" button in the problem report view controller.
 * A successful attempt requires a filled-out title, description, photo,
 * user information, and position.
 */
- (void)tryEnableSubmit;

@end
