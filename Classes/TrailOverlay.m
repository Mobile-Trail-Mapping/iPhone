#import "TrailOverlay.h"
#import "TrailPoint.h"

@implementation TrailOverlay

@synthesize trail = _trail;

- (id)initWithTrail:(Trail *)trail {
    if((self = [super init])) {
        self.trail = trail;
        
        // Find the region containing all the trail's points
        double maxLat = -91;
        double minLat =  91;
        double maxLon = -181;
        double minLon =  181;
        
        for(TrailPoint * point in self.trail.trailPoints) {
            CLLocationCoordinate2D coordinate = point.location;
            
            if(coordinate.latitude > maxLat) {
                maxLat = coordinate.latitude;
            }
            if(coordinate.latitude < minLat) {
                minLat = coordinate.latitude;
            }
            if(coordinate.longitude > maxLon) {
                maxLon = coordinate.longitude;
            }
            if(coordinate.longitude < minLon) {
                minLon = coordinate.longitude;
            }
        }
        
        // Set the bounding map rect and coordinate
        MKMapPoint upperLeft = MKMapPointForCoordinate(CLLocationCoordinate2DMake(minLat, minLon));
        MKMapPoint lowerRight = MKMapPointForCoordinate(CLLocationCoordinate2DMake(maxLat, maxLon));
        MKMapSize size = MKMapSizeMake(lowerRight.x - upperLeft.x, lowerRight.y - upperLeft.y);
        _boundingMapRect.origin = upperLeft;
        _boundingMapRect.size = size;
        MKCoordinateSpan span = MKCoordinateSpanMake((maxLat + 90) - (minLat + 90), (maxLon + 180) - (minLon + 180));
        _coordinate = CLLocationCoordinate2DMake(minLat + span.latitudeDelta / 2, minLon + span.longitudeDelta / 2);
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