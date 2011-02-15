//
//  NetworkOperation.h
//  MTM
//
//  Created by Tim Ekl on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NetworkOperationDelegate.h"

typedef enum {
    kNetworkOperationRequestTypeUnspecified,
    kNetworkOperationRequestTypeGet,
    kNetworkOperationRequestTypePost
} kNetworkOperationRequestType;

typedef enum {
    kNetworkOperationReturnTypeData,
    kNetworkOperationReturnTypeString,
    kNetworkOperationReturnTypeImage
} kNetworkOperationReturnType;

typedef enum {
    kNetworkOperationErrorCanceled,
    kNetworkOperationErrorConnectionFailed,
    kNetworkOperationErrorUnrecognizedRequestType,
    kNetworkOperationErrorUnrecognizedReturnType
} kNetworkOperationError;

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
    kNetworkOperationReturnType _returnType;
    BOOL _authenticate;
    NSString * _endpoint;
    NSMutableDictionary * _requestData;
    
    NSString * _label;
    
    NSMutableURLRequest * _request;
    NSURLConnection * _connection;
    NSMutableData * _returnData;
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
 * The type of data to return. Specifies the class of object that is passed
 * to the delegates on the completion callback.
 */
@property (nonatomic, assign) kNetworkOperationReturnType returnType;

/**
 * Whether or not to use authentication information when executing this
 * operation. Authentication is only passed with POST requests (i.e.
 * kNetworkOperationRequestTypePost).
 *
 * Setting this property to YES implies that you're OK with losing whatever
 * data is in the NetworkOperation#data dictionary that belongs to the
 * "user" and "pwhash" keys.
 */
@property (nonatomic, assign) BOOL authenticate;

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
@property (nonatomic, retain) NSMutableDictionary * requestData;

/**
 * A user- or program-defined label used to identify this operation. Used
 * to distinguish between multiple operations that may share the same
 * delegate.
 */
@property (nonatomic, retain) NSString * label;

/**
 * Register the given object as a delegate for this operation. The object
 * must conform to the NetworkOperationDelegate protocol. If the object is
 * already a delegate for this operation, no action is taken.
 */
- (void)addDelegate:(id<NetworkOperationDelegate>)delegate;

/**
 * Remove the given object as a delegate for this operation. If the object
 * is not already a delegate for this operation, no action is taken.
 */
- (void)removeDelegate:(id<NetworkOperationDelegate>)delegate;

/**
 * Begin executing this NetworkOperation. Fires off its connection and begins
 * notifying delegates of its actions.
 */
- (void)execute;

/**
 * Cancel the execution of this NetworkOperation. Has no effect if the
 * operation is not executing.
 */
- (void)cancel;

@end
