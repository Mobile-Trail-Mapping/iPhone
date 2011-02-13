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
        [self readSettingsFromFile];
    }
    return self;
}

- (void)readSettingsFromFile {
    NSLog(@"reading settings from file");
    
    // Find file path - search app directory first, then bundle if no local copy exists
    NSString * plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"Settings.plist"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    }
    
    // Grab data and parse
    NSData * plistXML = [NSData dataWithContentsOfFile:plistPath];
    NSDictionary * plistData = [NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:NULL errorDescription:nil];
    if(!plistData) {
        NSLog(@"Error reading settings property list");
    }
    
    // Set properties
    self.isFirstRun = [[plistData objectForKey:@"IsFirstRun"] boolValue]; NSLog(@"Set property isFirstRun=%@", [plistData objectForKey:@"IsFirstRun"]);
}

- (void)writeSettingsToFile {
    NSLog(@"writing settings to file");
    
    // Find file path - always write to app directory
    NSString * rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * plistPath = [rootPath stringByAppendingPathComponent:@"Settings.plist"];
    
    NSDictionary * plistDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObject:[NSNumber numberWithBool:self.isFirstRun]] forKeys:[NSArray arrayWithObject:@"IsFirstRun"]];
    NSData * plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    } else {
        NSLog(@"Error writing settings property list");
    }
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