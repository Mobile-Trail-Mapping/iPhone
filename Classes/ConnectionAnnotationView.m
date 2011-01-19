#import "ConnectionAnnotationView.h"

#import "TrailPoint.h"
#import "ConnectionAnnotation.h"

@implementation ConnectionAnnotationView

- (id)initWithAnnotation:(ConnectionAnnotation *)an reuseIdentifier:(NSString *)reuseIdentifier {
    if((self = [super initWithAnnotation:an reuseIdentifier:reuseIdentifier])) {
        annotation = an;
    }
    return self;
}

@end