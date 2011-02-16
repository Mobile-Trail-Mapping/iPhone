#import "MapView.h"
#import "TouchXML.h"
#import "TrailPoint.h"
#import "TrailOverlay.h"
#import "TrailOverlayPathView.h"
#import "TrailPointAnnotation.h"
#import "DataParser.h"
#import "ServiceAccountManager.h"

#import "NetworkOperationManager.h"
#import "NetworkOperation.h"

@interface MapView(Parsing)
/**
 * Request that this class begin the process of getting network information
 * from the active instance of the MTM server.
 */
- (void)fetchNetworkInfo;

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
@synthesize categories = _categories;

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
        
        [self fetchNetworkInfo];
	}
	return self;
}

- (void)fetchNetworkInfo {
    if([[ServiceAccountManager sharedManager] activeServiceAccount] != nil) {
        // Ask for auxiliary trails information
        NetworkOperation * categoryFetchOperation = [[[NetworkOperation alloc] init] autorelease];
        categoryFetchOperation.label = @"MTMCategoryFetchOperation";
        categoryFetchOperation.endpoint = @"category/get";
        categoryFetchOperation.requestType = kNetworkOperationRequestTypeGet;
        categoryFetchOperation.returnType = kNetworkOperationReturnTypeString;
        [categoryFetchOperation addDelegate:self];
        [[NetworkOperationManager sharedManager] enqueueOperation:categoryFetchOperation];
        
        // Ask for trails
        //TODO this needs to be refactored into a NetworkOperation
        [self performSelectorInBackground:@selector(beginParse) withObject:nil];
    } else {
        [self performSelector:@selector(fetchNetworkInfo) withObject:nil afterDelay:0.5];
    }
}

- (void)beginParse {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    NSURL * serviceURL = [[[ServiceAccountManager sharedManager] activeServiceAccount] serviceURL];
    NSURL * pointXMLURL = [serviceURL URLByAppendingPathComponent:@"point/get"];
    NSLog(@"fetching points at URL %@", [pointXMLURL absoluteString]);
    DataParser * parser = [[[DataParser alloc] initWithDataURL:pointXMLURL] autorelease];
    self.trails = [parser parseTrails];
    [self.delegate trailObjectsDidChange];
    
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
#pragma mark NetworkOperationDelegate methods

- (void)operationBegan:(NetworkOperation *)operation {
    
}

- (void)operationWasQueued:(NetworkOperation *)operation {
    
}

- (void)operation:(NetworkOperation *)operation completedWithResult:(id)result {
    CXMLDocument * doc = [[[CXMLDocument alloc] initWithXMLString:result options:0 error:nil] autorelease];
    
    if([operation.label isEqualToString:@"MTMCategoryFetchOperation"]) {
        NSMutableArray * newCategories = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
        
        NSArray * categoryNameElements = [doc nodesForXPath:@"/categories/category/name" error:nil];
        for(CXMLElement * categoryNameElement in categoryNameElements) {
            NSLog(@"Found element %@", [[categoryNameElement childAtIndex:0] stringValue]);
            
            [newCategories addObject:[[categoryNameElement childAtIndex:0] stringValue]];
        }
        
        self.categories = newCategories;
    } else if([operation.label isEqualToString:@"MTMAddPointOperation"]) {
        NSLog(@"Added point!");
        
        Trail * owningTrail = nil;
        for(Trail * trail in self.trails) {
            if([trail.name isEqualToString:[operation.requestData valueForKey:@"trail"]]) {
                owningTrail = trail;
            }
        }
        
        NSString * newIDString = (NSString *)result;
        NSInteger newID = [newIDString integerValue];
        
        float newLat = [[operation.requestData valueForKey:@"lat"] floatValue];
        float newLong = [[operation.requestData valueForKey:@"long"] floatValue];
        CLLocationCoordinate2D newLocation = CLLocationCoordinate2DMake(newLat, newLong);
        
        NSMutableSet * newConnections = [[[NSMutableSet alloc] initWithCapacity:10] autorelease];
        NSArray * connectionIDs = [[operation.requestData valueForKey:@"connections"] componentsSeparatedByString:@","];
        for(NSString * connectionIDString in connectionIDs) {
            NSInteger connectionID = [connectionIDString integerValue];
            for(TrailPoint * point in [owningTrail trailPoints]) {
                if(point.pointID == connectionID) {
                    [newConnections addObject:point];
                }
            }
        }
        
        TrailPoint * newPoint = [[[TrailPoint alloc] initWithID:newID 
                                                       location:newLocation 
                                                       category:[operation.requestData valueForKey:@"category"] 
                                                          title:[operation.requestData valueForKey:@"title"] 
                                                           desc:[operation.requestData valueForKey:@"desc"] 
                                                    connections:newConnections] autorelease];
        [owningTrail.trailPoints addObject:newPoint];
    }
}

- (void)operation:(NetworkOperation *)operation didFailWithError:(NSError *)error {
    if([operation.label isEqualToString:@"MTMCategoryFetchOperation"]) {
        self.categories = [NSArray array];
        [self.delegate trailObjectsDidChange];
    } else if([operation.label isEqualToString:@"MTMAddPointOperation"]) {
        NSLog(@"Warning: failed to add point.");
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