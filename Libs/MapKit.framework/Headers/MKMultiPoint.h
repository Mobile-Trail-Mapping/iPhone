//
//  MKMultiPoint.h
//  MapKit
//
//  Copyright 2010 Apple, Inc. All rights reserved.
//

#if __IPHONE_4_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED

#import <Foundation/Foundation.h>
#import <MapKit/MKShape.h>
#import <MapKit/MKGeometry.h>
#import <MapKit/MKTypes.h>

@interface MKMultiPoint : MKShape {
@package
    MKMapPoint *_points;
    NSUInteger _pointCount;
    
    MKMapRect _boundingRect;
}

@property (nonatomic, readonly) MKMapPoint *points;
@property (nonatomic, readonly) NSUInteger pointCount;

// Unproject and copy points into the provided array of coordinates that
// must be large enough to hold range.length coordinates.
- (void)getCoordinates:(CLLocationCoordinate2D *)coords range:(NSRange)range;

@end

#endif
