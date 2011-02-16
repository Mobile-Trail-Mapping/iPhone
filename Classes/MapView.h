#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "TrailActionDelegate.h"
#import "NetworkOperationDelegate.h"

@class TrailPoint;

/**
 * The primary controlling object for the main map view. Handles delegate
 * messages from the MKMapView instance in iPhoneViewController and performs
 * operations necessary to display trails on the map.
 */
@interface MapView : UIView <MKMapViewDelegate, NetworkOperationDelegate> {
@private
	MKMapView * _mapView;
    
    NSArray * _trails;
    NSArray * _categories;
    NSArray * _conditions;
    
    NSMutableDictionary * _overlayPathViews;
    id <TrailActionDelegate> _delegate;
}

/**
 * The set of Trail objects to be displayed.
 */
@property (nonatomic, retain) NSArray * trails;

/**
 * The set of Category objects available on the server.
 */
@property (nonatomic, retain) NSArray * categories;

/**
 * The set of Condition objects available on the server.
 */
@property (nonatomic, retain) NSArray * conditions;

/**
 * The TrailActionDelegate object which receives informational messages about
 * the behavior of this MapView.
 */
@property (nonatomic, assign) id <TrailActionDelegate> delegate;

/**
 * Remove all cached images from stored instances of TrailPoint in order
 * to free up memory. Should only be called in response to memory warnings
 * from the device.
 */
- (void)clearCachedImagesExceptForTrailPoint:(TrailPoint *)point;

/**
 * Clear and redraw all overlay and annotation objects on the map.
 */
- (void)redrawMapObjects;

@end
