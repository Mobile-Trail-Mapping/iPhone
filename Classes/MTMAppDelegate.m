#import "MTMAppDelegate.h"
#import "MainViewController.h"

@implementation MTMAppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // First run?
    
    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

@end
