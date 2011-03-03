//
//  SettingsViewController.h
//  MTM
//
//  Created by Tim Ekl on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Setting.h"
#import "MutableOrderedDictionary.h"

@class MainViewController;

@interface SettingsViewController : UITableViewController {
@private
    MutableOrderedDictionary * _settings;
}

/**
 * The MutableOrderedDictionary of Setting objects used as display objects
 * in this controller.
 */
@property (nonatomic, retain) MutableOrderedDictionary * settings;

/**
 * Generate the MutableOrderedDictionary containing the Setting objects
 * which are displayed in this SettingsViewController. Subclasses should
 * implement this method to show custom sets of settings by creating a new
 * MutableOrderedDictionary of settings and populating it into the
 * SettingsViewController#settings property.
 */
- (void)buildSettings;

@end
