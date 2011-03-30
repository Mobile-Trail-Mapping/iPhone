//
//  NetworkOperationDelegate.h
//  MTM
//
//  Created by Tim Ekl on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NetworkOperation;

/**
 * Protocol containing callback methods for NetworkOperation objects that
 * are active in the NetworkOperationManager. Implemented by delegate objects
 * held in the NetworkOperation instances.
 */
@protocol NetworkOperationDelegate <NSObject>

@optional
/**
 * Report that the given NetworkOperation was queued in a 
 * NetworkOperationManager for later execution.
 */
- (void)operationWasQueued:(NetworkOperation *)operation;

/**
 * Report that the given NetworkOperation began execution.
 */
- (void)operationBegan:(NetworkOperation *)operation;

/**
 * Report that the given NetworkOperation completed its
 * task with the given result object. Receiving this message
 * indicates a success condition. For a given
 * NetworkOperation, a delegate will receive either this
 * message or operation:didFailWithError:.
 */
- (void)operation:(NetworkOperation *)operation completedWithResult:(id)result;

/**
 * Report that the given NetworkOperation failed to
 * complete its task and reported the given error. For a
 * given NetworkOperation, a delegate will receive either
 * this message or operation:completedWithResult:.
 */
- (void)operation:(NetworkOperation *)operation didFailWithError:(NSError *)error;

@end
