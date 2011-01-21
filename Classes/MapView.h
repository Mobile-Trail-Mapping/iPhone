#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

/**
 * The primary controlling object for the main map view. Handles delegate
 * messages from the MKMapView instance in iPhoneViewController and performs
 * operations necessary to display trails on the map.
 */
@interface MapView : UIView<MKMapViewDelegate> {
@private
	MKMapView * mapView;
    NSArray * _trails;
    NSMutableDictionary * _overlayPathViews;
}

/**
 * The set of Trail objects to be displayed.
 */
@property (nonatomic, retain) NSArray * trails;

@end
