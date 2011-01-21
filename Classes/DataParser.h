#import <Foundation/Foundation.h>

/**
 * The primary class responsible for fetching and parsing XML data from
 * the MTM server. Instances of DataParser should be created with the
 * URL from which to pull data, then called each time updated data is
 * needed from the server.
 */
@interface DataParser : NSObject {
    
@private
    NSURL * _dataURL;
}

/**
 * The URL to check for trails data. Expected to be a valid resource locator
 * to some XML resource which conforms to the MTM schema.
 */
@property (nonatomic, retain) NSURL * dataURL;

/**
 * Designated initializer. Creates a new instance of DataParser with the
 * given data URL.
 */
- (id)initWithDataURL:(NSURL * )dataURL;

/**
 * Alternate initalizer. Converts the given address to an instance of NSURL,
 * then calls the designated initailizer DataParser#initWithDataURL: with the
 * converted URL.
 */
- (id)initWithDataAddress:(NSString *)dataAddress;

/**
 * Fetch XML data, parse it for trail information, and return a set of
 * data objects.
 *
 * Each time it is called, the DataParser#parseTrails method will do the 
 * following:
 *  -# Synchronously query its dataURL for XML-formatted data about the
 *     trails. This XML is expected to conform to the MTM schema; currently,
 *     the schema of the fetched XML is not checked.
 *  -# Iterate through the fetched XML using XPath and a DOM-based parser to
 *     locate information about trails, points, and other relevant objects.
 *     For large trails, this can be computationally expensive.
 *  -# Convert the parsed information into relevant objects (including Trail,
 *     InterestPoint, TrailPoint, and LocationMarker) with the appropriate
 *     links and connections between them.
 *
 * This method returns an array of Trail objects, each populated with the
 * appropriate TrailPoint objects for trail points and heads.
 *
 * Currently, this method blocks until it returns, and includes a large
 * parsing operation and synchronous data fetch; as such, it may take
 * several seconds to produce the expected array of trail information.
 */
- (NSArray *)parseTrails;

@end