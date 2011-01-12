#import "MapView.h"
#import "TouchXML.h" 

@implementation MapView
@synthesize xmlPoints = _xmlPoints;

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
    if([_xmlPoints count] == 0) {
        [self parseXMLData:@"http://brousalis.com/sample.xml"];
        NSLog(@"%@", _xmlPoints);
        //[map reloadData];
    }
}

-(void) parseXMLData:(NSString *)xmlAddress {
    
    _xmlPoints = [[NSMutableArray alloc] init];	
    
    NSURL *url = [NSURL URLWithString: xmlAddress];
    
    CXMLDocument *doc = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
    
    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];

    for (CXMLElement *trails in data) {

        NSArray *trails = [doc nodesForXPath:@"//trails/trail" error:nil];

        for (CXMLElement *trail in trails) {
            [item setObject:[[trail attributeForName:@"id"] stringValue] forKey:@"trail_id"];
        }
        
        NSArray *nodes = [doc nodesForXPath:@"//trail/points/point" error:nil];
        
        for (CXMLElement *node in nodes) {

            int counter;
            for(counter = 0; counter < [node childCount]; counter++) {
            
                [item setObject:[[node childAtIndex:counter] stringValue] forKey:[[node childAtIndex:counter] name]];
            }
            [item setObject:[[node attributeForName:@"id"] stringValue] forKey:@"point_id"];
        }

    }
    
    [_xmlPoints addObject:[item copy]];
    [item release];
}

#pragma mark -
#pragma mark - Dealloc

- (void)dealloc {
    [_xmlPoints release];
	[mapView release];
    [super dealloc];
}

@end