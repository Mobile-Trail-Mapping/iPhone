//
//  AddTrailPointViewController.m
//  MTM
//
//  Created by Tim Ekl on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddTrailPointViewController.h"

#import "Setting.h"
#import "MutableOrderedDictionary.h"

#import "PropertyEditorViewController.h"
#import "PropertyPickerViewController.h"

#import "MainViewController.h"
#import "MapView.h"
#import "Trail.h"

#import "NetworkOperationManager.h"
#import "NetworkOperation.h"

#define MTM_CENTERED_LABEL_TAG 3141

@implementation AddTrailPointViewController

@synthesize currentLocation = _currentLocation;
@synthesize pointTitle = _pointTitle;
@synthesize pointDesc = _pointDesc;
@synthesize pointTrail = _pointTrail;
@synthesize pointCategory = _pointCategory;

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Add object";
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    self.pointTitle = @"Point";
    self.pointDesc = @"";
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [_locationManager stopUpdatingLocation];
}

- (void)dealloc {
    [_locationManager release];
    
    [_pointDesc release];
    [_pointTitle release];
    
    [super dealloc];
}

#pragma mark - SettingsViewController subclass methods

- (void)buildSettings {
    self.settings = [[[MutableOrderedDictionary alloc] initWithCapacity:10] autorelease];
    
    Setting * titleSetting = [[[Setting alloc] initWithTitle:@"Title" 
                                                      target:self 
                                                     onValue:@selector(pointTitle) 
                                                    onAction:@selector(editProperty:) 
                                                    onChange:@selector(didChangePointTitle:)] autorelease];
    Setting * descSetting = [[[Setting alloc] initWithTitle:@"Description" 
                                                     target:self 
                                                    onValue:@selector(pointDesc) 
                                                   onAction:@selector(editProperty:)  
                                                   onChange:@selector(didChangePointDesc:)] autorelease];
    Setting * conditionSetting = [[[Setting alloc] initWithTitle:@"Condition" 
                                                          target:self 
                                                         onValue:NULL 
                                                        onAction:NULL 
                                                        onChange:NULL] autorelease];
    conditionSetting.enabled = NO;
    NSArray * infoSettings = [[[NSArray alloc] initWithObjects:titleSetting, descSetting, conditionSetting, nil] autorelease];
    [self.settings setValue:infoSettings forKey:@"Info"];
    
    Setting * trailSetting = [[[Setting alloc] initWithTitle:@"Trail" 
                                                      target:self 
                                                     onValue:@selector(pointTrailString) 
                                                    onAction:@selector(pickProperty:) 
                                                    onChange:@selector(didChangePointTrailName:)] autorelease];
    Setting * categorySetting = [[[Setting alloc] initWithTitle:@"Category" 
                                                         target:self 
                                                        onValue:@selector(pointCategory) 
                                                       onAction:@selector(pickProperty:) 
                                                       onChange:@selector(didChangePointCategory:)] autorelease];
    NSArray * ownerSettings = [[[NSArray alloc] initWithObjects:trailSetting, categorySetting, nil] autorelease];
    [self.settings setValue:ownerSettings forKey:@"Ownership"];
    
    Setting * finishSetting = [[[Setting alloc] initWithTitle:@"Save point" target:self onValue:NULL onAction:@selector(addPoint) onChange:NULL] autorelease];
    NSArray * actionSettings = [[[NSArray alloc] initWithObjects:finishSetting, nil] autorelease];
    [self.settings setValue:actionSettings forKey:@""];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if(indexPath.section == self.settings.count - 1) {
        if([cell.contentView viewWithTag:MTM_CENTERED_LABEL_TAG] == nil) {
            NSLog(@"doing black magic to center text");
            cell.textLabel.alpha = 0.0f;
            
            UILabel * actualTextLabel = [[[UILabel alloc] initWithFrame:cell.contentView.bounds] autorelease];
            actualTextLabel.text = cell.textLabel.text;
            actualTextLabel.textAlignment = UITextAlignmentCenter;
            actualTextLabel.backgroundColor = [UIColor clearColor];
            actualTextLabel.font = [UIFont boldSystemFontOfSize:17.0];
            actualTextLabel.tag = MTM_CENTERED_LABEL_TAG;
            [cell.contentView addSubview:actualTextLabel];
        }
    }
    
    return cell;
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = [newLocation coordinate];
}

