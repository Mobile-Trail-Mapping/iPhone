#import "MapView.h"
#import "TouchXML.h"

@interface MapView(Logging)

- (void)debugXMLDoc:(CXMLDocument *)doc;
- (void)debugXMLElement:(CXMLElement *)elem nestingDepth:(NSInteger)depth;

@end

@interface MapView(Testing)

- (void)refreshMap;

@end

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
        
        [self parseXML];
	}
	return self;
}

- (void) parseXML {
    [self parseXMLData:@"http://mtmserver.heroku.com/point/get"];
    [self refreshMap];
}

-(void) parseXMLData:(NSString *)xmlAddress {
    
    NSURL *url = [NSURL URLWithString:xmlAddress];
    
    CXMLDocument *doc = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
    //[self debugXMLDoc:doc]; //logging
    
    NSArray *trailElements = [doc nodesForXPath:@"//trails/trail" error:nil];
    
    for(CXMLElement * trailElement in trailElements) {
        Trail * currentTrail = [[[Trail alloc] initWithName:[[trailElement attributeForName:@"name"] stringValue]] autorelease];
        
        NSInteger trailID = [[[trailElement attributeForName:@"id"] stringValue] intValue];
        NSArray * pointElements = [doc nodesForXPath:[NSString stringWithFormat:@"//trails/trail[@id='%d']/points/point", trailID] error:nil];
        
        for(CXMLElement * pointElement in pointElements) {
            NSInteger pointID = [[[pointElement attributeForName:@"id"] stringValue] intValue];
            NSLog(@"Found point %d in trail %d", pointID, trailID);
            
            NSMutableArray * pointLinks = [[[NSMutableArray alloc] init] autorelease];
            
            NSMutableDictionary * pointProperties = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
            NSArray * pointPropertyElements = [doc nodesForXPath:[NSString stringWithFormat:@"//trails/trail[@id='%d']/points/point[@id='%d']/*", trailID, pointID] error:nil];
            for(CXMLElement * propertyElement in pointPropertyElements) {
                NSLog(@"  Dealing with property element %@ (which has %d children)", [propertyElement name], [propertyElement childCount]);
                if([[propertyElement name] isEqualToString:@"connections"]) {
                    NSArray * connectionElements = [doc nodesForXPath:[NSString stringWithFormat:@"//trails/trail[@id='%d']/points/point[@id='%d']/connections/connection", trailID, pointID] error:nil];
                    
                    for(CXMLElement * connectionElement in connectionElements) {
                        [pointLinks addObject:[NSNumber numberWithInt:[[[[connectionElement children] objectAtIndex:0] stringValue] intValue]]];
                    }
                } else {
                    [pointProperties setValue:[[[propertyElement children] objectAtIndex:0] stringValue] forKey:[propertyElement name]];
                }
            }
            
            CLLocationCoordinate2D pointLoc = CLLocationCoordinate2DMake([[pointProperties valueForKey:@"latitude"] doubleValue], [[pointProperties valueForKey:@"longitude"] doubleValue]);
            TrailPoint * currentPoint = [[[TrailPoint alloc] initWithParams:pointID 
                                                                   location:pointLoc 
                                                                   category:[pointProperties valueForKey:@"category"] 
                                                                      title:[pointProperties valueForKey:@"title"]] autorelease];
            currentPoint.unresolvableLinks = pointLinks;
            currentPoint.hasUnresolvedLinks = YES;
            [currentTrail.trailPoints addObject:currentPoint];
        }
        
        [self.trails addObject:currentTrail];
    }
    
}

- (void)refreshMap {
    for(Trail * trail in self.trails) {
        for(TrailPoint * point in trail.trailPoints) {
            if(point.hasUnresolvedLinks) {
                [point resolveLinksWithinTrail:trail];
            }
        }
    }
}

- (void)debugXMLDoc:(CXMLDocument *)doc {
    NSLog(@"=== XML ===");
    [self debugXMLElement:[doc rootElement] nestingDepth:1];
    NSLog(@"=== XML ===");
}
- (void)debugXMLElement:(CXMLElement *)elem nestingDepth:(NSInteger)depth {
    NSMutableString * str = [[[NSMutableString alloc] initWithString:@""] autorelease];
    for(int i = 0; i < depth - 1; i++) {
        [str appendString:@"| "];
    }
    [str appendString:@"|-"];
    [str appendString:[elem name]];
    NSLog(@"%@", str);
    for(CXMLElement * e in [elem children]) {
        [self debugXMLElement:e nestingDepth:depth+1];
    }
}

#pragma mark -
#pragma mark - Dealloc

- (void)dealloc {
	[mapView release];
    [super dealloc];
}

@end