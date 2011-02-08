//
//  OrderedDictionary.m
//  MTM
//
//  Created by Tim Ekl on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MutableOrderedDictionary.h"


@implementation MutableOrderedDictionary

- (id)initWithCapacity:(NSUInteger)capacity {
    if((self = [super init])) {
        _data = [[[NSMutableDictionary alloc] initWithCapacity:capacity] retain];
        _keys = [[[NSMutableArray alloc] initWithCapacity:capacity] retain];
    }
    return self;
}

- (void)dealloc {
    [_data release];
    [_keys release];
    
    [super dealloc];
}

#pragma mark - Info methods

- (NSUInteger)count {
    assert([_data count] == [_keys count]);
    return [_keys count];
}

#pragma mark - Accessors

- (id)objectAtIndex:(NSUInteger)index {
    return [_data objectForKey:[self keyAtIndex:index]];
}

- (id)keyAtIndex:(NSUInteger)index {
    return [_keys objectAtIndex:index];
}

- (id)objectForKey:(id)key {
    return [_data objectForKey:key];
}

- (id)valueForKey:(NSString *)key {
    return [_data valueForKey:key];
}

#pragma mark - Mutators

- (void)setObject:(id)object forKey:(id)key {
    [_keys addObject:key];
    [_data setObject:object forKey:key];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [_keys addObject:key];
    [_data setValue:value forKey:key];
}

@end
