#import "TrailOverlayPathView.h"
#import "TrailOverlay.h"
#import "TrailPoint.h"
#import "Trail.h"

@implementation TrailOverlayPathView

@synthesize trail = _trail;
@synthesize mapView = _mapView;

- (id)initWithTrail:(Trail *)trail mapView:(MKMapView *)mapView {
    if((self = [super initWithOverlay:[[[TrailOverlay alloc] initWithTrail:trail] autorelease]])) {
        NSLog(@"Creating overlay for trail %@ with %d points", [trail name], [[trail trailPoints] count]);
        
        self.trail = trail;
        self.mapView = mapView;
        
        self.fillColor = trail.trailPaint;
        self.strokeColor = trail.trailPaint;
        self.lineWidth = 2.0f;
    }
    return self;
}

- (void)dealloc {
    [_trail release];
    [_mapView release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark MKOverlayPathView methods

- (void)createPath {
    // Note that [super createPath] has an empty implementation, so no call needed
    
    //NSLog(@"creating path in overlay for trail %@", [self.trail name]);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    for(TrailPoint * sourceTrailPoint in self.trail.trailPoints) {
        CLLocationCoordinate2D sourceLocation = sourceTrailPoint.location;
        CGPoint sourcePoint = [self.mapView convertCoordinate:sourceLocation toPointToView:self];
        
        //NSLog(@"  sourcing lines from point (%f,%f)", sourceLocation.latitude, sourceLocation.longitude);
        
        for(TrailPoint * targetTrailPoint in sourceTrailPoint.connections) {
            CLLocationCoordinate2D targetLocation = targetTrailPoint.location;
            CGPoint targetPoint = [self.mapView convertCoordinate:targetLocation toPointToView:self];
            
            //NSLog(@"    adding line to point (%f,%f)", targetLocation.latitude, targetLocation.longitude);
            
            CGPathMoveToPoint(path, NULL, sourcePoint.x, sourcePoint.y);
            CGPathAddLineToPoint(path, NULL, targetPoint.x, targetPoint.y);
        }
    }
    
    self.path = path;
    //CGPathRetain(path);
}

- (void)invalidatePath {
    [super invalidatePath];
    
    //NSLog(@"invalidating path");
}

- (void)strokePath:(CGPathRef)path inContext:(CGContextRef)context {
    [super strokePath:path inContext:context];
    
    //NSLog(@"stroking path");
}

- (void)fillPath:(CGPathRef)path inContext:(CGContextRef)context {
    [super fillPath:path inContext:context];
    
    //NSLog(@"filling path");
}

@end