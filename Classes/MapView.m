#import "MapView.h"
#import "TouchXML.h"
#import "TrailPoint.h"
#import "TrailOverlay.h"
#import "TrailOverlayPathView.h"
#import "TrailPointAnnotation.h"
#import "DataParser.h"

@interface MapView(Parsing)
/**
 * Start point for background thread to fetch trails data and add to this
 * object's instance of MKMapView. Handles its own autorelease pool and
 * dispatches an instance of DataParser.
 *
 * Until this method completes, MapView#trails will be an empty array, and
 * this object's MKMapView will behave like a standard Google Maps interface.
 */
- (void)beginParse;
@end

@implementation MapView

@synthesize trails = _trails;
@synthesize delegate = _delegate;

- (id) initWithFrame:(CGRect) frame {
	self = [super initWithFrame:frame];
	if (self != nil) {
		mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		mapView.showsUserLocation = YES;
		[mapView setDelegate:self];
		[self addSubview:mapView];
        
        self.trails = [[[NSMutableArray alloc] init] autorelease];
        _overlayPathViews = [[[NSMutableDictionary alloc] init] retain];
        
        [self performSelectorInBackground:@selector(beginParse) withObject:nil];
	}
	return self;
}

- (void)beginParse {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
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
    
    [pool drain];
}

- (void)clearCachedImagesExceptForTrailPoint:(TrailPoint *)exceptPoint {
    for(Trail * trail in self.trails) {
        for(TrailPoint * trailPoint in trail.trailPoints) {
            if(exceptPoint != trailPoint) {
                trailPoint.images = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
            }
        }
    }
}

#pragma mark -
#pragma mark MKMapViewDelegate methods

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for(MKAnnotationView * view in views) {
        view.rightCalloutAccessoryView = [self.delegate calloutViewForTrailPointAnnotation:view];
        [view setNeedsDisplay];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if(control == view.rightCalloutAccessoryView) {
        NSLog(@"callout accessory control tapped");
        TrailPointAnnotation * trailPointAnnotation = (TrailPointAnnotation *)(view.annotation);
        [self.delegate showInformationForTrailPoint:trailPointAnnotation.trailPoint sender:view];
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    NSLog(@"fetching view for overlay");
    
    if([overlay isKindOfClass:[TrailOverlay class]]) {
        TrailOverlay * trailOverlay = (TrailOverlay *)overlay;
        return [_overlayPathViews valueForKey:trailOverlay.trail.name];
    }
    
    return nil;
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	[mapView release];
	[_overlayPathViews release];
	
    [super dealloc];
}

@end