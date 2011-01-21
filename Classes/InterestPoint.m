#import "InterestPoint.h"

@implementation InterestPoint

@synthesize pointID = _pointID;
@synthesize location = _location;
@synthesize category = _category;
@synthesize title = _title;
@synthesize color = _color;
@synthesize categoryID = _categoryID;

-(id) initWithID:(NSInteger)pointID location:(CLLocationCoordinate2D)p category:(NSString *)c title:(NSString *)t {
        
	self = [super init];
	if (self != nil) {
        _pointID = pointID;
        _location = p;
        _category = c;
        _title = t;
        _categoryID = -1;
        _color = [UIColor redColor];
	}
	return self;
}

- (void) dealloc {
    
    [_category release];
    [_title release];
    [_color release];
	[super dealloc];
}

#pragma mark -
#pragma mark MKAnnotation methods

- (CLLocationCoordinate2D)coordinate {
    return self.location;
}
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    self.location = newCoordinate;
}
- (NSString *)subtitle {
    // TODO
    return @"subtitle";
}
- (NSString *)title {
    // TODO
    return @"title";
}

@end
