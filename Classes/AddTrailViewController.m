//
//  AddTrailViewController.m
//  MTM
//
//  Created by Tim Ekl on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddTrailViewController.h"

#import "PropertyEditorViewController.h"

@implementation AddTrailViewController

@synthesize trailName = _trailName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Trail";
    }
    return self;
}

- (void)dealloc {
    [_trailName release];
    
    [super dealloc];
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
                                                     onAction:NULL 
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
