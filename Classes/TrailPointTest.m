//
//  TrailPointTest.m
//  MTM
//
//  Created by Tim Ekl on 2/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TrailPointTest.h"


@implementation TrailPointTest

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void)testMath {
    
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
    }


- (void)testInitWithoutConnections {
    TrailPoint * target = [[[TrailPoint alloc] initWithID:20 location:CLLocationCoordinate2DMake(30.0f, 40.0f) category:@"50" title:@"60" desc:@"70" connections:nil] autorelease];
    
    STAssertNotNil(target, @"Did not create a TrailPoint object");
    
    STAssertEquals(20, target.pointID, @"Did not store point ID");
    STAssertEquals(CLLocationCoordinate2DMake(30.0f, 40.0f), target.location, @"Did not store location");
    STAssertEquals(CLLocationCoordinate2DMake(30.0f, 40.0f), target.coordinate, @"Did not provide location as coordinate (for MKAnnotation use)");
    STAssertEquals(@"50", target.category, @"Did not store category");
    STAssertEquals(@"60", target.title, @"Did not store title");
    STAssertEquals(@"70", target.description, @"Did not store description");
    
    STAssertNotNil(target.connections, @"Did not create connections array");
    STAssertEquals(0, target.connections.count, @"Created spurious connections in array");
}

- (void)testInitWithConnections {
    NSSet * connections = [NSSet setWithObject:[[[TrailPoint alloc] initWithID:10 location:CLLocationCoordinate2DMake(20.0f, 30.0f) category:@"40" title:@"50" desc:@"60" connections:nil] autorelease]];
    TrailPoint * target = [[[TrailPoint alloc] initWithID:20 location:CLLocationCoordinate2DMake(30.0f, 40.0f) category:@"50" title:@"60" desc:@"70" connections:connections] autorelease];
    
    STAssertNotNil(target, @"Did not create a TrailPoint object");
    
    STAssertEquals(20, target.pointID, @"Did not store point ID");
    STAssertEquals(CLLocationCoordinate2DMake(30.0f, 40.0f), target.location, @"Did not store location");
    STAssertEquals(CLLocationCoordinate2DMake(30.0f, 40.0f), target.coordinate, @"Did not provide location as coordinate (for MKAnnotation use)");
    STAssertEquals(@"50", target.category, @"Did not store category");
    STAssertEquals(@"60", target.title, @"Did not store title");
    STAssertEquals(@"70", target.description, @"Did not store description");
    
    STAssertNotNil(target.connections, @"Did not create connections array");
    STAssertEquals(connections.count, target.connections.count, @"Did not copy objects in connections array");
    for(TrailPoint * obj in connections) {
        STAssertTrue([target.connections containsObject:obj], @"Did not copy object %@ into connections array");
    }
}

- (void)testUnresolvedLinks {
    NSMutableArray * unresolved = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:10], nil];
    TrailPoint * target = [[[TrailPoint alloc] initWithID:20 location:CLLocationCoordinate2DMake(30.0f, 40.0f) category:@"50" title:@"60" desc:@"70" connections:nil] autorelease];
    target.unresolvableLinks = unresolved;

    STAssertTrue([target hasUnresolvedLinks], @"TrailPoint doesn't recognize NSNumbers as unresolved connections");
    STAssertEquals([target.unresolvableLinks count], unresolved.count, @"TrailPoint didn't store unresolved links set properly");
    for(NSNumber * obj in unresolved) {
        STAssertTrue([target.unresolvableLinks containsObject:obj], @"Did not copy object %@ into unresolved links array");
    }
}

#endif

@end
