#import "TrailPointInfoViewController.h"
#import "TrailPoint.h"

@implementation TrailPointInfoViewController

@synthesize delegate = _delegate;
@synthesize trailPoint = _trailPoint;

@synthesize imageView = _imageView;
@synthesize tableView = _tableView;
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize images = _images;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        [self addObserver:self forKeyPath:@"trailPoint" options:0 context:nil];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    if(self.imageView.image == nil) {
        [self performSelectorInBackground:@selector(loadRemoteImage) withObject:nil];
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"trailPoint"];
    
    [_trailPoint release];
    [_imageView release];
    [_tableView release];
    [_activityIndicatorView release];
    [_images release];
    
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
            if(self.images == nil) {
                self.images = [[[NSMutableArray alloc] initWithCapacity:imageCount] autorelease];
            }
            
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
    
    self.imageView.animationImages = self.images;
    self.imageView.animationDuration = (NSTimeInterval) self.images.count * 3.0;
    [self.imageView performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:YES];
    
    [threadPool drain];
}

- (void)registerImage:(UIImage *)image {
    if(self.images == nil) {
        self.images = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    }
    [self.images addObject:image];
}

#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * kCellReuseIdentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    if(cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellReuseIdentifier] autorelease];
    }
    
    // Configure cell
    cell.textLabel.text = @"Hello world";
    
    return cell;
}

@end