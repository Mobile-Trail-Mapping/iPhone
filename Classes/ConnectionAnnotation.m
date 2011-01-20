//
//  ConnectionAnnotation.m
//  
//
//  Created by Tim Ekl on 1/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConnectionAnnotation.h"

#import "TrailPoint.h"


@implementation ConnectionAnnotation

- (id)initWithStartPoint:(TrailPoint *)sp endPoint:(TrailPoint *)ep {
    if((self = [super init])) {
        startPoint = sp;
        endPoint = ep;
    }
    return self;
}

#pragma mark -
#pragma mark MKAnnotation methods

- (CLLocationCoordinate2D)coordinate {
    double x1 = startPoint.location.latitude;
    double y1 = startPoint.location.longitude;
    double x2 = endPoint.location.latitude;
    double y2 = endPoint.location.longitude;
    
    double x = (x1 + x2) / 2.0;
    double y = (y1 + y2) / 2.0;
    
    return CLLocationCoordinate2DMake(x, y);
}

@end
