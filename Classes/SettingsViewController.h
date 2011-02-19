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
    
    MainViewController * _primaryViewController;
}

/**
 * The instance of MainViewController showing this controller modally. Receives
 * "delegate" actions for certain settings operations.
 *
 * This instance is weakly linked; it is technically possible for no
 * primaryViewController to exist for an instance of SettingsViewController.
 */
@property (nonatomic, assign) MainViewController * primaryViewController;

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
