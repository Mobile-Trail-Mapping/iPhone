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
    SEL _callbackSelector;
    BOOL _enabled;
    BOOL _secure;
    BOOL _shouldShowDisclosure;
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
 * view cell is pressed. Must return void; takes an optional id as an
 * argument.
 */
@property (nonatomic, assign) SEL actionSelector;

/**
 * The selector to call when the value associated with this setting is changed,
 * either in a PropertyEditorViewController or elsewhere. Must return void
 * and take an NSString as an argument.
 */
@property (nonatomic, assign) SEL callbackSelector;

/**
 * Whether this setting is 'enabled'. A disabled setting will appear but be
 * inactive.
 */
@property (nonatomic, assign) BOOL enabled;

/**
 * Whether this setting is secure. A secure setting will have its value
 * obscured when displayed.
 */
@property (nonatomic, assign) BOOL secure;

/**
 * Whether this setting should show a disclosure indication when displayed.
 */
@property (nonatomic, assign) BOOL shouldShowDisclosure;

/**
 * Create a new Setting object with the given attributes. This Setting will
 * display the given title and call the given selectors on the target when
 * appropriate actions are performed in the displaying SettingsViewController.
 */
- (id)initWithTitle:(NSString *)title target:(id)target onValue:(SEL)value onAction:(SEL)action onChange:(SEL)callback;

/**
 * Get the value for this setting to display in the setting's table view cell.
 * This method wraps a call to valueSelector on the target.
 * @see Setting#valueSelector
 */
- (NSString *)value;

/**
 * Get the value for this setting to display in the setting's table view cell,
 * ignoring the Setting#secure property. This method wraps a call to
 * valueSelector on the target.
 */
- (NSString *)insecureValue;

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

/**
 * Perform the on-change callback action for this setting, passing the new
 * value to the target. This method wraps a call to callbackSelector on the
 * target.
 */
- (void)performChangeCallbackWithValue:(NSString *)newValue;

@end
