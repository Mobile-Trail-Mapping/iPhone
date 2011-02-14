//
//  SettingsViewController.m
//  MTM
//
//  Created by Tim Ekl on 2/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PrimarySettingsViewController.h"

#import "AdvancedSettingsViewController.h"
#import "PropertyEditorViewController.h"
#import "ServiceAccountManager.h"
#import "ServiceAccount.h"

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
    
    Setting * usernameSetting = [[[Setting alloc] initWithTitle:@"Username" 
                                                         target:self 
                                                        onValue:@selector(activeAccountUser) 
                                                       onAction:@selector(editActiveAccountUser:)
                                                       onChange:@selector(didChangeActiveAccountUser:)] autorelease];
    Setting * passwordSetting = [[[Setting alloc] initWithTitle:@"Password" 
                                                         target:self 
                                                        onValue:@selector(activeAccountPass) 
                                                       onAction:@selector(editActiveAccountPass:)
                                                       onChange:@selector(didChangeActiveAccountPass:)] autorelease];
    passwordSetting.secure = YES;
    NSMutableArray * userSettings = [[[NSMutableArray alloc] initWithObjects:usernameSetting, passwordSetting, nil] autorelease];
    [self.settings setObject:userSettings forKey:@"Authentication"];
    
    Setting * clearImagesSetting = [[[Setting alloc] initWithTitle:@"Clear cached images" 
                                                            target:self 
                                                           onValue:NULL 
                                                          onAction:@selector(clearCachedImages)
                                                          onChange:NULL] autorelease];
    NSMutableArray * cacheSettings = [[[NSMutableArray alloc] initWithObjects:clearImagesSetting, nil] autorelease];
    [self.settings setObject:cacheSettings forKey:@"Cache"];
    
    Setting * showAdvancedSetting = [[[Setting alloc] initWithTitle:@"Advanced" 
                                                             target:self 
                                                            onValue:NULL 
                                                           onAction:@selector(showAdvancedSettings)
                                                           onChange:NULL] autorelease];
    showAdvancedSetting.shouldShowDisclosure = YES;
    NSMutableArray * advancedSettings = [[[NSMutableArray alloc] initWithObjects:showAdvancedSetting, nil] autorelease];
    [self.settings setObject:advancedSettings forKey:@"Advanced"];
}

#pragma mark - Setting value callback methods

- (NSString *)activeAccountUser {
    NSLog(@"%@", [[ServiceAccountManager sharedManager] activeServiceAccount]);
    return [[[ServiceAccountManager sharedManager] activeServiceAccount] username];
}

- (NSString *)activeAccountPass {
    return [[[ServiceAccountManager sharedManager] activeServiceAccount] password];
}

#pragma mark - Setting action callback methods

- (void)editActiveAccountUser:(id)sender {
    PropertyEditorViewController * propertyController = [[[PropertyEditorViewController alloc] initWithSetting:sender] autorelease];
    [self.navigationController pushViewController:propertyController animated:YES];
}

- (void)editActiveAccountPass:(id)sender {
    PropertyEditorViewController * propertyController = [[[PropertyEditorViewController alloc] initWithSetting:sender] autorelease];
    [self.navigationController pushViewController:propertyController animated:YES];
}

- (void)clearCachedImages {
    [self.primaryViewController clearCachedImages];
}

- (void)showAdvancedSettings {
    AdvancedSettingsViewController * advancedController = [[[AdvancedSettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil] autorelease];
    advancedController.primaryViewController = self.primaryViewController;
    [self.navigationController pushViewController:advancedController animated:YES];
}

#pragma mark - Setting change callback methods

- (void)didChangeActiveAccountUser:(NSString *)user {
    ServiceAccount * activeAccount = [[ServiceAccountManager sharedManager] activeServiceAccount];
    activeAccount.username = user;
    [[ServiceAccountManager sharedManager] updateAccount:activeAccount];
    [self.tableView reloadData];
}

- (void)didChangeActiveAccountPass:(NSString *)pass {
    ServiceAccount * activeAccount = [[ServiceAccountManager sharedManager] activeServiceAccount];
    activeAccount.password = pass;
    [[ServiceAccountManager sharedManager] updateAccount:activeAccount];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Dismiss

- (void)done {
    [self dismissModalViewControllerAnimated:YES];
}

@end
