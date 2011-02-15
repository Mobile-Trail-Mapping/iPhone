//
//  PropertyPickerViewController.h
//  MTM
//
//  Created by Tim Ekl on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Setting;

@interface PropertyPickerViewController : UITableViewController {
@private
    Setting * _setting;
    NSArray * _options;
}

/**
 * The Setting backing this property editor. Provides information to this
 * controller, including placeholder text, secure text entry status, and
 * current setting value.
 */
@property (nonatomic, retain) Setting * setting;

/**
 * The list of options that are available for this controller to choose from.
 * Should contain only NSString objects.
 */
@property (nonatomic, retain) NSArray * options;

/**
 * Create a new property editor with the given Setting.
 */
- (id)initWithSetting:(Setting *)setting options:(NSArray *)options;

@end
