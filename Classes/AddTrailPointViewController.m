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

@implementation AddTrailPointViewController

@synthesize currentLocation = _currentLocation;
@synthesize pointTitle = _pointTitle;
@synthesize pointDesc = _pointDesc;

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Add object";
    _locationManager = [[[CLLocationManager alloc] init] retain];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    _usingLocationManager = YES;
    
    self.pointTitle = @"Point";
    self.pointDesc = @"";
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [_locationManager stopUpdatingLocation];
}

- (void)dealloc {
    [_locationManager release];
    
    [super dealloc];
}

#pragma mark - SettingsViewController subclass methods

- (void)buildSettings {
    self.settings = [[[MutableOrderedDictionary alloc] initWithCapacity:10] autorelease];
    
    Setting * latitudeSetting = [[[Setting alloc] initWithTitle:@"Latitude" target:self onValue:@selector(latitudeString) onAction:NULL onChange:NULL] autorelease];
    Setting * longitudeSetting = [[[Setting alloc] initWithTitle:@"Longitude" target:self onValue:@selector(longitudeString) onAction:NULL onChange:NULL] autorelease];
    NSArray * locationSettings = [[[NSArray alloc] initWithObjects:latitudeSetting, longitudeSetting, nil] autorelease];
    [self.settings setValue:locationSettings forKey:@"Location"];
    
    Setting * titleSetting = [[[Setting alloc] initWithTitle:@"Title" target:self onValue:@selector(pointTitle) onAction:NULL onChange:NULL] autorelease];
    Setting * descSetting = [[[Setting alloc] initWithTitle:@"Description" target:self onValue:@selector(pointDesc) onAction:NULL onChange:NULL] autorelease];
    Setting * conditionSetting = [[[Setting alloc] initWithTitle:@"Condition" target:self onValue:NULL onAction:NULL onChange:NULL] autorelease];
    NSArray * infoSettings = [[[NSArray alloc] initWithObjects:titleSetting, descSetting, conditionSetting, nil] autorelease];
    [self.settings setValue:infoSettings forKey:@"Info"];
    
    Setting * trailSetting = [[[Setting alloc] initWithTitle:@"Trail" target:self onValue:NULL onAction:NULL onChange:NULL] autorelease];
    Setting * categorySetting = [[[Setting alloc] initWithTitle:@"Category" target:self onValue:NULL onAction:NULL onChange:NULL] autorelease];
    NSArray * ownerSettings = [[[NSArray alloc] initWithObjects:trailSetting, categorySetting, nil] autorelease];
    [self.settings setValue:ownerSettings forKey:@"Ownership"];
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if(_usingLocationManager) {
        self.currentLocation = [newLocation coordinate];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[self.settings indexOfKey:@"Location"]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Value callback methods

- (NSString *)latitudeString {
    return [NSString stringWithFormat:@"%f", self.currentLocation.latitude];
}

- (NSString *)longitudeString {
    return [NSString stringWithFormat:@"%f", self.currentLocation.longitude];
}

@end
