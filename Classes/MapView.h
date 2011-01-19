#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TrailPoint.h"
#import "LocationMarker.h"

@interface MapView : UIView<MKMapViewDelegate> {
	MKMapView * mapView;
    
    NSMutableArray * _trails;
}

@property (nonatomic, retain) NSMutableArray * trails;

-(void) parseXMLData:(NSString *)xmlAddress;
-(void) parseXML;
@end
