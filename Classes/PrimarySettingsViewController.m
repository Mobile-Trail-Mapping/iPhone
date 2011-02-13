//
//  SettingsViewController.m
//  MTM
//
//  Created by Tim Ekl on 2/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PrimarySettingsViewController.h"

#import "AdvancedSettingsViewController.h"
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
    
    Setting * usernameSetting = [[[Setting alloc] initWithTitle:@"Username" target:self onValue:@selector(activeAccountUser) onAction:NULL] autorelease];
    Setting * passwordSetting = [[[Setting alloc] initWithTitle:@"Password" target:self onValue:@selector(activeAccountPass) onAction:NULL] autorelease];
    passwordSetting.secure = YES;
    NSMutableArray * userSettings = [[[NSMutableArray alloc] initWithObjects:usernameSetting, passwordSetting, nil] autorelease];
    [self.settings setObject:userSettings forKey:@"Authentication"];
    
    Setting * clearImagesSetting = [[[Setting alloc] initWithTitle:@"Clear cached images" target:self onValue:NULL onAction:@selector(clearCachedImages)] autorelease];
    NSMutableArray * cacheSettings = [[[NSMutableArray alloc] initWithObjects:clearImagesSetting, nil] autorelease];
    [self.settings setObject:cacheSettings forKey:@"Cache"];
    
    Setting * showAdvancedSetting = [[[Setting alloc] initWithTitle:@"Advanced" target:self onValue:NULL onAction:@selector(showAdvancedSettings)] autorelease];
    showAdvancedSetting.shouldShowDisclosure = YES;
    NSMutableArray * advancedSettings = [[[NSMutableArray alloc] initWithObjects:showAdvancedSetting, nil] autorelease];
    [self.settings setObject:advancedSettings forKey:@"Advanced"];
}

#pragma mark - Setting value callback methods

- (NSString *)activeAccountUser {
    return [[[ServiceAccountManager sharedManager] activeServiceAccount] username];
}

- (NSString *)activeAccountPass {
    return [[[ServiceAccountManager sharedManager] activeServiceAccount] password];
}

#pragma mark - Setting action callback methods

- (void)clearCachedImages {
    [self.primaryViewController clearCachedImages];
}

- (void)showAdvancedSettings {
    AdvancedSettingsViewController * advancedController = [[[AdvancedSettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil] autorelease];
    advancedController.primaryViewController = self.primaryViewController;
    [self.navigationController pushViewController:advancedController animated:YES];
}

#pragma mark -
#pragma mark Dismiss

- (void)done {
    [self dismissModalViewControllerAnimated:YES];
}

@end
