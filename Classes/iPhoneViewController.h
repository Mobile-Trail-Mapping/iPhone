#import <UIKit/UIKit.h>
#import "MapView.h"
#import "TrailPoint.h"

/**
 * The primary view controller for the iPhone MTM application. Contains an
 * instance of MKMapView for trails display, and is the first view controller
 * instantiated after application launch.
 */
@interface iPhoneViewController : UIViewController {
    
@private
    MKMapView * _mapView;
}

/**
 * The map view on which to display trails.
 */
@property (nonatomic, retain) MKMapView * mapView;

@end

