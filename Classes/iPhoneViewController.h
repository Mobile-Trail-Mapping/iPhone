#import <UIKit/UIKit.h>
#import "MapView.h"
#import "TrailPoint.h"

@interface iPhoneViewController : UIViewController {
    MKMapView * _mapView;
}

@property (nonatomic, retain) MKMapView * mapView;

@end

