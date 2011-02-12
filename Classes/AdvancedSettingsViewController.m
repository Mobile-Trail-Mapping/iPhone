//
//  AdvancedSettingsViewController.m
//  MTM
//
//  Created by Tim Ekl on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AdvancedSettingsViewController.h"


@implementation AdvancedSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Settings";
}

- (void)buildSettings {
    self.settings = [[[MutableOrderedDictionary alloc] initWithCapacity:10] autorelease];
    
    Setting * apiLocationSetting = [[[Setting alloc] initWithTitle:@"API Location" target:self onValue:NULL onAction:NULL] autorelease];
    NSMutableArray * networkSettings = [[[NSMutableArray alloc] initWithObjects:apiLocationSetting, nil] autorelease];
    [self.settings setObject:networkSettings forKey:@"Network"];
}

@end
