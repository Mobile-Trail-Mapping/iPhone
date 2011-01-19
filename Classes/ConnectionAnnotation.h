//
//  ConnectionAnnotation.h
//  
//
//  Created by Tim Ekl on 1/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@class TrailPoint;

@interface ConnectionAnnotation : NSObject <MKAnnotation> {
    TrailPoint * startPoint;
    TrailPoint * endPoint;
    
@private
    
}

- (id)initWithStartPoint:(TrailPoint *)sp endPoint:(TrailPoint *)ep;

@end
