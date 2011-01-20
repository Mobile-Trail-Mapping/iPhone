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
}

- (void)invalidatePath {
    [super invalidatePath];
    
    NSLog(@"invalidating path");
}

@end