#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class TrailPoint;

@interface TrailPointAnnotation : NSObject <MKAnnotation> {
    TrailPoint * _trailPoint;
}

@property (nonatomic, retain) TrailPoint * trailPoint;

- (id)initWithTrailPoint:(TrailPoint *)trailPoint;

@end