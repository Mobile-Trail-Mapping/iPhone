#import "MapView.h"
#import "TouchXML.h" 

@interface MapView(Logging)

- (void)debugXMLDoc:(CXMLDocument *)doc;
- (void)debugXMLElement:(CXMLElement *)elem nestingDepth:(NSInteger)depth;

@end

@implementation MapView

- (id) initWithFrame:(CGRect) frame {
	self = [super initWithFrame:frame];
	if (self != nil) {
		mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		mapView.showsUserLocation = YES;
		[mapView setDelegate:self];
		[self addSubview:mapView];
        
        [self parseXML];
	}
	return self;
}

- (void) parseXML {
    [self parseXMLData:@"http://mtmserver.heroku.com/point/get"];
    //[map reloadData];
}

-(void) parseXMLData:(NSString *)xmlAddress {
    
    
    NSURL *url = [NSURL URLWithString:xmlAddress];
    
    CXMLDocument *doc = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
    [self debugXMLDoc:doc]; //logging
    
    NSArray *trailElements = [doc nodesForXPath:@"//trails/trail" error:nil];
    
    for(CXMLElement * trailElement in trailElements) {
        NSInteger trailID = [[[trailElement attributeForName:@"id"] stringValue] intValue];
        NSArray * pointElements = [doc nodesForXPath:[NSString stringWithFormat:@"//trails/trail[@id='%d']/points/point", trailID] error:nil];
        
        for(CXMLElement * pointElement in pointElements) {
            NSInteger pointID = [[[pointElement attributeForName:@"id"] stringValue] intValue];
            NSLog(@"Found point %d in trail %d", pointID, trailID);
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