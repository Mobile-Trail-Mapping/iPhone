#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TrailActionDelegate.h"
#import "TrailPointInfoModalDelegate.h"

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

/**
 * Display a modal settings dialog for editing application configuration.
 */
- (void)showSettings;

/**
 * Get the list of trails being displayed by this controller's MapView.
 */
- (NSArray *)trails;

/**
 * Get the list of categories available in this controller's MapView.
 */
- (NSArray *)categories;

/**
 * Inform this controller's MapView to clear all image caches.
 */
- (void)clearCachedImages;

@end

