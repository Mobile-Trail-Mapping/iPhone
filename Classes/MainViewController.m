#import "MainViewController.h"
#import "TrailPoint.h"
#import "MapView.h"
#import "TrailPointInfoViewController.h"
#import "PrimarySettingsViewController.h"
#import "AddTrailObjectViewController.h"

#import "ServiceAccountManager.h"

@interface MainViewController()

/**
 * Whether this controller can display administrative portions of the user
 * interface. Determined by the presence of an authenticated account and
 * the existence of sufficient trail data.
 */
- (BOOL)canShowAdminUI;

/**
 * Notification callback of a change in the data that is required to show the
 * admin interface.
 */
- (void)adminDataDidChange;

@end

@implementation MainViewController

@synthesize mapView = _mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.mapView = [[[MapView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    self.mapView.delegate = self;
	[self.view addSubview:self.mapView];
    self.view.clipsToBounds = NO;
    self.view.backgroundColor = [UIColor blueColor];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleDone target:self action:@selector(showSettings)] autorelease];
    if([self canShowAdminUI]) {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddDialog)] autorelease];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adminDataDidChange) name:@"MTMAuthenticationStatusDidChange" object:nil];
    [[ServiceAccountManager sharedManager] refreshActiveAuthentication];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    UINavigationController * navController = (UINavigationController *)(self.modalViewController);
    TrailPointInfoViewController * activeInfoController = (TrailPointInfoViewController *)([navController.viewControllers objectAtIndex:0]);
    
    [self.mapView clearCachedImagesExceptForTrailPoint:activeInfoController.trailPoint];
}

- (void)dealloc {
    [super dealloc];
}

- (NSArray *)trails {
    return self.mapView.trails;
}

- (NSArray *)categories {
    return self.mapView.categories;
}

- (NSArray *)conditions {
    return self.mapView.conditions;
}
        
- (BOOL)canShowAdminUI {
    BOOL authenticated = [[ServiceAccountManager sharedManager] activeAccountAuthenticated];
    BOOL haveTrails = ([[self trails] count] > 0);
    BOOL haveCategories = ([[self categories] count] > 0);
    BOOL haveConditions = ([[self conditions] count] > 0);
    
    return authenticated && haveTrails && haveCategories && haveConditions;
}

- (void)adminDataDidChange {
    NSLog(@"notified of changed admin data");
    if([self canShowAdminUI]) {
        [self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                                                                                  target:self 
                                                                                                  action:@selector(showAddDialog)] autorelease] animated:YES];
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
}

#pragma mark -
#pragma mark Rotation methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

#pragma mark -
#pragma mark TrailActionDelegate methods

- (void)showInformationForTrailPoint:(TrailPoint *)trailPoint sender:(id)sender {
    NSLog(@"need to show info for trail point %@", trailPoint);
}

- (UIView *)calloutViewForTrailPointAnnotation:(MKAnnotationView *)annotation {
    return [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
}

- (void)trailObjectsDidChange {
    [self adminDataDidChange];
}

#pragma mark -
#pragma mark Settings methods

- (void)showSettings {
    PrimarySettingsViewController * settingsController = [[[PrimarySettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil] autorelease];
    settingsController.primaryViewController = self;
    UINavigationController * navController = [[[UINavigationController alloc] initWithRootViewController:settingsController] autorelease];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:navController animated:YES];
}

- (void)clearCachedImages {
    [self.mapView clearCachedImagesExceptForTrailPoint:nil];
}

#pragma mark -
#pragma mark Add methods

- (void)showAddDialog {
    AddTrailObjectViewController * addController = [[[AddTrailObjectViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil] autorelease];
    addController.primaryViewController = self;
    UINavigationController * navController = [[[UINavigationController alloc] initWithRootViewController:addController] autorelease];
    [self presentModalViewController:navController animated:YES];
}

@end
