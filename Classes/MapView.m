#import "MapView.h"
#import "TouchXML.h"
#import "TrailPoint.h"
#import "TrailOverlay.h"
#import "TrailOverlayPathView.h"
#import "TrailPointAnnotation.h"
#import "DataParser.h"


@implementation MapView

@synthesize trails = _trails;

- (id) initWithFrame:(CGRect) frame {
	self = [super initWithFrame:frame];
	if (self != nil) {
		mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		mapView.showsUserLocation = YES;
		[mapView setDelegate:self];
		[self addSubview:mapView];
        
        self.trails = [[[NSMutableArray alloc] init] autorelease];
        _overlayPathViews = [[[NSMutableDictionary alloc] init] retain];
        
        //[self parseXML];
        
        DataParser * parser = [[[DataParser alloc] initWithDataAddress:@"http://mtmserver.heroku.com/point/get"] autorelease];
        self.trails = [parser parseTrails];
        
        for(Trail * trail in self.trails) {
            TrailOverlayPathView * overlayPathView = [[TrailOverlayPathView alloc] initWithTrail:trail mapView:mapView];
            [_overlayPathViews setValue:overlayPathView forKey:[trail name]];
            [mapView addOverlay:[overlayPathView overlay]];
            
            for(TrailPoint * head in trail.trailHeads) {
                TrailPointAnnotation * headAnnotation = [[[TrailPointAnnotation alloc] initWithTrailPoint:head] autorelease];
                [mapView addAnnotation:headAnnotation];
            }
        }
	}
	return self;
}

#pragma mark -
#pragma mark MKMapViewDelegate methods

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    NSLog(@"fetching view for overlay");
    
    if([overlay isKindOfClass:[TrailOverlay class]]) {
        TrailOverlay * trailOverlay = (TrailOverlay *)overlay;
        return [_overlayPathViews valueForKey:trailOverlay.trail.name];
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"region did change");
    
    for(NSString * overlayPathViewKey in _overlayPathViews) {
        //TrailOverlayPathView * overlayPathView = [_overlayPathViews valueForKey:overlayPathViewKey];
        //[overlayPathView invalidatePath];
        //[overlayPathView setNeedsDisplay];
    }
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	[mapView release];
	[_overlayPathViews release];
	
    [super dealloc];
}

@end