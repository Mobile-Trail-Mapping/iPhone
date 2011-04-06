//
//  TrailPointInfoEditorViewController.m
//  MTM
//
//  Created by Tim Ekl on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TrailPointInfoEditorViewController.h"
#import "TrailPointInfoViewController.h"
#import "TrailPoint.h"

#import "NetworkOperation.h"
#import "NetworkOperationManager.h"

#import <MobileCoreServices/MobileCoreServices.h>


@implementation TrailPointInfoEditorViewController

@synthesize trailPoint = _trailPoint;

@synthesize conditionField = _conditionField;
@synthesize descriptionView = _descriptionView;
@synthesize addPhotoButton = _addPhotoButton;
@synthesize saveChangesButton = _saveChangesButton;

@synthesize infoController = _infoController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self addObserver:self forKeyPath:@"trailPoint" options:0 context:nil];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"trailPoint"];
    
    [_trailPoint release];
    
    [_conditionField release];
    [_descriptionView release];
    [_addPhotoButton release];
    [_newImage release];
    
    [_infoController release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.conditionField setText:self.trailPoint.condition];
    [self.descriptionView setText:self.trailPoint.desc];
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && 
       ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.addPhotoButton.enabled = NO;
    }
}

#pragma mark - Touch response

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.conditionField resignFirstResponder];
    [self.descriptionView resignFirstResponder];
}

#pragma mark - KVO methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"trailPoint"]) {
        NSLog(@"trail point changed; new info is %@, %@", self.trailPoint.condition, self.trailPoint.desc);
        self.navigationItem.title = self.trailPoint.title;
    }
}

#pragma mark - UIText{Field,View}Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.conditionField) {
        [self.conditionField resignFirstResponder];
        [self.descriptionView becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if(range.length == 0 && [text isEqualToString:@"\n"]) {
        [self.descriptionView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField == self.conditionField) {
        self.trailPoint.condition = self.conditionField.text;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if(textView == self.descriptionView) {
        self.trailPoint.desc = self.descriptionView.text;
    }
}

#pragma mark - IBActions

- (IBAction)addPhoto:(id)sender {
    if(_newImage == nil) {
        UIImagePickerController * pickerController = [[[UIImagePickerController alloc] init] autorelease];
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerController.delegate = self;
        [self presentModalViewController:pickerController animated:YES];
    } else {
        [_newImage release];
        _newImage = nil;
        [self.addPhotoButton setTitle:@"Add photo" forState:UIControlStateNormal];
    }
}

- (IBAction)save:(id)sender {
    NetworkOperation * editOperation = [[[NetworkOperation alloc] init] autorelease];
    editOperation.authenticate = YES;
    editOperation.label = @"MTMEditTrailPointOperation";
    editOperation.endpoint = [NSString stringWithFormat:@"point/update/%d", self.trailPoint.pointID];
    editOperation.requestType = kNetworkOperationRequestTypePost;
    editOperation.returnType = kNetworkOperationReturnTypeString;
    editOperation.requestData = [NSDictionary dictionaryWithObjectsAndKeys:self.conditionField.text, @"condition", self.descriptionView.text, @"desc", nil];
    [[NetworkOperationManager sharedManager] enqueueOperation:editOperation];
    
    NetworkOperation * photoOperation = [[[NetworkOperation alloc] init] autorelease];
    photoOperation.authenticate = YES;
    photoOperation.endpoint = @"image/add";
    photoOperation.requestType = kNetworkOperationRequestTypePost;
    photoOperation.returnType = kNetworkOperationReturnTypeData;
    photoOperation.label = @"MTMAddPhotoOperation";
    photoOperation.requestData = [NSDictionary dictionaryWithObjectsAndKeys:UIImageJPEGRepresentation(_newImage, 1.0), @"file", 
                                  [NSString stringWithFormat:@"%d", self.trailPoint.pointID], @"id", 
                                  nil];
    [[NetworkOperationManager sharedManager] enqueueOperation:photoOperation];
    
    [self.infoController registerImage:_newImage];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if([[info valueForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage]) {
        _newImage = [info valueForKey:UIImagePickerControllerEditedImage];
        if(_newImage == nil) {
            _newImage = [info valueForKey:UIImagePickerControllerOriginalImage];
        }
        [_newImage retain];
        NSLog(@"got photo %@", _newImage);
        [self.addPhotoButton setTitle:@"Clear new image" forState:UIControlStateNormal];
    } else {
        NSLog(@"returned media type was not image; failing...");
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

@end
