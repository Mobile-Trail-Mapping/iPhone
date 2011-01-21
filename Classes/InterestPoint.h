#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

// TODO are there issues in converting back and forth from CGPoint to CLLocationCoordinate2D?

@interface InterestPoint : NSObject {

    NSInteger _pointID;
    CLLocationCoordinate2D _location;
	NSString* _category;
	NSString* _title;
    UIColor* _color;
    NSInteger _categoryID;
}

@property (nonatomic) NSInteger pointID;
@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic, retain) NSString* category;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) UIColor* color;
@property (nonatomic) NSInteger categoryID;

-(id) initWithID:(NSInteger)pointID location:(CLLocationCoordinate2D)p category:(NSString *)c title:(NSString *)t;

@end
