#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class Trail;

@interface TrailOverlayPathView : MKOverlayPathView {
    Trail * _trail;
    MKMapView * _mapView;
}

@property (nonatomic, retain) Trail * trail;
@property (nonatomic, retain) MKMapView * mapView;

@end