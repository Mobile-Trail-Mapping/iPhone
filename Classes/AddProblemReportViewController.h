//
//  AddProblemReportViewController.h
//  MTM
//
//  Created by Tim Ekl on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTMSettingsViewController.h"


@interface AddProblemReportViewController : MTMSettingsViewController {
@private
    NSString * _problemTitle;
    NSString * _problemDesc;
}

@property (nonatomic, retain) NSString * problemTitle;
@property (nonatomic, retain) NSString * problemDesc;

@end
