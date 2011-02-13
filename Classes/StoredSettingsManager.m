//
//  StoredSettingsManager.m
//  MTM
//
//  Created by Tim Ekl on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StoredSettingsManager.h"

static StoredSettingsManager * sharedInstance = nil;

@implementation StoredSettingsManager

@synthesize isFirstRun = _isFirstRun;

#pragma mark - Lifecycle

- (id)init {
    if((self = [super init])) {
        // Read in plist
        NSString * plistPath;
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        plistPath = [rootPath stringByAppendingPathComponent:@"Settings.plist"];
        if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
            plistPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
        }
        NSData * plistXML = [NSData dataWithContentsOfFile:plistPath];
        NSDictionary * plistData = [NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:NULL errorDescription:nil];
        if(!plistData) {
            NSLog(@"Error reading settings property list");
        }
        
        // Set properties
        self.isFirstRun = [[plistData objectForKey:@"IsFirstRun"] boolValue]; NSLog(@"Set property isFirstRun=%@", [plistData objectForKey:@"IsFirstRun"]);
    }
    return self;
}

#pragma mark -
#pragma mark Singleton methods

+ (StoredSettingsManager *)sharedManager {
    @synchronized(self)
    {
        if (sharedInstance == nil)
            sharedInstance = [[StoredSettingsManager alloc] init];
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