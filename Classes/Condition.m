//
//  Category.m
//  MTM
//
//  Created by Tim Ekl on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Condition.h"


@implementation Condition

@synthesize conditionID = _conditionID;
@synthesize desc = _desc;

- (id)initWithID:(NSUInteger)conditionID desc:(NSString *)desc {
    if((self = [super init])) {
        self.conditionID = conditionID;
        self.desc = desc;
    }
    return self;
}

- (void)dealloc {
    [_desc release];
    
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"{Condition %d: %@}", self.conditionID, self.desc];
}

@end
