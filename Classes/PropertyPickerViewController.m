//
//  PropertyPickerViewController.m
//  MTM
//
//  Created by Tim Ekl on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PropertyPickerViewController.h"

#import "Setting.h"

@implementation PropertyPickerViewController

@synthesize setting = _setting;
@synthesize options = _options;

#pragma mark - Lifecycle

- (id)initWithSetting:(Setting *)setting options:(NSArray *)options {
    if((self = [super initWithNibName:@"PropertyPickerView" bundle:nil])) {
        self.setting = setting;
        self.options = options;
    }
    return self;
}

- (void)dealloc {
    [_setting release];
    [_options release];
    
    [super dealloc];
}

#pragma mark - View controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [self.setting title];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [self.options objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.setting performChangeCallbackWithValue:[self.options objectAtIndex:indexPath.row]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
