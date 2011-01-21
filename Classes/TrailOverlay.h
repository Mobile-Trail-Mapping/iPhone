#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Trail;

/**
 * The overlay object associated with a Trail and used for layout of
 * an associated TrailOverlayPathView on a map.
 *
 * This overlay provides map-based information about its Trail, including:
 *  - The bounding box containing all the TrailPoint objects in the trail
 *  - The center of that bounding box
 */
@interface TrailOverlay : NSObject <MKOverlay> {
    
@private
    Trail * _trail;
    CLLocationCoordinate2D _coordinate;
    MKMapRect _boundingMapRect;
}

/**
 * The Trail for which to maintain an overlay.
 */
@property (nonatomic, retain) Trail * trail;

/**
 * Create a new TrailOverlay with the given Trail object.
 */
- (id)initWithTrail:(Trail *)trail;

@end