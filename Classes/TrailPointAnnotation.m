#import "TrailPointAnnotation.h"
#import "TrailPoint.h"

@implementation TrailPointAnnotation

@synthesize trailPoint = _trailPoint;

- (id)initWithTrailPoint:(TrailPoint *)trailPoint {
    if((self = [super init])) {
        self.trailPoint = trailPoint;
    }
    return self;
}

- (void)dealloc {
    [_trailPoint release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark MKAnnotation methods

- (CLLocationCoordinate2D)coordinate {
    return self.trailPoint.location;
}

- (NSString *)title {
    return self.trailPoint.title;
}

@end