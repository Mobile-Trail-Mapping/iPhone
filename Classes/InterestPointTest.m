//
//  InterestPointTest.m
//  MTM
//
//  Created by Tim Ekl on 2/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InterestPointTest.h"

@implementation InterestPointTest

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void)testMath {
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
}

- (void)testInit {
    InterestPoint * target = [[[InterestPoint alloc] initWithID:20 location:CLLocationCoordinate2DMake(30.0f, 40.0f) category:@"50" title:@"60" desc:@"70"] autorelease];
    
    STAssertNotNil(target, @"Did not create an InterestPoint object");
    
    STAssertEquals(20, target.pointID, @"Did not store point ID");
    STAssertEquals(CLLocationCoordinate2DMake(30.0f, 40.0f), target.location, @"Did not store location");
    STAssertEquals(CLLocationCoordinate2DMake(30.0f, 40.0f), [target coordinate], @"Did not provide location as coordinate (for MKAnnotation use)");
    STAssertEquals(@"50", target.category, @"Did not store category");
    STAssertEquals(@"60", target.title, @"Did not store title");
    STAssertEquals(@"70", target.description, @"Did not store description");
}

- (void)testColor {
    InterestPoint * target = [[[InterestPoint alloc] initWithID:20 location:CLLocationCoordinate2DMake(30.0f, 40.0f) category:@"50" title:@"60" desc:@"70"] autorelease];
    target.color = [UIColor greenColor];
    
    STAssertEquals([UIColor greenColor], target.color, @"Did not store color");
}

#endif

@end
