#import "MTMAppDelegate.h"
#import "MainViewController.h"

#import "StoredSettingsManager.h"

@implementation MTMAppDelegate

@synthesize window;
@synthesize viewController;

#pragma mark - App lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
    
#ifdef _MTM_DEBUG_FORCE_FIRST_RUN
    [[StoredSettingsManager sharedManager] setIsFirstRun:YES];
    [[StoredSettingsManager sharedManager] writeSettingsToFile];
#endif
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[StoredSettingsManager sharedManager] readSettingsFromFile];
    
    // First run?
    if([[StoredSettingsManager sharedManager] isFirstRun]) {
        [[[[UIAlertView alloc] initWithTitle:@"Hello world!" 
                                     message:@"This is the first run of the MTM application!" 
                                    delegate:nil 
                           cancelButtonTitle:@"Cancel" 
                           otherButtonTitles:@"OK", nil] autorelease] show];
        [[StoredSettingsManager sharedManager] setIsFirstRun:NO];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[StoredSettingsManager sharedManager] writeSettingsToFile];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[StoredSettingsManager sharedManager] writeSettingsToFile];
}

#pragma mark - Object lifecycle

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

@end
