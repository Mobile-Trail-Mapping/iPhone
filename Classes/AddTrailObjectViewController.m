//
//  AddTrailObjectViewController.m
//  MTM
//
//  Created by Tim Ekl on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddTrailObjectViewController.h"

#import "Setting.h"

#import "AddTrailViewController.h"
#import "AddTrailPointViewController.h"
#import "AddProblemReportViewController.h"

@implementation AddTrailObjectViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Add object";
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
}

#pragma mark - SettingsViewController subclass methods

- (void)buildSettings {
    self.settings = [[[MutableOrderedDictionary alloc] initWithCapacity:10] autorelease];
    
    Setting * addTrailSetting = [[[Setting alloc] initWithTitle:@"Trail" 
                                                         target:self 
                                                        onValue:NULL 
                                                       onAction:@selector(showAddTrail) 
                                                       onChange:NULL] autorelease];
    Setting * addTrailPointSetting = [[[Setting alloc] initWithTitle:@"Trail point" 
                                                              target:self 
                                                             onValue:NULL 
                                                            onAction:@selector(showAddTrailPoint) 
                                                            onChange:NULL] autorelease];
    NSArray * trailSettings = [[[NSArray alloc] initWithObjects:addTrailSetting, addTrailPointSetting, nil] autorelease];
    [self.settings setValue:trailSettings forKey:@"Trail objects"];
    
    Setting * addProblemReportSetting = [[[Setting alloc] initWithTitle:@"Problem report" 
                                                                 target:self 
                                                                onValue:NULL 
                                                               onAction:@selector(showAddProblemReport) 
                                                               onChange:NULL] autorelease];
    //addProblemReportSetting.enabled = NO;
    NSArray * problemSettings = [[[NSArray alloc] initWithObjects:addProblemReportSetting, nil] autorelease];
    [self.settings setValue:problemSettings forKey:@"Problems"];
}

#pragma mark - Button response methods

- (void)cancel {
    [self dismissModalViewControllerAnimated:YES];
}
                                                                                                                                
#pragma mark - Action callback methods

- (void)showAddTrail {
    AddTrailViewController * addController = [[[AddTrailViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil] autorelease];
    addController.primaryViewController = self.primaryViewController;
    [self.navigationController pushViewController:addController animated:YES];
}

- (void)showAddTrailPoint {
    AddTrailPointViewController * addController = [[[AddTrailPointViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil] autorelease];
    addController.primaryViewController = self.primaryViewController;
    [self.navigationController pushViewController:addController animated:YES];
}

- (void)showAddProblemReport {
    AddProblemReportViewController * addController = [[[AddProblemReportViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil] autorelease];
    addController.primaryViewController = self.primaryViewController;
    [self.navigationController pushViewController:addController animated:YES];
}

@end
