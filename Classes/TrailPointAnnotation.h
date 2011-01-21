#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class TrailPoint;

/**
 * The annotation object associated with a particular TrailPoint. Used to
 * drop pins for trail heads on a map. This annotation provides information
 * to a map view, including:
 *  - The coordinate of its TrailPoint
 *  - The title of its TrailPoint
 */
@interface TrailPointAnnotation : NSObject <MKAnnotation> {
@private
    TrailPoint * _trailPoint;
}

/**
 * The TrailPoint for which to maintain an annotation.
 */
@property (nonatomic, retain) TrailPoint * trailPoint;

/**
 * Create a new TrailPointAnnotation with the given TrailPoint.
 */
- (id)initWithTrailPoint:(TrailPoint *)trailPoint;

@end