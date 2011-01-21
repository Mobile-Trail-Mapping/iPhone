#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class Trail;

/**
 * The view for a single Trail object to be drawn on a map. Implements a
 * custom <code>drawRect:</code> method to convert each contained TrailPoint
 * to a location on an MKMapView, then connects them (as dictated by each
 * point's TrailPoint#connections property) with stroked lines in a path.
 */
@interface TrailOverlayPathView : MKOverlayPathView {
    
@private
    Trail * _trail;
    MKMapView * _mapView;
}

/**
 * The Trail for which to provide the view.
 */
@property (nonatomic, retain) Trail * trail;

/**
 * The MKMapView that will contain this trail overlay view. Used for
 * converting coordinates (instances of CLLocationCoordinate2D) to view
 * locations.
 */
@property (nonatomic, retain) MKMapView * mapView;

/**
 * Create a new TrailOverlayPathView with the TrailPoint objects from the
 * given Trail, using the given map view for coordinate conversion.
 */
- (id)initWithTrail:(Trail *)trail mapView:(MKMapView *)mapView;

@end