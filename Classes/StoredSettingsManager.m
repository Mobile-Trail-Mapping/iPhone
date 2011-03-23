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
@synthesize activeServiceAccountUUID = _activeServiceAccountUUID;
@synthesize mapType = _mapType;
@synthesize mapZoomsToUserLocation = _mapZoomsToUserLocation;

#pragma mark - Lifecycle

- (id)init {
    if((self = [super init])) {
        [self readSettingsFromFile];
    }
    return self;
}

- (void)readSettingsFromFile {
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
    self.isFirstRun = [[plistData objectForKey:@"IsFirstRun"] boolValue];
    self.activeServiceAccountUUID = [plistData objectForKey:@"ActiveServiceAccountUUID"];
    self.mapType = (MKMapType)[[plistData objectForKey:@"MapType"] unsignedIntegerValue];
    self.mapZoomsToUserLocation = [[plistData objectForKey:@"MapZoomsToUserLocation"] boolValue];
}

- (void)writeSettingsToFile {
    // Find file path - always write to app directory
    NSString * rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * plistPath = [rootPath stringByAppendingPathComponent:@"Settings.plist"];
    
    NSMutableDictionary * plistDict = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
    
    // Set properties
    [plistDict setValue:[NSNumber numberWithBool:self.isFirstRun] forKey:@"IsFirstRun"];
    [plistDict setValue:self.activeServiceAccountUUID forKey:@"ActiveServiceAccountUUID"];
    [plistDict setValue:[NSNumber numberWithUnsignedInteger:self.mapType] forKey:@"MapType"];
    [plistDict setValue:[NSNumber numberWithBool:self.mapZoomsToUserLocation] forKey:@"MapZoomsToUserLocation"];
    
    // Write
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