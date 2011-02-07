#import "TrailPoint.h"

@implementation TrailPoint

@synthesize trail = _trail;
@synthesize connections = _connections;
@synthesize unresolvableLinks = _unresolvableLinks;
@synthesize condition = _condition;

-(id) initWithID:(NSInteger)pointID location:(CLLocationCoordinate2D)p category:(NSString *)c title:(NSString *)t desc:(NSString *)d connections:(NSMutableSet *)connections {
    
	self = [super initWithID:pointID location:p category:c title:t desc:d];
	if (self != nil) {
        if(connections) {
            self.connections = connections;
        } else {
            self.connections = [[[NSMutableArray alloc] init] autorelease];
        }
	}
	return self;
}

- (BOOL)hasUnresolvedLinks {
    return [self.unresolvableLinks count] > 0;
}

- (void)resolveLinksWithinTrail:(Trail *)trail {
    if(!(self.hasUnresolvedLinks)) {
        return;
    }
    
    NSMutableArray * removed = [[[NSMutableArray alloc] initWithCapacity:[_unresolvableLinks count]] autorelease];
    for(NSNumber * n in self.unresolvableLinks) {
        for(TrailPoint * point in trail.trailPoints) {
            if(point.pointID == [n intValue]) {
                [self.connections addObject:point];
                break;
            }
        }
        [removed addObject:n];
    }
    [self.unresolvableLinks removeObjectsInArray:removed];
}

- (void) dealloc {

    [_trail release];
    [_connections release];
    [_unresolvableLinks release];
	[super dealloc];
}

@end
