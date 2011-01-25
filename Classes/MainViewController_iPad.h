#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface MainViewController_iPad : MainViewController {
    
@private
    // Needs the second underscore because apparently _popoverController
    // already exists
    UIPopoverController * __popoverController;
}

/**
 * The controller that manages information about popover views and presents
 * modal information about annotations.
 */
@property (nonatomic, retain) UIPopoverController * popoverController;

@end