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

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    NSLog(@"Tried to directly set coordinate of a trail point annotation! Ignoring...");
}

- (NSString *)title {
    return self.trailPoint.title;
}

- (NSString *)subtitle {
    return self.trailPoint.category;
}

@end