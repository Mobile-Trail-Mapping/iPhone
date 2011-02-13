#import "MTMAppDelegate.h"
#import "MainViewController.h"

#import "StoredSettingsManager.h"

@implementation MTMAppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // First run?
    if([[StoredSettingsManager sharedManager] isFirstRun]) {
        [[[[UIAlertView alloc] initWithTitle:@"Hello world!" 
                                     message:@"This is the first run of the MTM application!" 
                                    delegate:nil 
                           cancelButtonTitle:@"Cancel" 
                           otherButtonTitles:@"OK", nil] autorelease] show];
    }
    
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
