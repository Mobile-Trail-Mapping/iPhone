#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TrailActionDelegate.h"

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
    id <TrailActionDelegate> _delegate;
}

/**
 * The set of Trail objects to be displayed.
 */
@property (nonatomic, retain) NSArray * trails;

/**
 * The TrailActionDelegate object which receives informational messages about
 * the behavior of this MapView.
 */
@property (nonatomic, assign) id <TrailActionDelegate> delegate;

@end
