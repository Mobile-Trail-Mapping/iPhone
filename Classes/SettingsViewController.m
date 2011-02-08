//
//  SettingsViewController.m
//  MTM
//
//  Created by Tim Ekl on 2/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "Setting.h"

#import "MainViewController.h"
#import "MutableOrderedDictionary.h"

@implementation SettingsViewController

@synthesize primaryViewController = _primaryViewController;

- (void)dealloc
{
    [_settings release];
    
    [super dealloc];
}

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
    
    _settings = [[[MutableOrderedDictionary alloc] initWithCapacity:10] retain];
    
    Setting * usernameSetting = [[[Setting alloc] initWithTitle:@"Username" target:self onValue:NULL onAction:@selector(deselectCellAt:)] autorelease];
    Setting * passwordSetting = [[[Setting alloc] initWithTitle:@"Password" target:self onValue:NULL onAction:@selector(deselectCellAt:)] autorelease];
    NSMutableArray * userSettings = [[[NSMutableArray alloc] initWithObjects:usernameSetting, passwordSetting, nil] autorelease];
    [_settings setObject:userSettings forKey:@"Authentication"];
    
    Setting * clearImagesSetting = [[[Setting alloc] initWithTitle:@"Clear cached images" target:self onValue:NULL onAction:@selector(clearCachedImages)] autorelease];
    NSMutableArray * cacheSettings = [[[NSMutableArray alloc] initWithObjects:clearImagesSetting, nil] autorelease];
    [_settings setObject:cacheSettings forKey:@"Cache"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_settings count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
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
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
    Setting * cellSetting = [[_settings objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cellSetting performAction];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_settings keyAtIndex:section];
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
