#import "ConnectionAnnotationView.h"

#import "TrailPoint.h"

@implementation ConnectionAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)an reuseIdentifier:(NSString *)reuseIdentifier startPoint:(TrailPoint *)sp endPoint:(TrailPoint *)ep {
    double x1 = sp.location.x;
    double y1 = sp.location.y;
    double x2 = sp.location.x;
    double y2 = sp.location.y;
    
    double x = (x1 + x2) / 2.0;
    double y = (y1 + y2) / 2.0;
    
    
    
    if((self = [super initWithAnnotation:annotation reuseIdentifier:nil])) {
        startPoint = sp;
        endPoint = ep;
    }
    
    return self;
}

@end