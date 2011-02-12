//
//  SettingsViewController.m
//  MTM
//
//  Created by Tim Ekl on 2/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PrimarySettingsViewController.h"

@implementation PrimarySettingsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Settings";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)] autorelease];
}

- (void)buildSettings {
    self.settings = [[[MutableOrderedDictionary alloc] initWithCapacity:10] autorelease];
    
    Setting * usernameSetting = [[[Setting alloc] initWithTitle:@"Username" target:self onValue:NULL onAction:@selector(deselectCellAt:)] autorelease];
    Setting * passwordSetting = [[[Setting alloc] initWithTitle:@"Password" target:self onValue:NULL onAction:@selector(deselectCellAt:)] autorelease];
    usernameSetting.enabled = NO, passwordSetting.enabled = NO;
    NSMutableArray * userSettings = [[[NSMutableArray alloc] initWithObjects:usernameSetting, passwordSetting, nil] autorelease];
    [self.settings setObject:userSettings forKey:@"Authentication"];
    
    Setting * clearImagesSetting = [[[Setting alloc] initWithTitle:@"Clear cached images" target:self onValue:NULL onAction:@selector(clearCachedImages)] autorelease];
    NSMutableArray * cacheSettings = [[[NSMutableArray alloc] initWithObjects:clearImagesSetting, nil] autorelease];
    [self.settings setObject:cacheSettings forKey:@"Cache"];
    
    Setting * showAdvancedSetting = [[[Setting alloc] initWithTitle:@"Advanced" target:self onValue:NULL onAction:@selector(showAdvancedSettings)] autorelease];
    showAdvancedSetting.enabled = NO;
    NSMutableArray * advancedSettings = [[[NSMutableArray alloc] initWithObjects:showAdvancedSetting, nil] autorelease];
    [self.settings setObject:advancedSettings forKey:@"Advanced"];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    Setting * cellSetting = [[self.settings objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cellSetting performAction];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.settings keyAtIndex:section];
}

#pragma mark - Setting callback actions

- (void)clearCachedImages {
    [self.primaryViewController clearCachedImages];
}

#pragma mark -
#pragma mark Dismiss

- (void)done {
    [self dismissModalViewControllerAnimated:YES];
}

@end
