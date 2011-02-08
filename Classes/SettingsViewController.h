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

@end
