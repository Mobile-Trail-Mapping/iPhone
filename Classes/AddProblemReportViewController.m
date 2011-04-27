//
//  AddProblemReportViewController.m
//  MTM
//
//  Created by Tim Ekl on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>

#import "AddProblemReportViewController.h"

#import "PropertyEditorViewController.h"

#import "NetworkOperation.h"
#import "NetworkOperationManager.h"
#import "NetworkOperationDelegate.h"

#import "ServiceAccountManager.h"
#import "ServiceAccount.h"

#import "ImageUtils.h"

@implementation AddProblemReportViewController

@synthesize currentLocation = _currentLocation;
@synthesize problemTitle = _problemTitle;
@synthesize problemDesc = _problemDesc;
@synthesize problemPhoto = _problemPhoto;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Problem";
        
        _problemPhotoDate = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
}

- (void)dealloc {
    for(id<NetworkOperationDelegate> delegate in _submitOperation.delegates) {
        [_submitOperation removeDelegate:delegate];
    }
    [_submitOperation release];
    
    [_problemTitle release];
    [_problemDesc release];
    [_problemPhoto release];
    [_problemPhotoDate release];
    [_locationManager release];
    
    [super dealloc];
}

#pragma mark - Settings methods

- (void)buildSettings {
    self.settings = [[[MutableOrderedDictionary alloc] initWithCapacity:2] autorelease];
    
    Setting * titleSetting = [[[Setting alloc] initWithTitle:@"Title" 
                                                      target:self 
                                                     onValue:@selector(problemTitle) 
                                                    onAction:@selector(editSetting:) 
                                                    onChange:@selector(titleChanged:)] autorelease];
    Setting * descSetting = [[[Setting alloc] initWithTitle:@"Description" 
                                                     target:self 
                                                    onValue:@selector(problemDesc) 
                                                   onAction:@selector(editSetting:) 
                                                   onChange:@selector(descChanged:)] autorelease];
    NSArray * infoSection = [[[NSArray alloc] initWithObjects:titleSetting, descSetting, nil] autorelease];
    [self.settings setValue:infoSection forKey:@"Info"];
    
    Setting * photoSetting = [[[Setting alloc] initWithTitle:@"Photo" 
                                                      target:self 
                                                     onValue:@selector(photoDate) 
                                                    onAction:@selector(takePhoto) 
                                                    onChange:NULL] autorelease];
    photoSetting.enabled = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    NSArray * photoSection = [[[NSArray alloc] initWithObjects:photoSetting, nil] autorelease];
    [self.settings setValue:photoSection forKey:@"Photo"];
    
    Setting * submitSetting = [[[Setting alloc] initWithTitle:@"Submit" target:self onValue:NULL onAction:@selector(submitProblemReport) onChange:NULL] autorelease];
    submitSetting.enabled = NO;
    NSArray * submitSection = [[[NSArray alloc] initWithObjects:submitSetting, nil] autorelease];
    [self.settings setValue:submitSection forKey:@"Submit"];
    
    [self tryEnableSubmit];
}

- (void)tryEnableSubmit {
    if(self.problemTitle != nil && self.problemDesc != nil && self.problemPhoto != nil &&
       [[[ServiceAccountManager sharedManager] activeServiceAccount] username] != nil) {
        [[[self.settings valueForKey:@"Submit"] objectAtIndex:0] setEnabled:YES];
    }
}

#pragma mark - Setting values methods

- (NSString *)photoDate {
    if(self.problemPhoto == nil || _problemPhotoDate == nil) {
        return @"No photo";
    }
    
    NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    return [NSString stringWithFormat:@"Taken %@", [formatter stringFromDate:_problemPhotoDate]];
}

#pragma mark - Setting action methods

- (void)editSetting:(id)sender {
    PropertyEditorViewController * editController = [[[PropertyEditorViewController alloc] initWithSetting:sender] autorelease];
    [self.navigationController pushViewController:editController animated:YES];
}

- (void)takePhoto {
    UIImagePickerController * imagePickerController = [[[UIImagePickerController alloc] init] autorelease];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    [self presentModalViewController:imagePickerController animated:YES];
}

- (void)submitProblemReport {
    [self performSelectorInBackground:@selector(threadProblemReport) withObject:nil];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)threadProblemReport {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    NetworkOperation * operation = [[[NetworkOperation alloc] init] autorelease];
    operation.authenticate = YES;
    operation.endpoint = @"problem/add";
    operation.requestType = kNetworkOperationRequestTypePost;
    operation.returnType = kNetworkOperationReturnTypeString;
    operation.label = [NSString stringWithFormat:@"Problem report %@", [NSDate date]];
    
    NSMutableDictionary * requestData = [[[NSMutableDictionary alloc] initWithCapacity:4] autorelease];
    [requestData setValue:self.problemTitle forKey:@"title"];
    [requestData setValue:self.problemDesc forKey:@"desc"];
    [requestData setValue:UIImageJPEGRepresentation(self.problemPhoto, 1.0) forKey:@"file"];
    [requestData setValue:[[[ServiceAccountManager sharedManager] activeServiceAccount] username] forKey:@"user"];    
    [requestData setValue:[NSString stringWithFormat:@"%f", self.currentLocation.latitude] forKey:@"lat"];
    [requestData setValue:[NSString stringWithFormat:@"%f", self.currentLocation.longitude] forKey:@"long"];
    operation.requestData = requestData;
    
    [operation addDelegate:self];
    [[NetworkOperationManager sharedManager] enqueueOperation:operation];
    _submitOperation = operation;
    [_submitOperation retain];
    
    [pool drain];
}

#pragma mark - Setting callback methods

- (void)titleChanged:(NSString *)title {
    self.problemTitle = title;
    [self.tableView reloadData];
    [self tryEnableSubmit];
}

- (void)descChanged:(NSString *)desc {
    self.problemDesc = desc;
    [self.tableView reloadData];
    [self tryEnableSubmit];
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if([[info valueForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage]) {
        self.problemPhoto = [info valueForKey:UIImagePickerControllerEditedImage];
        if(self.problemPhoto == nil) {
            self.problemPhoto = [info valueForKey:UIImagePickerControllerOriginalImage];
        }
        self.problemPhoto = scaleAndRotateImage(self.problemPhoto);
        _problemPhotoDate = [NSDate date];
        NSLog(@"got photo %@ with date %@", self.problemPhoto, _problemPhotoDate);
    }
    [self dismissModalViewControllerAnimated:YES];
    
    [self.tableView reloadData];
    [self tryEnableSubmit];
    
    NSLog(@"UIImage has orientation %d", self.problemPhoto.imageOrientation);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
    [self tryEnableSubmit];
}

#pragma mark - UITableViewDataSource method overrides

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if(indexPath.section == 1 && indexPath.row == 0) {
        cell.imageView.image = self.problemPhoto;
    }
    
    return cell;
}
 */

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"updating to location (%f,%f)", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    self.currentLocation = [newLocation coordinate];
    [self tryEnableSubmit];
}

#pragma mark - NetworkOperationDelegate methods

- (void)operationWasQueued:(NetworkOperation *)operation {
    NSLog(@"problem report operation was queued");
}

- (void)operationBegan:(NetworkOperation *)operation {
    NSLog(@"began problem report operation");
}

- (void)operation:(NetworkOperation *)operation completedWithResult:(id)result {
    NSLog(@"problem report operation completed. result: %@", result);
}

- (void)operation:(NetworkOperation *)operation didFailWithError:(NSError *)error {
    NSLog(@"problem report operation failed. error: %@", error);
}

@end
