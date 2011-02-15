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

@implementation AddTrailPointViewController

@synthesize currentLocation = _currentLocation;
@synthesize pointTitle = _pointTitle;
@synthesize pointDesc = _pointDesc;

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
    Setting * conditionSetting = [[[Setting alloc] initWithTitle:@"Condition" target:self onValue:NULL onAction:NULL onChange:NULL] autorelease];
    NSArray * infoSettings = [[[NSArray alloc] initWithObjects:titleSetting, descSetting, conditionSetting, nil] autorelease];
    [self.settings setValue:infoSettings forKey:@"Info"];
    
    Setting * trailSetting = [[[Setting alloc] initWithTitle:@"Trail" target:self onValue:NULL onAction:NULL onChange:NULL] autorelease];
    Setting * categorySetting = [[[Setting alloc] initWithTitle:@"Category" target:self onValue:NULL onAction:NULL onChange:NULL] autorelease];
    NSArray * ownerSettings = [[[NSArray alloc] initWithObjects:trailSetting, categorySetting, nil] autorelease];
    [self.settings setValue:ownerSettings forKey:@"Ownership"];
    
    Setting * finishSetting = [[[Setting alloc] initWithTitle:@"Save point" target:self onValue:NULL onAction:NULL onChange:NULL] autorelease];
    NSArray * actionSettings = [[[NSArray alloc] initWithObjects:finishSetting, nil] autorelease];
    [self.settings setValue:actionSettings forKey:@""];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if(indexPath.section == self.settings.count - 1) {
        NSLog(@"doing black magic to center text");
        cell.textLabel.alpha = 0.0f;
        
        UILabel * actualTextLabel = [[[UILabel alloc] initWithFrame:cell.contentView.bounds] autorelease];
        actualTextLabel.text = cell.textLabel.text;
        actualTextLabel.textAlignment = UITextAlignmentCenter;
        actualTextLabel.backgroundColor = [UIColor clearColor];
        actualTextLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [cell.contentView addSubview:actualTextLabel];
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

#pragma mark - Action callback methods

- (void)editProperty:(id)sender {
    PropertyEditorViewController * editController = [[[PropertyEditorViewController alloc] initWithSetting:sender] autorelease];
    [self.navigationController pushViewController:editController animated:YES];
}

#pragma mark - Change callback methods

- (void)didChangePointTitle:(NSString *)newTitle {
    self.pointTitle = newTitle;
    NSUInteger section = [self.settings indexOfKey:@"Info"];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didChangePointDesc:(NSString *)newDesc {
    self.pointDesc = newDesc;
    NSUInteger section = [self.settings indexOfKey:@"Info"];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}

@end
