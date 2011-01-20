#import "TrailOverlay.h"

@implementation TrailOverlay

@synthesize trail = _trail;

- (id)initWithTrail:(Trail *)trail {
    if((self = [super init])) {
        self.trail = trail;
        
        //TODO calculate coord and bounding rect
    }
    return self;
}

- (void)dealloc {
    [_trail release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark MKOverlay methods

- (CLLocationCoordinate2D)coordinate {
    return _coordinate;
}

- (MKMapRect)boundingMapRect {
    return _boundingMapRect;
}

@end