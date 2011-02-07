#import "MainViewController.h"
#import "TrailPoint.h"
#import "MapView.h"
#import "TrailPointInfoViewController.h"

@implementation MainViewController

@synthesize mapView = _mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.mapView = [[[MapView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    self.mapView.delegate = self;
	[self.view addSubview:self.mapView];
    self.view.clipsToBounds = NO;
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [self.mapView clearCachedImages];
    
    for(Trail * trail in self.mapView.trails) {
        for(TrailPoint * trailPoint in trail.trailPoints) {
            UINavigationController * navController = (UINavigationController *)(self.modalViewController);
            TrailPointInfoViewController * activeInfoController = (TrailPointInfoViewController *)([navController.viewControllers objectAtIndex:0]);
            if(activeInfoController.trailPoint != trailPoint) {
                trailPoint.images = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
            }
        }
    }
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

@end
