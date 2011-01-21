#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapView : UIView<MKMapViewDelegate> {
	MKMapView * mapView;
    NSMutableArray * _trails;
    NSMutableDictionary * _overlayPathViews;
}

@property (nonatomic, retain) NSMutableArray * trails;

-(void) parseXMLData:(NSString *)xmlAddress;
-(void) parseXML;
@end
