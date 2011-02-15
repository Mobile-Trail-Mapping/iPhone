#import "MapView.h"
#import "TouchXML.h"
#import "TrailPoint.h"
#import "TrailOverlay.h"
#import "TrailOverlayPathView.h"
#import "TrailPointAnnotation.h"
#import "DataParser.h"
#import "ServiceAccountManager.h"

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
		_mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		_mapView.showsUserLocation = YES;
		[_mapView setDelegate:self];
		[self addSubview:_mapView];
        
        self.trails = [[[NSMutableArray alloc] init] autorelease];
        _overlayPathViews = [[NSMutableDictionary alloc] init];
        
        [self performSelectorInBackground:@selector(beginParse) withObject:nil];
	}
	return self;
}

- (void)beginParse {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    NSURL * serviceURL = [[[ServiceAccountManager sharedManager] activeServiceAccount] serviceURL];
    NSURL * pointXMLURL = [serviceURL URLByAppendingPathComponent:@"point/get"];
    NSLog(@"fetching points at URL %@", [pointXMLURL absoluteString]);
    DataParser * parser = [[[DataParser alloc] initWithDataURL:pointXMLURL] autorelease];
    self.trails = [parser parseTrails];
    
    for(Trail * trail in self.trails) {
        TrailOverlayPathView * overlayPathView = [[[TrailOverlayPathView alloc] initWithTrail:trail mapView:_mapView] autorelease];
        [_overlayPathViews setValue:overlayPathView forKey:[trail name]];
        [_mapView addOverlay:[overlayPathView overlay]];
        
        for(TrailPoint * head in trail.trailHeads) {
            TrailPointAnnotation * headAnnotation = [[[TrailPointAnnotation alloc] initWithTrailPoint:head] autorelease];
            [_mapView addAnnotation:headAnnotation];
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

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"Region did change animated");
    for(MKOverlayPathView * pathView in [_overlayPathViews allValues]) {
        [pathView setNeedsDisplayInMapRect:mapView.visibleMapRect];
    }
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	[_mapView release];
	[_overlayPathViews release];
	
    [super dealloc];
}

@end