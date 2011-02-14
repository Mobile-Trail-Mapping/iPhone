//
//  Setting.m
//  MTM
//
//  Created by Tim Ekl on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Setting.h"


@implementation Setting

@synthesize title = _title;
@synthesize target = _target;
@synthesize valueSelector = _valueSelector;
@synthesize actionSelector = _actionSelector;
@synthesize callbackSelector = _callbackSelector;
@synthesize enabled = _enabled;
@synthesize secure = _secure;
@synthesize shouldShowDisclosure = _shouldShowDisclosure;

- (id)initWithTitle:(NSString *)title target:(id)target onValue:(SEL)value onAction:(SEL)action onChange:(SEL)callback {
    if((self = [super init])) {
        self.title = title;
        self.target = target;
        self.valueSelector = value;
        self.actionSelector = action;
        self.callbackSelector = callback;
        
        // Default values
        self.enabled = YES;
        self.secure = NO;
        self.shouldShowDisclosure = NO;
    }
    return self;
}

- (void)dealloc {
    [_title release];
    
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"{Setting: %@ %@}", self.title, [self value]];
}

#pragma mark -
#pragma mark Display info

- (NSString *)value {
    if([self.target respondsToSelector:self.valueSelector]) {
        NSString * value = [self.target performSelector:self.valueSelector];
        if(self.secure) {
            NSMutableString * secureString = [[[NSMutableString alloc] initWithCapacity:[value length]] autorelease];
            for(int i = 0; i < [value length]; i++) {
                [secureString appendString:@"•"];
            }
            return secureString;
        } else {
            return value;
        }
    }
    return nil;
}

- (NSString *)insecureValue {
    if([self.target respondsToSelector:self.valueSelector]) {
        return [self.target performSelector:self.valueSelector];
    }
    return nil;
}

- (void)performAction {
    if([self.target respondsToSelector:self.actionSelector]) {
        [self.target performSelector:self.actionSelector withObject:self];
    }
}

- (void)performActionWithArgument:(id)arg {
    if([self.target respondsToSelector:self.actionSelector]) {
        [self.target performSelector:self.actionSelector withObject:arg];
    }
}

- (void)performChangeCallbackWithValue:(NSString *)newValue {
    if([self.target respondsToSelector:self.callbackSelector]) {
        [self.target performSelector:self.callbackSelector withObject:newValue];
    }
}

@end
