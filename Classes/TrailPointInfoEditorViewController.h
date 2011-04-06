//
//  TrailPointInfoEditorViewController.h
//  MTM
//
//  Created by Tim Ekl on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrailPoint;
@class TrailPointInfoViewController;

/**
 * Allows administrative users to edit information about a given trail point
 * from the device.
 */
@interface TrailPointInfoEditorViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
@private
    TrailPoint * _trailPoint;
    
    UITextField * _conditionField;
    UITextView * _descriptionView;
    UIButton * _addPhotoButton;
    UIButton * _saveChangesButton;
    
    UIImage * _newImage;
    
    TrailPointInfoViewController * _infoController;
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
 * Action button for saving changes to this TrailPoint.
 */
@property (nonatomic, retain) IBOutlet UIButton * saveChangesButton;

/**
 * The TrailPointInfoViewController displaying this TrailPoint's info.
 */
@property (nonatomic, retain) TrailPointInfoViewController * infoController;

/**
 * Action response method for adding a photo.
 */
- (IBAction)addPhoto:(id)sender;

/**
 * Action response method for saving changes.
 */
- (IBAction)save:(id)sender;

@end
