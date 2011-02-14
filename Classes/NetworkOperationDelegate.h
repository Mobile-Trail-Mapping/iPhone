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
- (void)operationWasQueued:(NetworkOperation *)operation;
- (void)operationBegan:(NetworkOperation *)operation;
- (void)operation:(NetworkOperation *)operation completedWithResult:(id)result;
- (void)operation:(NetworkOperation *)operation didFailWithError:(NSError *)error;

@end
