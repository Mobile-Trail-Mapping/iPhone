#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Trail;

@interface TrailOverlay : NSObject <MKOverlay> {
    Trail * _trail;
    
@private
    
    CLLocationCoordinate2D _coordinate;
    MKMapRect _boundingMapRect;
}

@property (nonatomic, retain) Trail * trail;

- (id)initWithTrail:(Trail *)trail;

@end