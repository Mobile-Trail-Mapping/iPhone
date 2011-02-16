//
//  Category.h
//  MTM
//
//  Created by Tim Ekl on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A representation of a single condition that can be applied to Trail objects.
 */
@interface Condition : NSObject {
@private
    NSUInteger _conditionID;
    NSString * _desc;
}

/**
 * The unique ID of the condition.
 */
@property (nonatomic, assign) NSUInteger conditionID;

/**
 * The description of the condition.
 */
@property (nonatomic, retain) NSString * desc;

/**
 * Create a new Condition with the given properties.
 */
- (id)initWithID:(NSUInteger)conditionID desc:(NSString *)desc;

@end
