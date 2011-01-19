#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

// TODO are there issues in converting back and forth from CGPoint to CLLocationCoordinate2D?

@interface InterestPoint : NSObject <MKAnnotation> {

    NSInteger _pointID;
    CGPoint _location;
	NSString* _category;
	NSString* _title;
    UIColor* _color;
    NSInteger _categoryID;
}

@property (nonatomic) NSInteger pointID;
@property (nonatomic) CGPoint location;
@property (nonatomic, retain) NSString* category;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) UIColor* color;
@property (nonatomic) NSInteger categoryID;

-(id) initWithParams:(NSInteger)id location:(CGPoint)p category:(NSString *)c title:(NSString *)t;

@end
