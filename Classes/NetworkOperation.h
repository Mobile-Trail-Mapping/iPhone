//
//  NetworkOperation.h
//  MTM
//
//  Created by Tim Ekl on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kNetworkOperationRequestTypeUnspecified,
    kNetworkOperationRequestTypeGet,
    kNetworkOperationRequestTypePost
} kNetworkOperationRequestType;

/**
 * A single encapsulated request to an instance of the MTM server. One network
 * operation always represents one call over the network to exchange data with
 * the server, and will likely deliver results back.
 *
 * Operations are dispatched after creation by enqueuing them in the
 * NetworkOperationManager, which handles the threading and asynchronous
 * aspects of network operations. Operation data will be returned to a
 * given set of delegates once it has been retrieved.
 */
@interface NetworkOperation : NSObject {
@private
    NSMutableSet * _delegates;
    kNetworkOperationRequestType _requestType;
    NSString * _endpoint;
    NSDictionary * _data;
}

/**
 * The set of delegate objects that are informed about the behavior of this
 * network operation. All objects must implement the NetworkOperationDelegate
 * protocol.
 */
@property (nonatomic, retain) NSMutableSet * delegates;

/**
 * The type of the request. Specifies the HTTP transport method which will
 * be used to submit the data to the MTM server.
 */
@property (nonatomic, assign) kNetworkOperationRequestType requestType;

/**
 * The RESTful API endpoint to call on the MTM server. Will be appended to the
 * active service account's base URL to form the absolute URL of the MTM
 * server request to make.
 */
@property (nonatomic, retain) NSString * endpoint;

/**
 * A set of key-value pairs to attach to the request. The data contained will
 * be automatically converted to the appropriate format for the specified
 * network operation type.
 */
@property (nonatomic, retain) NSDictionary * data;

@end
