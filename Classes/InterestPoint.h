#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

/**
 * Primary class representing any marked point on a trail. InterestPoint
 * objects range from describing simple locations through which a trail
 * passes (defining the path of the trail) to representing full-blown
 * locations of historical interest.
 */
@interface InterestPoint : NSObject <MKAnnotation> {

@private
    NSInteger _pointID;
    CLLocationCoordinate2D _location;
	NSString * _category;
	NSString * _title;
    NSString * _desc;
    UIColor * _color;
    NSInteger _categoryID;
}

/**
 * The unique ID of this point.
 */
@property (nonatomic) NSInteger pointID;

/**
 * The coordinate (latitude/longitude pair) of this point.
 */
@property (nonatomic) CLLocationCoordinate2D location;

/**
 * The category to which this point belongs.
 */
@property (nonatomic, retain) NSString * category;

/**
 * The title of this point. Optional for points of category "Trail".
 */
@property (nonatomic, retain) NSString * title;

/**
 * The color to paint this point. Optional.
 */
@property (nonatomic, retain) UIColor * color;

/**
 * The unique ID of this point's category.
 */
@property (nonatomic) NSInteger categoryID;

/**
 * The description of this point.
 */
@property (nonatomic, retain) NSString * desc;

/**
 * Create a new point with the given parameters. Designated initializer.
 */
-(id) initWithID:(NSInteger)pointID location:(CLLocationCoordinate2D)p category:(NSString *)c title:(NSString *)t desc:(NSString *)d;

@end
