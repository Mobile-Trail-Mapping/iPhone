//
//  SettingsViewController.m
//  MTM
//
//  Created by Tim Ekl on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

@synthesize settings = _settings;

#pragma mark - Lifecycle

- (void)dealloc
{
    [_settings release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildSettings];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Configuration

- (void)buildSettings {
    self.settings = [[[MutableOrderedDictionary alloc] initWithCapacity:0] autorelease];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_settings count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_settings objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Setting * cellSetting = [[_settings objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = cellSetting.title;
    cell.detailTextLabel.text = [cellSetting value];
    
    if(cellSetting.enabled) {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    } else {
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    
    if(cellSetting.shouldShowDisclosure) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return ([[[_settings objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] enabled] ? indexPath : nil);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Setting * cellSetting = [[self.settings objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cellSetting performAction];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.settings keyAtIndex:section];
}

@end
