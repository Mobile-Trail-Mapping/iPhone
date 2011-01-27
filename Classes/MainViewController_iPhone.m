#import "MainViewController_iPhone.h"
#import "TrailPointInfoViewController.h"

@implementation MainViewController_iPhone

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"iPhone view did load");
}

#pragma mark -
#pragma mark TrailActionDelegate methods

- (void)showInformationForTrailPoint:(TrailPoint *)trailPoint sender:(id)sender {
    [super showInformationForTrailPoint:trailPoint sender:sender];
    
    TrailPointInfoViewController * vc = [[[TrailPointInfoViewController alloc] initWithNibName:@"TrailPointInfoView" bundle:nil] autorelease];
    vc.trailPoint = trailPoint;
    [self.navigationController pushViewController:vc animated:YES];
}

@end