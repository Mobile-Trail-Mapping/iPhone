#import "DataParser.h"
#import "TouchXML.h"
#import "Trail.h"
#import "TrailPoint.h"

@interface DataParser(Logging)

- (void)debugXMLDoc:(CXMLDocument *)doc;
- (void)debugXMLElement:(CXMLElement *)elem nestingDepth:(NSInteger)depth;

@end

@implementation DataParser

@synthesize dataURL = _dataURL;

#pragma mark -
#pragma mark Initializers

- (id)initWithDataURL:(NSURL * )dataURL {
    if((self = [super init])) {
        self.dataURL = dataURL;
    }
    return self;
}

- (id)initWithDataAddress:(NSString *)dataAddress {
    return [self initWithDataURL:[NSURL URLWithString:dataAddress]];
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    [_dataURL release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Parsing

- (NSArray *)parseTrails {
    
    NSURL * url = self.dataURL;
    NSMutableArray * trails = [[[NSMutableArray alloc] init] autorelease];
    
    CXMLDocument *doc = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
    //[self debugXMLDoc:doc]; //logging
    
    NSArray *trailElements = [doc nodesForXPath:@"//trails/trail" error:nil];
    
    for(CXMLElement * trailElement in trailElements) {
        Trail * currentTrail = [[[Trail alloc] initWithName:[[trailElement attributeForName:@"name"] stringValue]] autorelease];
        
        NSInteger trailID = [[[trailElement attributeForName:@"id"] stringValue] intValue];
        NSArray * pointElements = [doc nodesForXPath:[NSString stringWithFormat:@"//trails/trail[@id='%d']/points/point", trailID] error:nil];
        
        for(CXMLElement * pointElement in pointElements) {
            NSInteger pointID = [[[pointElement attributeForName:@"id"] stringValue] intValue];
            //NSLog(@"Found point %d in trail %d", pointID, trailID);
            
            NSMutableArray * pointLinks = [[[NSMutableArray alloc] init] autorelease];
            
            NSMutableDictionary * pointProperties = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
            NSArray * pointPropertyElements = [doc nodesForXPath:[NSString stringWithFormat:@"//trails/trail[@id='%d']/points/point[@id='%d']/*", trailID, pointID] error:nil];
            for(CXMLElement * propertyElement in pointPropertyElements) {
                //NSLog(@"  Dealing with property element %@ (which has %d children)", [propertyElement name], [propertyElement childCount]);
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
            TrailPoint * currentPoint = [[[TrailPoint alloc] initWithID:pointID
                                                               location:pointLoc 
                                                               category:[pointProperties valueForKey:@"category"] 
                                                                  title:[pointProperties valueForKey:@"title"]
                                                            connections:nil] autorelease];
            currentPoint.unresolvableLinks = pointLinks;
            currentPoint.hasUnresolvedLinks = YES;
            [currentTrail.trailPoints addObject:currentPoint];
        }
        
        [trails addObject:currentTrail];
        
        //NSLog(@"  instantiating overlay and annotation");
    }
    
    for(Trail * trail in trails) {
        for(TrailPoint * point in trail.trailPoints) {
            if(point.hasUnresolvedLinks) {
                [point resolveLinksWithinTrail:trail];
            }
        }
    }
    
    return trails;
    
}

#pragma mark -
#pragma mark Debugging and logging

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

@end