#import "MainViewController.h"
#import "TrailPoint.h"
#import "MapView.h"
#import "TrailPointInfoViewController.h"
#import "SettingsViewController.h"

@implementation MainViewController

@synthesize mapView = _mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.mapView = [[[MapView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    self.mapView.delegate = self;
	[self.view addSubview:self.mapView];
    self.view.clipsToBounds = NO;
    self.view.backgroundColor = [UIColor blueColor];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleDone target:self action:@selector(showSettings)] autorelease];
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

#pragma mark -
#pragma mark Settings methods

- (void)showSettings {
    SettingsViewController * settingsController = [[[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil] autorelease];
    settingsController.primaryViewController = self;
    UINavigationController * navController = [[[UINavigationController alloc] initWithRootViewController:settingsController] autorelease];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:navController animated:YES];
}

- (void)clearCachedImages {
    [self.mapView clearCachedImagesExceptForTrailPoint:nil];
}

@end
