//
//  TrailTest.m
//  MTM
//
//  Created by Tim Ekl on 2/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TrailTest.h"

#import "Trail.h"

@implementation TrailTest

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void)testMath {
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
}

- (void)testTrailCreation {
	Trail * target = [[[Trail alloc] initWithName:@"Trail Name"] autorelease];
	
	STAssertTrue([target.name isEqualToString:@"Trail Name"], @"Trail did not keep provided name");
	
	STAssertNotNil(target.trailHeads, @"Trail did not create trail heads collection");
	STAssertTrue(target.trailHeads.count == 0, @"Trail added arbitrary heads to collection");
	
	STAssertNotNil(target.trailPoints, @"Trail did not create trail points collection");
	STAssertTrue(target.trailPoints.count == 0, @"Trail added arbitrary points to collection");
	
	STAssertNotNil(target.trailPaint, @"Trail did not assign itself a paint");
}

#endif


@end
