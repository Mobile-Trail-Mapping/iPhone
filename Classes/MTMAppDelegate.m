#import "MTMAppDelegate.h"
#import "MainViewController.h"

#import "StoredSettingsManager.h"
#import "ServiceAccount.h"
#import "ServiceAccountManager.h"

#if _MTM_DEBUG_USE_TEST_SERVER
#define MTM_SERVER_URL_STRING @"http://mtmtest.heroku.com/"
#elif _MTM_DEBUG_USE_LOCAL_SERVER
#define MTM_SERVER_URL_STRING @"http://mossberg.wlan.rose-hulman.edu:4567/"
#else
#define MTM_SERVER_URL_STRING [[StoredSettingsManager sharedManager] APIURL];
#endif

#if _MTM_DEBUG_SHIP_DEFAULT_ADMIN
#define MTM_SERVER_DEFAULT_ADMIN_USER @"test@brousalis.com"
#define MTM_SERVER_DEFAULT_ADMIN_PASS @"password"
#else
#define MTM_SERVER_DEFAULT_ADMIN_USER @""
#define MTM_SERVER_DEFAULT_ADMIN_PASS @""
#endif

@implementation MTMAppDelegate

@synthesize window;
@synthesize viewController;

#pragma mark - App lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {
#ifdef _MTM_DEBUG_FORCE_FIRST_RUN
    // Set the "first run" flag in settings
    [[StoredSettingsManager sharedManager] setIsFirstRun:YES];
    [[StoredSettingsManager sharedManager] writeSettingsToFile];
    
    // Clear existing service accounts
    for(ServiceAccount * account in [[ServiceAccountManager sharedManager] serviceAccounts]) {
        [[ServiceAccountManager sharedManager] removeAccount:account];
    }
    
#ifdef _MTM_DEBUG_REALLY_FORCE_IT
    NSMutableDictionary * keychainQuery = [[[NSMutableDictionary alloc] initWithCapacity:1] autorelease];
    [keychainQuery setValue:(id)kSecClassInternetPassword forKey:(id)kSecClass];
    NSAssert(SecItemDelete((CFDictionaryRef)keychainQuery) == noErr, @"Really forcing it, but still couldn't remove existing keychain accounts");
#endif
    
    // Add default service account
    NSURL * defaultURL = [NSURL URLWithString:MTM_SERVER_URL_STRING];
    NSLog(@"Using server url %@", [defaultURL absoluteString]);
    ServiceAccount * defaultAccount = [[[ServiceAccount alloc] initWithUsername:MTM_SERVER_DEFAULT_ADMIN_USER 
                                                                       password:MTM_SERVER_DEFAULT_ADMIN_PASS 
                                                                     serviceURL:defaultURL] autorelease];
    NSLog(@"Creating new default account %@", defaultAccount);
    [[ServiceAccountManager sharedManager] addAccount:defaultAccount];
    [[ServiceAccountManager sharedManager] setActiveServiceAccount:defaultAccount];
#endif
    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[StoredSettingsManager sharedManager] readSettingsFromFile];
    
    // First run?
    if([[StoredSettingsManager sharedManager] isFirstRun]) {
        /*
         [[[[UIAlertView alloc] initWithTitle:@"Hello world!" 
         message:@"This is the first run of the MTM application!" 
         delegate:nil 
         cancelButtonTitle:@"Cancel" 
         otherButtonTitles:@"OK", nil] autorelease] show];
         [[StoredSettingsManager sharedManager] setIsFirstRun:NO];
         */
        NSLog(@"First run!");
    }
    
    NSLog(@"Active service account has credentials %@:%@", [[[ServiceAccountManager sharedManager] activeServiceAccount] username], [[[ServiceAccountManager sharedManager] activeServiceAccount] password]);
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[StoredSettingsManager sharedManager] writeSettingsToFile];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[StoredSettingsManager sharedManager] writeSettingsToFile];
}

#pragma mark - Object lifecycle

- (void)dealloc {
    [_viewController release];
    [_window release];
    [super dealloc];
}

@end
