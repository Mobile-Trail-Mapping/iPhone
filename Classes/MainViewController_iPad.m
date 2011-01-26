#import "MainViewController_iPad.h"

#import "TrailPointInfoViewController.h"

@implementation MainViewController_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"iPad view did load");
}

#pragma mark -
#pragma mark TrailActionDelegate methods

- (void)showInformationForTrailPoint:(TrailPoint *)trailPoint sender:(id)sender {
    [super showInformationForTrailPoint:trailPoint sender:sender];
    
    TrailPointInfoViewController * vc = [[[TrailPointInfoViewController alloc] initWithNibName:@"TrailPointInfoView" bundle:nil] autorelease];    
    vc.delegate = self;
    UINavigationController * nav = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:nav animated:YES];
}

#pragma mark -
#pragma mark TrailPointInfoModalDelegate methods

- (void)dismissModalController {
    [self dismissModalViewControllerAnimated:YES];
}

@end