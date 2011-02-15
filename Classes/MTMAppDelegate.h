#import <UIKit/UIKit.h>

@class MainViewController;

/**
 * The application delegate for the MTM application. Creates the root view
 * controller (an instance of iPhoneViewController) and hands off
 * UI control to that instance.
 */
@interface MTMAppDelegate : NSObject <UIApplicationDelegate> {

@private
    UIWindow * _window;
    UIViewController * _viewController;
}

/**
 * The primary window for the application.
 */
@property (nonatomic, retain) IBOutlet UIWindow * window;

/**
 * The main view controller for the MTM application. An instance of
 * MainViewController.
 */
@property (nonatomic, retain) IBOutlet UIViewController * viewController;

@end

