//
//  OrderedDictionary.h
//  MTM
//
//  Created by Tim Ekl on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A custom implementation of an ordered mutable dictionary. Provides access
 * to stored objects with both dictionary-style objectForKey: and array-style
 * objectAtIndex: methods.
 *
 * The default Cocoa collections interface provides only NSMutableDictionary
 * and NSMutableArray classes; there is no option for users who require an
 * "ordered dictionary," which stores its elements in a given order. Instead,
 * the default dictionary implementation in Cocoa uses a hash table, which is
 * inherently unordered.
 *
 * This class bridges that gap by internally using both an NSMutableDictionary
 * and NSMutableArray to store the data in the standard unordered way, but
 * allow access to that data with ordered key lookups.
 *
 * This "wrapping" incurs a reasonable performance hit. Generally,
 * dictionary-based methods perform in the same running time as their 
 * Cocoa counterparts; however, array-based methods (including objectAtIndex:)
 * will generally increase running time by a small amount, due to the need
 * to hit both the backing array and dictionary for a single lookup.
 */
@interface MutableOrderedDictionary : NSObject {
@private
    NSMutableDictionary * _data;
    NSMutableArray * _keys;
}

/**
 * Designated initializer. Create a new MutableOrderedDictionary with the
 * given initial capacity for object storage.
 */
- (id)initWithCapacity:(NSUInteger)capacity;

/**
 * Get the number of objects stored by this dictionary.
 */
- (NSUInteger)count;

/**
 * Get the object whose key is stored in the given position.
 */
- (id)objectAtIndex:(NSUInteger)index;

/**
 * Get the key stored in the given position.
 */
- (id)keyAtIndex:(NSUInteger)index;

/**
 * Get the object for the given key.
 */
- (id)objectForKey:(id)key;

/**
 * Get the value for the given key.
 */
- (id)valueForKey:(NSString *)key;

/**
 * Add an object to the dictionary. Its key is placed in the last position.
 */
- (void)setObject:(id)object forKey:(id)key;

/**
 * Add a value to the dictionary. Its key is placed in the last position.
 */
- (void)setValue:(id)value forKey:(NSString *)key;

@end
