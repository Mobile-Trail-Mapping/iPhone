//
//  StoredSettingsManager.h
//  MTM
//
//  Created by Tim Ekl on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StoredSettingsManager : NSObject {
@private
    BOOL _isFirstRun;
}

@property (nonatomic, assign) BOOL isFirstRun;

+ (StoredSettingsManager *)sharedManager;

@end
