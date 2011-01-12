#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TrailPoint.h"
#import "LocationMarker.h"

@interface MapView : UIView<MKMapViewDelegate> {
	MKMapView *mapView;
    NSMutableArray *_xmlPoints;
}

@property (nonatomic, retain) NSMutableArray *xmlPoints;

-(void) parseXMLData:(NSString *)xmlAddress;
-(void) parseXML;
@end
