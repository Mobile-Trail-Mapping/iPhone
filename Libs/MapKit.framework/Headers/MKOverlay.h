//
//  MKOverlay.h
//  MapKit
//
//  Copyright 2010 Apple, Inc. All rights reserved.
//

#import <MapKit/MKAnnotation.h>
#import <MapKit/MKTypes.h>
#import <MapKit/MKGeometry.h>

#if __IPHONE_4_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED

@protocol MKOverlay <MKAnnotation>
@required

// From MKAnnotation, for areas this should return the centroid of the area.
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

// boundingMapRect should be the smallest rectangle that completely contains the overlay.
// For overlays that span the 180th meridian, boundingMapRect should have either a negative MinX or a MaxX that is greater than MKMapSizeWorld.width.
@property (nonatomic, readonly) MKMapRect boundingMapRect;

@optional
// Implement intersectsMapRect to provide more precise control over when the view for the overlay should be shown.
// If omitted, MKMapRectIntersectsRect([overlay boundingRect], mapRect) will be used instead.
- (BOOL)intersectsMapRect:(MKMapRect)mapRect;

@end

#endif
