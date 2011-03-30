//
//  AddProblemReportViewController.m
//  MTM
//
//  Created by Tim Ekl on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddProblemReportViewController.h"

#import "PropertyEditorViewController.h"

@implementation AddProblemReportViewController

@synthesize problemTitle = _problemTitle;
@synthesize problemDesc = _problemDesc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Problem";
    }
    return self;
}

- (void)dealloc {
    [_problemTitle release];
    [_problemDesc release];
    
    [super dealloc];
}

#pragma mark - Settings methods

- (void)buildSettings {
    self.settings = [[[MutableOrderedDictionary alloc] initWithCapacity:2] autorelease];
    
    Setting * titleSetting = [[[Setting alloc] initWithTitle:@"Title" 
                                                      target:self 
                                                     onValue:@selector(problemTitle) 
                                                    onAction:@selector(editSetting:) 
                                                    onChange:@selector(titleChanged:)] autorelease];
    Setting * descSetting = [[[Setting alloc] initWithTitle:@"Description" 
                                                     target:self 
                                                    onValue:@selector(problemDesc) 
                                                   onAction:@selector(editSetting:) 
                                                   onChange:@selector(descChanged:)] autorelease];
    NSArray * infoSection = [[[NSArray alloc] initWithObjects:titleSetting, descSetting, nil] autorelease];
    [self.settings setValue:infoSection forKey:@"Info"];
    
    Setting * photoSetting = [[[Setting alloc] initWithTitle:@"Photo" target:self onValue:NULL onAction:NULL onChange:NULL] autorelease];
    photoSetting.enabled = NO;
    NSArray * photoSection = [[[NSArray alloc] initWithObjects:photoSetting, nil] autorelease];
    [self.settings setValue:photoSection forKey:@"Photo"];
}

- (void)editSetting:(id)sender {
    PropertyEditorViewController * editController = [[[PropertyEditorViewController alloc] initWithSetting:sender] autorelease];
    [self.navigationController pushViewController:editController animated:YES];
}

- (void)titleChanged:(NSString *)title {
    self.problemTitle = title;
    [self.tableView reloadData];
}

- (void)descChanged:(NSString *)desc {
    self.problemDesc = desc;
    [self.tableView reloadData];
}

@end
