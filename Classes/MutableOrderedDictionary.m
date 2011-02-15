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
        _data = [[NSMutableDictionary alloc] initWithCapacity:capacity];
        _keys = [[NSMutableArray alloc] initWithCapacity:capacity];
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

- (id)objectForKey:(id)aKey {
    return [_data objectForKey:aKey];
}

- (id)valueForKey:(NSString *)aKey {
    return [_data valueForKey:aKey];
}

- (NSUInteger)indexOfKey:(id)key {
    return [_keys indexOfObject:key];
}

#pragma mark - Enumerators

- (NSEnumerator *)keyEnumerator {
    return [_data keyEnumerator];
}

#pragma mark - Mutators

- (void)setObject:(id)object forKey:(id)aKey {
    [_keys addObject:aKey];
    [_data setObject:object forKey:aKey];
}

- (void)setValue:(id)value forKey:(NSString *)aKey {
    [_keys addObject:aKey];
    [_data setValue:value forKey:aKey];
}

- (void)removeObjectForKey:(id)aKey {
    [_keys removeObject:aKey];
    [_data removeObjectForKey:aKey];
}

@end
