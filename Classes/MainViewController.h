#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TrailActionDelegate.h"

@class TrailAction;
@class MapView;

/**
 * The primary view controller for the iPhone MTM application. Contains an
 * instance of MKMapView for trails display, and is the first view controller
 * instantiated after application launch.
 */
@interface MainViewController : UIViewController <TrailActionDelegate> {
    
@private
    MapView * _mapView;
}

/**
 * The map view on which to display trails.
 */
@property (nonatomic, retain) MapView * mapView;

@end

