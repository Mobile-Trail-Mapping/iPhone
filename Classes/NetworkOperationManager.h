//
//  NetworkOperationManager.h
//  MTM
//
//  Created by Tim Ekl on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

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
@interface NetworkOperationManager : NSObject {
@private
    
}

@end
