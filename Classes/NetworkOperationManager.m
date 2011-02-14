//
//  NetworkOperationManager.m
//  MTM
//
//  Created by Tim Ekl on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetworkOperationManager.h"
#import "NetworkOperation.h"

static NetworkOperationManager * sharedInstance = nil;

@interface NetworkOperationManager(Internal)

/**
 * Attempt to pump NetworkOperation objects along the queue. Basically, if 
 * no operation is active, pop the head of the queue and begin executing it.
 */
- (void)pumpQueue;

@end

@implementation NetworkOperationManager

#pragma mark - Queue operations

- (NetworkOperation *)activeOperation {
    return _activeOperation;
}

- (NSArray *)queuedOperations {
    return [[_queue copy] autorelease];
}

- (void)enqueueOperation:(NetworkOperation *)operation {
    [_queue addObject:operation];
}

- (void)cancelOperation:(NetworkOperation *)operation {
    
}

- (void)pumpQueue {
    if(nil == _activeOperation) {
        if([_queue count] > 0) {
            NetworkOperation * nextOperation = [_queue objectAtIndex:0];
            [_queue removeObjectAtIndex:0];
            
            _activeOperation = [nextOperation retain];
        }
    }
}

#pragma mark - Lifecycle

- (id)init {
    if((self = [super init])) {
        _queue = [[[NSMutableArray alloc] initWithCapacity:10] retain];
        _activeOperation = nil;
        
        _pumpTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(pumpQueue) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_pumpTimer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)dealloc {
    [_queue release];
    [_activeOperation release];
    
    [_pumpTimer invalidate];
    [_pumpTimer release];
    
    [super dealloc];
}

#pragma mark - Singleton methods

+ (NetworkOperationManager *)sharedManager {
    @synchronized(self)
    {
        if (sharedInstance == nil)
            sharedInstance = [[NetworkOperationManager alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    // Can't be released
    return UINT_MAX;  
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}


@end
