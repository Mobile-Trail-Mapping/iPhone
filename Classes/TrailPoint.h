#import <Foundation/Foundation.h>
#import "InterestPoint.h"
#import "Trail.h"

/**
 * A type of InterestPoint which belongs to a Trail object. TrailPoint objects
 * are commonly used to represent path points of a Trail or trail heads.
 */
@interface TrailPoint : InterestPoint {
@private
    Trail *_trail;
    NSMutableSet *_connections;
    NSMutableArray *_unresolvableLinks;
    NSString * _condition;
}

/**
 * The Trail to which these TrailPoint objects belong.
 */
@property (nonatomic, retain) Trail *trail;

/**
 * The set of TrailPoint objects to which this TrailPoint is connected.
 * TrailPoint connections are not symmetric; it is not necessarily true that
 * this TrailPoint is in the connections set of its connected points.
 */
@property (nonatomic, retain) NSMutableSet *connections;

/**
 * The set of trail point IDs that could not be resolved into true
 * TrailPoint objects. Primarily used during initial parsing to temporarily
 * store IDs of linked points within the same trail until those points
 * can be parsed and resolved.
 *
 * @see TrailPoint#hasUnresolvedLinks
 * @see TrailPoint#resolveLinksWithinTrail:
 */
@property (nonatomic, retain) NSMutableArray *unresolvableLinks;

/**
 * Whether this TrailPoint has unresolved links that need conversion to
 * TrailPoint objects. Effectively the same as calling:
 *
 * <pre><code>[[trailPoint unresolvableLinks] count] &gt; 0</code></pre>
 *
 * @see TrailPoint#unresolvableLinks
 * @see TrailPoint#resolveLinksWithinTrail:
 */
@property (nonatomic, readonly) BOOL hasUnresolvedLinks;

/**
 * The condition of this TrailPoint.
 */
@property (nonatomic, retain) NSString * condition;

/**
 * Create a new TrailPoint with the given information and connections set.
 * Primarily called by DataParser to assign TrailPoint objects to Trail
 * objects, but may be called separately for custom TrailPoint creation.
 *
 * If the <code>connections</code> parameter is <code>nil</code>, creates
 * an empty connections set which can be manipulated later.
 */
- (id)initWithID:(NSInteger)pointID location:(CLLocationCoordinate2D)p category:(NSString *)c title:(NSString *)t desc:(NSString *)d connections:(NSMutableSet *)connections;

/**
 * Iterate through the set of unresolved connections on this TrailPoint,
 * evaluating each to a TrailPoint belonging to the given Trail object. Removes
 * resolved point IDs from TrailPoint#unresolvableLinks on resolution.
 *
 * @see TrailPoint#unresolvableLinks
 * @see TrailPoint#resolveLinksWithinTrail:
 */
- (void)resolveLinksWithinTrail:(Trail *)trail;

@end
