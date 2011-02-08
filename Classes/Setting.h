//
//  Setting.h
//  MTM
//
//  Created by Tim Ekl on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Encapsulates a single setting displayed in a SettingsViewController. This
 * class stores a large amount of information about one setting to display and
 * contains a number of delegate methods that are called when its corresponding
 * table view cell receives actions.
 */
@interface Setting : NSObject {
@private
    NSString * _title;
    id _target;
    SEL _valueSelector;
    SEL _actionSelector;
}

/**
 * The title of the setting.
 */
@property (nonatomic, retain) NSString * title;

/**
 * The target of the setting. Called with the various selectors when this
 * setting performs actions.
 */
@property (nonatomic, assign) id target;

/**
 * The selector to call to get the value shown in this setting's table view
 * cell. Must return an NSString instance.
 */
@property (nonatomic, assign) SEL valueSelector;

/**
 * The selector to call to get the action to perform when this setting's table 
 * view cell is pressed. Must return void.
 */
@property (nonatomic, assign) SEL actionSelector;

/**
 * Create a new Setting object with the given attributes. This Setting will
 * display the given title and call the given selectors on the target when
 * appropriate actions are performed in the displaying SettingsViewController.
 */
- (id)initWithTitle:(NSString *)title target:(id)target onValue:(SEL)value onAction:(SEL)action;

/**
 * Get the value for this setting to display in the setting's table view cell.
 * This method wraps a call to valueSelector on the target.
 * @see Setting#valueSelector
 */
- (NSString *)value;

/**
 * Perform the on-touch action for this setting. This method wraps a call to
 * actionSelector on the target.
 * @see Setting#actionSelector
 */
- (void)performAction;

/**
 * Perform the on-touch action for this setting, passing the provided argument
 * to the selector. This method wraps a call to actionSelector on the target.
 * @see Setting#actionSelector
 */
- (void)performActionWithArgument:(id)arg;

@end
