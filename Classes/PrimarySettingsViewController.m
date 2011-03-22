//
//  SettingsViewController.m
//  MTM
//
//  Created by Tim Ekl on 2/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PrimarySettingsViewController.h"

#import "AdvancedSettingsViewController.h"
#import "AboutViewController.h"
#import "PropertyEditorViewController.h"
#import "PropertyPickerViewController.h"

#import "ServiceAccountManager.h"
#import "ServiceAccount.h"

#import "StoredSettingsManager.h"

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

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [[ServiceAccountManager sharedManager] removeObserver:self forKeyPath:@"activeAccountAuthenticated"];
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
    
    Setting * mapTypeSetting = [[[Setting alloc] initWithTitle:@"Map type" 
                                                        target:self 
                                                       onValue:@selector(mapType) 
                                                      onAction:@selector(editMapType:) 
                                                      onChange:@selector(didChangeMapType:)] autorelease];
    Setting * zoomToUserSetting = [[[Setting alloc] initWithTitle:@"Zoom to user" target:self onValue:NULL onAction:NULL onChange:NULL] autorelease];
    zoomToUserSetting.enabled = NO;
    NSMutableArray * mapSettings = [[[NSMutableArray alloc] initWithObjects:mapTypeSetting, zoomToUserSetting, nil] autorelease];
    [self.settings setObject:mapSettings forKey:@"Map"];
    
    Setting * clearImagesSetting = [[[Setting alloc] initWithTitle:@"Clear cached images" 
                                                            target:self 
                                                           onValue:NULL 
                                                          onAction:@selector(clearCachedImages)
                                                          onChange:NULL] autorelease];
    NSMutableArray * cacheSettings = [[[NSMutableArray alloc] initWithObjects:clearImagesSetting, nil] autorelease];
    [self.settings setObject:cacheSettings forKey:@"Cache"];

    Setting * showAboutSetting = [[[Setting alloc] initWithTitle:@"About" target:self onValue:NULL onAction:@selector(showAboutSettings) onChange:NULL] autorelease];
    Setting * showAdvancedSetting = [[[Setting alloc] initWithTitle:@"Advanced" target:self onValue:NULL onAction:@selector(showAdvancedSettings) onChange:NULL] autorelease];
    showAdvancedSetting.shouldShowDisclosure = showAboutSetting.shouldShowDisclosure = YES;
    NSMutableArray * advancedSettings = [[[NSMutableArray alloc] initWithObjects:showAdvancedSetting, nil] autorelease];
    [self.settings setObject:advancedSettings forKey:@"Advanced"];
    

    
    NSMutableArray * aboutSettings = [[[NSMutableArray alloc] initWithObjects:showAboutSetting, nil] autorelease];
    [self.settings setObject:aboutSettings forKey:@"About"];
}

#pragma mark - Setting value callback methods

- (NSString *)activeAccountUser {
    NSLog(@"%@", [[ServiceAccountManager sharedManager] activeServiceAccount]);
    return [[[ServiceAccountManager sharedManager] activeServiceAccount] username];
}

- (NSString *)activeAccountPass {
    return [[[ServiceAccountManager sharedManager] activeServiceAccount] password];
}

- (NSString *)mapType {
    switch([[StoredSettingsManager sharedManager] mapType]) {
        case MKMapTypeStandard: return @"Standard"; break;
        case MKMapTypeSatellite: return @"Satellite"; break;
        case MKMapTypeHybrid: return @"Hybrid"; break;
        default: return @"Standard"; break;
    }
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

- (void)editMapType:(id)sender {
    NSArray * options = [[[NSArray alloc] initWithObjects:@"Standard", @"Satellite", @"Hybrid", nil] autorelease];
    PropertyPickerViewController * propertyController = [[[PropertyPickerViewController alloc] initWithSetting:sender options:options] autorelease];
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

- (void)showAboutSettings {
    AboutViewController * aboutController = [[[AboutViewController alloc] initWithNibName:@"AboutView" bundle:nil] autorelease];
    [self.navigationController pushViewController:aboutController animated:YES];
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

- (void)didChangeMapType:(NSString *)newTypeString {
    MKMapType newType = MKMapTypeStandard;
    if([newTypeString isEqualToString:@"Standard"]) {
        newType = MKMapTypeStandard;
    } else if([newTypeString isEqualToString:@"Satellite"]) {
        newType = MKMapTypeSatellite;
    } else if([newTypeString isEqualToString:@"Hybrid"]) {
        newType = MKMapTypeHybrid;
    }
    [[StoredSettingsManager sharedManager] setMapType:newType];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Dismiss

- (void)done {
    [self dismissModalViewControllerAnimated:YES];
}

@end
