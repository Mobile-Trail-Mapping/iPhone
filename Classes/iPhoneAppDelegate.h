#import <UIKit/UIKit.h>

@class MainViewController;

/**
 * The application delegate for the MTM iPhone app. Creates the root view
 * controller (an instance of iPhoneViewController) and hands off
 * UI control to that instance.
 */
@interface iPhoneAppDelegate : NSObject <UIApplicationDelegate> {

@private
    UIWindow * _window;
    MainViewController * _viewController;
}

/**
 * The primary window for the application.
 */
@property (nonatomic, retain) IBOutlet UIWindow *window;

/**
 * The main view controller for the iPhone application. An instance of
 * iPhoneViewController.
 */
@property (nonatomic, retain) IBOutlet MainViewController *viewController;

@end

