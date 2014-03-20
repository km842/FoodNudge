//
//  DiaryDatabaseTest.m
//  FoodNudge
//
//  Created by Kunal  on 19/03/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DiaryDatabase.h"

@interface DiaryDatabaseTest : XCTestCase

@end

@implementation DiaryDatabaseTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDatabaseExists
{
    XCTAssertNotNil([DiaryDatabase database], @"empty");
}

-(void)testUniqueDates {
    NSMutableArray *originalArray = [[DiaryDatabase database] uniqueDates];
    NSMutableSet *set = [NSMutableSet setWithArray:originalArray];
    NSMutableArray *nonDuplicates = [[NSMutableArray alloc] init];
    for (id object in originalArray) {
        if (![set containsObject:object]) {
            [nonDuplicates addObject:object];
        }
    }
    XCTAssert([nonDuplicates count] == 0, @"not the same number");
}

-(void)testIdFromDate {
    NSMutableArray *ids = [[DiaryDatabase database] productIdFromDate:@"2009-11-11"];
    XCTAssert([ids count] == 0, @"is not nil");
    ids = [[DiaryDatabase database] productIdFromDate:@"2014-03-19"];
    XCTAssert([ids count] > 0, @"no entry");
}

@end
