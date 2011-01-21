#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapView : UIView<MKMapViewDelegate> {
	MKMapView * mapView;
    NSArray * _trails;
    NSMutableDictionary * _overlayPathViews;
}

@property (nonatomic, retain) NSArray * trails;

@end
