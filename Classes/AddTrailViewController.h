//
//  AddTrailViewController.h
//  MTM
//
//  Created by Tim Ekl on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTMSettingsViewController.h"

/**
 * Custom add object interface for a new Trail.
 */
@interface AddTrailViewController : MTMSettingsViewController {
@private
    NSString * _trailName;
}

/**
 * The name of the trail to be created.
 */
@property (nonatomic, retain) NSString * trailName;

@end
