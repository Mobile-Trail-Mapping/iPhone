#import <Foundation/Foundation.h>

@interface DataParser : NSObject {
    NSURL * _dataURL;
}

@property (nonatomic, retain) NSURL * dataURL;

- (id)initWithDataURL:(NSURL * )dataURL;
- (id)initWithDataAddress:(NSString *)dataAddress;

- (NSArray *)parseTrails;

@end