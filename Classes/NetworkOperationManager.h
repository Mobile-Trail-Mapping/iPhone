//
//  NetworkOperationManager.h
//  MTM
//
//  Created by Tim Ekl on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NetworkOperationDelegate.h"

@class NetworkOperation;

/**
 * Class responsible for handling a series of network operations. "Network
 * operations" include all requests to an instance of the MTM server, including
 * both GET and POST queries.
 *
 * This class is designed to be used asynchronously and to handle all its
 * threads internally. As such, users should primarily interact with the
 * manager in two ways:
 *  - Queue a network operation with one of the queue methods
 *  - Register callbacks with the queued operation, then handle data passed
 *    to those callbacks by the manager
 *
 * Attempts to modify the internal manager threading or to force particular
 * behavior not guaranteed by the manager is likely to go awry.
 */
@interface NetworkOperationManager : NSObject <NetworkOperationDelegate> {
@private
    NSMutableArray * _queue;
    NetworkOperation * _activeOperation;
    
    NSTimer * _pumpTimer;
}

/**
 * Get the singleton instance of NetworkOperationManager. This method
 * should be used to obtain a handle of the primary functioning manager
 * for the entire MTM application.
 */
+ (NetworkOperationManager *)sharedManager;

/**
 * Get the currently executing NetworkOperation. If no operation is
 * executing, returns nil.
 */
- (NetworkOperation *)activeOperation;

/**
 * Get the list of queued NetworkOperation objects, in order they will
 * be executed. If no operations are queued, returns nil. The queue does not
 * include the actively executing operation.
 */
- (NSArray *)queuedOperations;

/**
 * Place a NetworkOperation in the queue. The operation will be executed
 * at the next available opportunity; if no other operation is active or
 * queued, this means immediately.
 */
- (void)enqueueOperation:(NetworkOperation *)operation;

/**
 * Stop any execution of a NetworkOperation and remove it from queue.
 * Regardless of the state of the operation (queued or executing), it will
 * deliver a canceled delegate method and stop immediately.
 */
- (void)cancelOperation:(NetworkOperation *)operation;

@end
