#import "TrailPointInfoViewController.h"

@implementation TrailPointInfoViewController

@synthesize dismissButton = _dismissButton;
@synthesize delegate = _delegate;

- (IBAction)dismiss:(id)sender {
    [self.delegate dismissModalController];
}

@end