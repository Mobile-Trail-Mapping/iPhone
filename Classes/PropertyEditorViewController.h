//
//  PropertyEditorViewController.h
//  MTM
//
//  Created by Tim Ekl on 2/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Setting;

@interface PropertyEditorViewController : UIViewController <UITextFieldDelegate> {
@private
    UITextField * _propertyField;
    Setting * _setting;
}

/**
 * The user-visible property field used to edit this property.
 */
@property (nonatomic, retain) IBOutlet UITextField * propertyField;

/**
 * The Setting backing this property editor. Provides information to this
 * controller, including placeholder text, secure text entry status, and
 * current setting value.
 */
@property (nonatomic, retain) Setting * setting;

/**
 * Create a new property editor with the given Setting.
 */
- (id)initWithSetting:(Setting *)setting;

@end
