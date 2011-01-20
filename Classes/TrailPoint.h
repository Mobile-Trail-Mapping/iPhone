#import <Foundation/Foundation.h>
#import "InterestPoint.h"
#import "Trail.h"

@interface TrailPoint : InterestPoint {
    
    Trail *_trail;
    NSMutableSet *_connections;
    NSMutableArray *_unresolvableLinks;
    BOOL _hasUnresolvedLinks;
}

@property (nonatomic, retain) Trail *trail;
@property (nonatomic, retain) NSMutableSet *connections;
@property (nonatomic, retain) NSMutableArray *unresolvableLinks;
@property (nonatomic, assign) BOOL hasUnresolvedLinks;

- (id)initWithID:(NSInteger)pointID location:(CLLocationCoordinate2D)p category:(NSString *)c title:(NSString *)t connections:(NSMutableSet *)connections;
- (void)resolveLinksWithinTrail:(Trail *)trail;

@end
