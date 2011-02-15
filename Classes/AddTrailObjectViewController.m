//
//  AddTrailObjectViewController.m
//  MTM
//
//  Created by Tim Ekl on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddTrailObjectViewController.h"

#import "Setting.h"

@implementation AddTrailObjectViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Add object";
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark - SettingsViewController subclass methods

- (void)buildSettings {
    self.settings = [[[MutableOrderedDictionary alloc] initWithCapacity:10] autorelease];
    
    Setting * addTrailSetting = [[[Setting alloc] initWithTitle:@"Trail" target:self onValue:NULL onAction:NULL onChange:NULL] autorelease];
    Setting * addTrailPointSetting = [[[Setting alloc] initWithTitle:@"Trail point" target:self onValue:NULL onAction:NULL onChange:NULL] autorelease];
    addTrailSetting.enabled = NO; addTrailPointSetting.enabled = NO;
    NSArray * trailSettings = [[[NSArray alloc] initWithObjects:addTrailSetting, addTrailPointSetting, nil] autorelease];
    [self.settings setValue:trailSettings forKey:@"Trail objects"];
}

#pragma mark - Button response methods

- (void)cancel {
    [self dismissModalViewControllerAnimated:YES];
}

@end