#pragma mark - Value callback methods

- (NSString *)latitudeString {
    return [NSString stringWithFormat:@"%f", self.currentLocation.latitude];
}

- (NSString *)longitudeString {
    return [NSString stringWithFormat:@"%f", self.currentLocation.longitude];
}

- (NSString *)pointTrailString {
    return self.pointTrail.name;
}

#pragma mark - Action callback methods

- (void)editProperty:(id)sender {
    PropertyEditorViewController * editController = [[[PropertyEditorViewController alloc] initWithSetting:sender] autorelease];
    [self.navigationController pushViewController:editController animated:YES];
}

- (void)pickProperty:(id)sender {
    // Build the right set of property options
    NSMutableArray * options = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    Setting * setting = (Setting *)sender;
    if([setting.title isEqualToString:@"Trail"]) {
        NSArray * trails = [self.primaryViewController trails];
        NSLog(@"main view controller has %d trails", [trails count]);
        for(Trail * trail in trails) {
            [options addObject:trail.name];
        }
    } else if([setting.title isEqualToString:@"Category"]) {
        options = [[self.primaryViewController categories] copy];
    }
    
    // Display the controller
    PropertyPickerViewController * pickController = [[[PropertyPickerViewController alloc] initWithSetting:setting options:options] autorelease];
    [self.navigationController pushViewController:pickController animated:YES];
}

- (void)addPoint {
    NetworkOperation * pointOperation = [[[NetworkOperation alloc] init] autorelease];
    pointOperation.label = @"MTMAddPointOperation";
    pointOperation.requestType = kNetworkOperationRequestTypePost;
    pointOperation.returnType = kNetworkOperationReturnTypeString;
    pointOperation.endpoint = @"point/add";
    pointOperation.authenticate = YES;
    
    NSMutableDictionary * requestData = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
    [requestData setValue:self.pointTrail.name forKey:@"trail"];
    [requestData setValue:self.pointTitle forKey:@"title"];
    [requestData setValue:self.pointDesc forKey:@"desc"];
    [requestData setValue:@"" forKey:@"condition"];
    [requestData setValue:self.pointCategory forKey:@"category"];
    [requestData setValue:@"" forKey:@"connections"];
    [requestData setValue:[NSString stringWithFormat:@"%f", self.currentLocation.latitude] forKey:@"lat"];
    [requestData setValue:[NSString stringWithFormat:@"%f", self.currentLocation.longitude] forKey:@"long"];
    pointOperation.requestData = requestData;
    
    [pointOperation addDelegate:self.primaryViewController.mapView];
    [[NetworkOperationManager sharedManager] enqueueOperation:pointOperation];
}

#pragma mark - Change callback methods

- (void)refreshTableDataForSectionTitle:(NSString *)sectionTitle {
    NSUInteger section = [self.settings indexOfKey:sectionTitle];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didChangePointTitle:(NSString *)newTitle {
    self.pointTitle = newTitle;
    [self refreshTableDataForSectionTitle:@"Info"];
}

- (void)didChangePointDesc:(NSString *)newDesc {
    self.pointDesc = newDesc;
    [self refreshTableDataForSectionTitle:@"Info"];
}

- (void)didChangePointTrailName:(NSString *)newTrailName {
    for(Trail * trail in [self.primaryViewController trails]) {
        if([trail.name isEqualToString:newTrailName]) {
            self.pointTrail = trail;
        }
    }
    [self refreshTableDataForSectionTitle:@"Ownership"];
}

- (void)didChangePointCategory:(NSString *)newCategory {
    self.pointCategory = newCategory;
    [self refreshTableDataForSectionTitle:@"Ownership"];
}

@end
