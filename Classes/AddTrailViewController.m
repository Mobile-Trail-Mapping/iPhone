//
//  AddTrailViewController.m
//  MTM
//
//  Created by Tim Ekl on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddTrailViewController.h"

#import "MainViewController.h"
#import "MapView.h"

#import "PropertyEditorViewController.h"

#import "NetworkOperation.h"
#import "NetworkOperationManager.h"
#import "NetworkOperationDelegate.h"

@implementation AddTrailViewController

@synthesize currentLocation = _currentLocation;
@synthesize trailName = _trailName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Trail";
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
    [_trailName release];
    [_locationManager release];
    
    [super dealloc];
}

#pragma mark - Location

- (NSString *)latitudeString {
    return [NSString stringWithFormat:@"%f", self.currentLocation.latitude];
}

- (NSString *)longitudeString {
    return [NSString stringWithFormat:@"%f", self.currentLocation.longitude];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"updating to location (%f,%f)", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    self.currentLocation = [newLocation coordinate];
}

#pragma mark - Settings

- (void)buildSettings {
    self.settings = [[[MutableOrderedDictionary alloc] initWithCapacity:2] autorelease];
    
    Setting * nameSetting = [[[Setting alloc] initWithTitle:@"Name" 
                                                     target:self 
                                                    onValue:@selector(trailName) 
                                                   onAction:@selector(editProperty:) 
                                                   onChange:@selector(trailNameChanged:)] autorelease];
    NSArray * infoSection = [NSArray arrayWithObject:nameSetting];
    [self.settings setValue:infoSection forKey:@"Info"];
    
    Setting * submitSetting = [[[Setting alloc] initWithTitle:@"Submit" 
                                                       target:self 
                                                      onValue:NULL 
                                                     onAction:@selector(confirmSubmitTrail) 
                                                     onChange:NULL] autorelease];
    submitSetting.enabled = NO;
    NSArray * submitSection = [NSArray arrayWithObject:submitSetting];
    [self.settings setValue:submitSection forKey:@"Submit"];
}

#pragma mark - Settings edit actions

- (void)editProperty:(id)sender {
    PropertyEditorViewController * editController = [[[PropertyEditorViewController alloc] initWithSetting:sender] autorelease];
    [self.navigationController pushViewController:editController animated:YES];
}

- (void)confirmSubmitTrail {
    [[[[UIAlertView alloc] initWithTitle:@"Confirm" 
                                 message:@"You are about to create a new trail."
                                            "This trail will be immediately visible to everyone, with a trail head at your current location."
                                            "Are you sure?" 
                                delegate:self 
                       cancelButtonTitle:@"Cancel" 
                       otherButtonTitles:@"OK", nil] autorelease] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        // Canceled. Do nothing.
    } else {
        // OK. Proceed
        NetworkOperation * operation = [[[NetworkOperation alloc] init] autorelease];
        operation.label = @"MTMAddTrailOperation";
        operation.endpoint = @"trail/add";
        operation.requestType = kNetworkOperationRequestTypePost;
        operation.returnType = kNetworkOperationReturnTypeString;
        operation.authenticate = YES;
        operation.requestData = [[NSDictionary dictionaryWithObjectsAndKeys:self.trailName, @"name", nil] mutableCopy];
        [operation addDelegate:self.primaryViewController.mapView];
        [[NetworkOperationManager sharedManager] enqueueOperation:operation];
        
        NetworkOperation * pointOperation = [[[NetworkOperation alloc] init] autorelease];
        pointOperation.label = @"MTMAddPointOperation";
        pointOperation.requestType = kNetworkOperationRequestTypePost;
        pointOperation.returnType = kNetworkOperationReturnTypeString;
        pointOperation.endpoint = @"point/add";
        pointOperation.authenticate = YES;
        
        NSMutableDictionary * requestData = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
        [requestData setValue:self.trailName forKey:@"trail"];
        [requestData setValue:[NSString stringWithFormat:@"%@ Trail Head", self.trailName] forKey:@"title"];
        [requestData setValue:[NSString stringWithFormat:@"Starting point for %@", self.trailName] forKey:@"desc"];
        [requestData setValue:@"Open" forKey:@"condition"];
        [requestData setValue:@"Trailhead" forKey:@"category"];
        //[requestData setValue:@"" forKey:@"connections"]; // No connections for now - TODO?
        [requestData setValue:[self latitudeString] forKey:@"lat"];
        [requestData setValue:[self longitudeString] forKey:@"long"];
        pointOperation.requestData = requestData;
        
        [pointOperation addDelegate:self.primaryViewController.mapView];
        [[NetworkOperationManager sharedManager] enqueueOperation:pointOperation];
        
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark - Settings callbacks

- (void)trailNameChanged:(NSString *)name {
    if(name != nil && ![name isEqualToString:@""]) {
        [[[self.settings valueForKey:@"Submit"] objectAtIndex:0] setEnabled:YES];
    } else {
        [[[self.settings valueForKey:@"Submit"] objectAtIndex:0] setEnabled:NO];
    }
    self.trailName = name;
    [self.tableView reloadData];
}

#pragma mark - UITableView bonus stuff

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if(section == [self.settings count] - 1) {
        return @"Your current location will be used as the first point in this trail.";
    } else {
        return nil;
    }
}

@end
