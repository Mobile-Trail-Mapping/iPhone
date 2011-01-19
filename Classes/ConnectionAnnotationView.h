#import <MapKit/MapKit.h>

@class TrailPoint;
@class ConnectionAnnotation;

@interface ConnectionAnnotationView : MKAnnotationView {
    ConnectionAnnotation * annotation;
}

- (id)initWithAnnotation:(ConnectionAnnotation *)an reuseIdentifier:(NSString *)reuseIdentifier;

@end