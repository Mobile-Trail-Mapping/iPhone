//
//  SettingsViewController.h
//  MTM
//
//  Created by Tim Ekl on 2/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;
@class MutableOrderedDictionary;

/**
 * View controller for application settings. Displays a table view for the
 * user to change configuration of the application.
 */
@interface PrimarySettingsViewController : UITableViewController {
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
 * Generate the MutableOrderedDictionary containing the Setting objects
 * which are displayed in this SettingsViewController.
 */
- (MutableOrderedDictionary *)settings;

@end
