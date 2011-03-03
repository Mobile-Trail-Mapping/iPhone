//
//  MTMSettingsViewController.h
//  MTM
//
//  Created by Tim Ekl on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SettingsViewController.h"

/**
 * MTM-custom subclass of SettingsViewController for settings screens. Serves
 * as a common superclass for all concrete screen subclasses. Adds a single
 * property for callback purposes.
 */
@interface MTMSettingsViewController : SettingsViewController {
@private
    
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
