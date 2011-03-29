//
//  AdvancedSettingsViewController.m
//  MTM
//
//  Created by Tim Ekl on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AdvancedSettingsViewController.h"

#import "StoredSettingsManager.h"

#import "PropertyEditorViewController.h"

@implementation AdvancedSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Advanced";
}

- (void)buildSettings {
    self.settings = [[[MutableOrderedDictionary alloc] initWithCapacity:10] autorelease];
    
    Setting * apiLocationSetting = [[[Setting alloc] initWithTitle:@"API Location" 
                                                            target:self 
                                                           onValue:@selector(APILocation) 
                                                          onAction:@selector(editAPILocation:) 
                                                          onChange:@selector(APILocationChanged:)] autorelease];
    NSMutableArray * networkSettings = [[[NSMutableArray alloc] initWithObjects:apiLocationSetting, nil] autorelease];
    [self.settings setObject:networkSettings forKey:@"Network"];
}

- (NSString *)APILocation {
    return [[[StoredSettingsManager sharedManager] APIURL] absoluteString];
}

- (void)editAPILocation:(id)sender {
    PropertyEditorViewController * propertyController = [[[PropertyEditorViewController alloc] initWithSetting:sender] autorelease];
    [self.navigationController pushViewController:propertyController animated:YES];
}

- (void)APILocationChanged:(NSString *)newLoc {
    [[StoredSettingsManager sharedManager] setAPIURL:[NSURL URLWithString:newLoc]];
    [self.tableView reloadData];
}

@end
