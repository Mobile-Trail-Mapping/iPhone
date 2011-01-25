#import "MainViewController.h"
#import "TrailPoint.h"
#import "MapView.h"

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

- (void)showInformationForTrailPoint:(TrailPoint *)trailPoint {
    NSLog(@"need to show info for trail point %@", trailPoint);
}

@end
