//
//  TravelBuddiesTests.m
//  TravelBuddiesTests
//
//  Created by Mariana Martinez on 13/07/20.
//  Copyright © 2020 Mariana Martinez. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SearchViewController.h"

@interface TravelBuddiesTests : XCTestCase

@property SearchViewController *tagTest;

@end

@implementation TravelBuddiesTests

- (void)setUp {
    self.tagTest = [[SearchViewController alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testTagsAll {
    NSNumber *targetNumber = @31;
    [self.tagTest calculateSearchNumber:Food addOrSubtract:0];
    [self.tagTest calculateSearchNumber:Museum addOrSubtract:0];
    [self.tagTest calculateSearchNumber:Entertainment addOrSubtract:0];
    [self.tagTest calculateSearchNumber:Commerce addOrSubtract:0];
    [self.tagTest calculateSearchNumber:NightLife addOrSubtract:0];
    XCTAssertEqualObjects(targetNumber, self.tagTest.searchNum);
}

- (void)testTagsInd {
    NSNumber *targetNumber = @2;
    [self.tagTest calculateSearchNumber:Museum addOrSubtract:0];
    XCTAssertEqualObjects(targetNumber, self.tagTest.searchNum);
}

- (void)testTagsPairs {
    NSNumber *targetNumber = @3;
    [self.tagTest calculateSearchNumber:Food addOrSubtract:0];
    [self.tagTest calculateSearchNumber:Museum addOrSubtract:0];
    XCTAssertEqualObjects(targetNumber, self.tagTest.searchNum);
}

- (void)testTagsTriad {
    NSNumber *targetNumber = @21;
    [self.tagTest calculateSearchNumber:Food addOrSubtract:0];
    [self.tagTest calculateSearchNumber:Entertainment addOrSubtract:0];
    [self.tagTest calculateSearchNumber:NightLife addOrSubtract:0];
    XCTAssertEqualObjects(targetNumber, self.tagTest.searchNum);
}

- (void)testTagsFour{
    NSNumber *targetNumber = @23;
    [self.tagTest calculateSearchNumber:Food addOrSubtract:0];
    [self.tagTest calculateSearchNumber:Museum addOrSubtract:0];
    [self.tagTest calculateSearchNumber:Entertainment addOrSubtract:0];
    [self.tagTest calculateSearchNumber:NightLife addOrSubtract:0];
    XCTAssertEqualObjects(targetNumber, self.tagTest.searchNum);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
