//
//  TrailPointInfoEditorViewController.h
//  MTM
//
//  Created by Tim Ekl on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrailPoint;

/**
 * Allows administrative users to edit information about a given trail point
 * from the device.
 */
@interface TrailPointInfoEditorViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate> {
@private
    TrailPoint * _trailPoint;
    
    UITextField * _conditionField;
    UITextView * _descriptionView;
    UIButton * _addPhotoButton;
    UIButton * _deletePointButton;
    UIButton * _saveChangesButton;
}

/**
 * The TrailPoint for which information is being edited.
 */
@property (nonatomic, retain) TrailPoint * trailPoint;

/**
 * Text field containing the condition of this controller's TrailPoint.
 */
@property (nonatomic, retain) IBOutlet UITextField * conditionField;

/**
 * Text view containing the description of this controller's TrailPoint.
 */
@property (nonatomic, retain) IBOutlet UITextView * descriptionView;

/**
 * Action button for adding a photo to this TrailPoint.
 */
@property (nonatomic, retain) IBOutlet UIButton * addPhotoButton;

/**
 * Action button for deleting this TrailPoint.
 */
@property (nonatomic, retain) IBOutlet UIButton * deletePointButton;

/**
 * Action button for saving changes to this TrailPoint.
 */
@property (nonatomic, retain) IBOutlet UIButton * saveChangesButton;

/**
 * Action response method for adding a photo.
 */
- (IBAction)addPhoto:(id)sender;

/**
 * Action response method for deleting a point.
 */
- (IBAction)deletePoint:(id)sender;

/**
 * Action response method for saving changes.
 */
- (IBAction)save:(id)sender;

@end
