#import <MapKit/MapKit.h>

@class TrailPoint;

@interface ConnectionAnnotationView : MKAnnotationView {
    TrailPoint * startPoint;
    TrailPoint * endPoint;
    id <MKAnnotation> annotation;
}

- (id)initWithAnnotation:(id<MKAnnotation>)an reuseIdentifier:(NSString *)reuseIdentifier startPoint:(TrailPoint *)sp endPoint:(TrailPoint *)ep;

@end