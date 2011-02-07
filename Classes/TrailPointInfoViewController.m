#import "TrailPointInfoViewController.h"
#import "TrailPoint.h"

@implementation TrailPointInfoViewController

@synthesize delegate = _delegate;
@synthesize trailPoint = _trailPoint;

@synthesize imageView = _imageView;
@synthesize conditionLabel = _conditionLabel;
@synthesize descLabel = _descLabel;
@synthesize activityIndicatorView = _activityIndicatorView;

#define IMAGE_DISPLAY_DURATION 5.0

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        [self addObserver:self forKeyPath:@"trailPoint" options:0 context:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"formatting trail head description %@", self.trailPoint.desc);
    NSString * conditionString = [NSString stringWithFormat:@"Condition: %@", self.trailPoint.condition];
    self.conditionLabel.text = conditionString;
    self.conditionLabel.font = [UIFont boldSystemFontOfSize:17.0];
    CGSize contentSize = [self.trailPoint.desc sizeWithFont:self.descLabel.font forWidth:self.descLabel.frame.size.width lineBreakMode:UILineBreakModeWordWrap];
    self.descLabel.frame = CGRectMake(self.descLabel.frame.origin.x, self.descLabel.frame.origin.y, self.descLabel.frame.size.width, contentSize.height);
    self.descLabel.text = self.trailPoint.desc;
    
    if(self.trailPoint.images.count == 0) {
        [self performSelectorInBackground:@selector(loadRemoteImage) withObject:nil];
    } else {
        [self startImageAnimations];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_imageAnimationTimer invalidate];
    [_imageAnimationTimer release];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"trailPoint"];
    
    [_trailPoint release];
    [_imageView release];
    [_conditionLabel release];
    [_descLabel release];
    [_activityIndicatorView release];
    
    NSLog(@"dealloc %@", self);
    
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

#pragma mark -
#pragma mark Async image-loading methods

- (void)showFailureImage {
    [self.imageView setImage:[UIImage imageNamed:@"redx.png"]];
}

- (void)loadRemoteImage {
    NSLog(@"loading remote images");
    NSLog(@"  for point with ID %d", self.trailPoint.pointID);
    NSInteger trailPointID = self.trailPoint.pointID;
    
    NSAutoreleasePool * threadPool = [[NSAutoreleasePool alloc] init];
    
    [self.activityIndicatorView performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:YES];
    
    NSString * imageCountURLString = [[[NSString alloc] initWithFormat:@"http://mtmserver.heroku.com/image/get/%d", trailPointID] autorelease];
    NSURL * imageCountURL = [[[NSURL alloc] initWithString:imageCountURLString] autorelease];
    NSStringEncoding usedEncoding;
    NSError * error;
    NSString * imageCountString = [[[NSString alloc] initWithContentsOfURL:imageCountURL usedEncoding:&usedEncoding error:&error] autorelease];
    
    if(imageCountString == nil) {
        [self showFailureImage];
    } else {
        NSScanner * imageCountScanner = [[[NSScanner alloc] initWithString:imageCountString] autorelease];
        NSInteger imageCount = 0;
        if(![imageCountScanner scanInteger:&imageCount] || imageCount == 0) {
            [self showFailureImage];
        } else {
            NSLog(@"Found %d images for trail point with ID %d", imageCount, self.trailPoint.pointID);
            
            for(int i = 0; i < imageCount; i++) {
                NSString * imageURLString = [[[NSString alloc] initWithFormat:@"http://mtmserver.heroku.com/image/get/%d/%d", trailPointID, i] autorelease];
                NSURL * imageURL = [[[NSURL alloc] initWithString:imageURLString] autorelease];
                NSData * data = [[[NSData alloc] initWithContentsOfURL:imageURL] autorelease];
                if(data != nil) {
                    UIImage * image = [[[UIImage alloc] initWithData:data] autorelease];
                    [self registerImage:image];
                }
            }
        }
    }
    
    [self.activityIndicatorView performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(startImageAnimations) withObject:nil waitUntilDone:NO];
    
    [threadPool drain];
}

- (void)registerImage:(UIImage *)image {
    [self.trailPoint.images addObject:image];
}

#pragma mark -
#pragma mark Image animation methods

- (void)startImageAnimations {
    self.imageView.image = [self.trailPoint.images objectAtIndex:0];
    _imageAnimationTimer = [[NSTimer timerWithTimeInterval:IMAGE_DISPLAY_DURATION target:self selector:@selector(cycleImage) userInfo:nil repeats:YES] retain];
    [[NSRunLoop mainRunLoop] addTimer:_imageAnimationTimer forMode:NSDefaultRunLoopMode];
}

- (void)cycleImage {
    NSLog(@"%@ cycling image", self);
    
    NSInteger currentIndex = [self.trailPoint.images indexOfObject:self.imageView.image];
    NSInteger nextIndex = (currentIndex + 1) % self.trailPoint.images.count;
    
    _transitionImageView = [[[UIImageView alloc] initWithFrame:self.imageView.frame] retain];
    _transitionImageView.alpha = 0.0f;
    _transitionImageView.image = [self.trailPoint.images objectAtIndex:nextIndex];
    _transitionImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_transitionImageView];
    
    [UIView beginAnimations:@"UIImageView transitions" context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [_transitionImageView setAlpha:1.0f];
    [UIView commitAnimations];
}

 - (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
     NSInteger currentIndex = [self.trailPoint.images indexOfObject:self.imageView.image];
     NSInteger nextIndex = (currentIndex + 1) % self.trailPoint.images.count;
     self.imageView.image = [self.trailPoint.images objectAtIndex:nextIndex];
     
     [_transitionImageView removeFromSuperview];
     [_transitionImageView release];
     _transitionImageView = nil;
}

@end