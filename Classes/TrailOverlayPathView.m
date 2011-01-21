#import "TrailOverlayPathView.h"
#import "TrailOverlay.h"
#import "Trail.h"

@implementation TrailOverlayPathView

@synthesize trail = _trail;
@synthesize mapView = _mapView;

- (id)initWithTrail:(Trail *)trail mapView:(MKMapView *)mapView {
    if((self = [super initWithOverlay:[[[TrailOverlay alloc] initWithTrail:trail] autorelease]])) {
        self.trail = trail;
        self.mapView = mapView;
        
        //TODO debug
        self.fillColor = [UIColor redColor];
        self.strokeColor = [UIColor greenColor];
        self.lineWidth = 2.0f;
    }
    return self;
}

- (void)dealloc {
    [_trail release];
    [_mapView release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark MKOverlayPathView methods

- (void)createPath {
    //TODO create path
    // Note that [super createPath] has an empty implementation, so no call needed
    
    NSLog(@"creating path");
    
    CGPathRef path = CGPathCreateMutable();
    
    CGPoint center = [self.mapView convertCoordinate:self.overlay.coordinate toPointToView:self];
    //CGPathMoveToPoint(path, NULL, center.x, center.y);
    CGPathAddArc(path, NULL, center.x, center.y, 500.0f, 0, 2.0f * M_PI, false);
    
    self.path = path;
    CGPathRetain(path);
}

- (void)invalidatePath {
    [super invalidatePath];
    
    NSLog(@"invalidating path");
}

- (void)strokePath:(CGPathRef)path inContext:(CGContextRef)context {
    [super strokePath:path inContext:context];
    
    NSLog(@"stroking path");
}

- (void)fillPath:(CGPathRef)path inContext:(CGContextRef)context {
    [super fillPath:path inContext:context];
    
    NSLog(@"filling path");
}

@end