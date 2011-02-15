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
@interface MutableOrderedDictionary : NSMutableDictionary {
@private
    NSMutableDictionary * _data;
    NSMutableArray * _keys;
}

/**
 * Get the object whose key is stored in the given position.
 */
- (id)objectAtIndex:(NSUInteger)index;

/**
 * Get the key stored in the given position.
 */
- (id)keyAtIndex:(NSUInteger)index;

/**
 * Get the index of the given key.
 */
- (NSUInteger)indexOfKey:(id)key;

@end
