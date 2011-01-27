#import "TrailPointInfoViewController.h"
#import "TrailPoint.h"

@implementation TrailPointInfoViewController

@synthesize delegate = _delegate;
@synthesize trailPoint = _trailPoint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        [self addObserver:self forKeyPath:@"trailPoint" options:0 context:nil];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"trailPoint"];
    
    [super dealloc];
}

#pragma mark -
#pragma mark KVO methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"trailPoint"]) {
        NSLog(@"trail point changed in info view controller");
        
        self.navigationItem.title = self.trailPoint.title;
    }
}

#pragma mark -
#pragma mark IBActions

- (IBAction)dismiss:(id)sender {
    [self.delegate dismissModalController];
}

@end