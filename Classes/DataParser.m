#import "DataParser.h"
#import "TouchXML.h"
#import "Trail.h"
#import "TrailPoint.h"

@interface DataParser(Logging)

/**
 * Log an entire XML document elementwise.
 */
- (void)debugXMLDoc:(CXMLDocument *)doc;

/**
 * Log a single XML element at the given nesting depth. Used primarily by
 * DataParser#debugXMLDoc for recursive nesting. Generally should not be
 * called directly.
 */
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
                    NSString * propertyValue = @"";
                    if([[propertyElement children] count] > 0) {
                        propertyValue = [[[propertyElement children] objectAtIndex:0] stringValue];
                    }
                    [pointProperties setValue:propertyValue forKey:[propertyElement name]];
                }
            }
            
            CLLocationCoordinate2D pointLoc = CLLocationCoordinate2DMake([[pointProperties valueForKey:@"latitude"] doubleValue], [[pointProperties valueForKey:@"longitude"] doubleValue]);
            //NSLog(@"about to create point: (%d, %@, %@)", pointID, [pointProperties valueForKey:@"category"], [pointProperties valueForKey:@"title"]);
            TrailPoint * currentPoint = [[[TrailPoint alloc] initWithID:pointID
                                                               location:pointLoc 
                                                               category:[pointProperties valueForKey:@"category"] 
                                                                  title:[pointProperties valueForKey:@"title"]
                                                                   desc:[pointProperties valueForKey:@"description"]
                                                            connections:nil] autorelease];
            currentPoint.condition = [pointProperties valueForKey:@"condition"];
            currentPoint.unresolvableLinks = pointLinks;
            [currentTrail.trailPoints addObject:currentPoint];
            if([currentPoint.category isEqualToString:@"Trailhead"]) {
                [currentTrail.trailHeads addObject:currentPoint];
            }
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
    if([elem kind] == CXMLTextKind) {
        [str appendFormat:@"\"%@\"", [elem stringValue]];
    } else {
        [str appendString:[elem name]];
    }
    NSLog(@"%@", str);
    for(CXMLElement * e in [elem children]) {
        [self debugXMLElement:e nestingDepth:depth+1];
    }
}

@end