#import "Trail.h"

@implementation Trail

@synthesize name = _name;
@synthesize trailPoints = _trailPoints;
@synthesize trailHeads = _trailHeads;
@synthesize trailPaint = _trailPaint;

-(id) initWithName:(NSString *)name {
	if ((self = [super init])) {
        _name = name;
        _trailPoints = [[NSMutableArray alloc] init];
        _trailHeads = [[NSMutableArray alloc] init];
        _trailPaint = [UIColor yellowColor];
	}
	return self;
}

- (void) dealloc {
    [_name release];
    [_trailPoints release];
    [_trailHeads release];
    [_trailPaint release];
	[super dealloc];
}

@end
