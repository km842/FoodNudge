//
//  FoodNudgeTests.m
//  FoodNudgeTests
//
//  Created by Kunal  on 05/01/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Products.h"

@interface ProductTests : XCTestCase

@end

@implementation ProductTests

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

- (void)testSimpleAllocation
{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    Products *obj = [[Products alloc] init];
    XCTAssertNil([obj name], @"sadsad");

}

-(void)testObject
{
    Products *obj = [[Products alloc] initWithId:@"111" name:@"appads" calories:@"sad" sugar:@"djas" fat:@"asldlsad" saturates:@"sda" salt:@"sadasd"];
    XCTAssertEqual([obj pid], @"111", @"Correct instantiation");
    XCTAssertNotNil(obj, @"Not empty");
}

-(void)testParams
{
    Products *obj = [[Products alloc] initWithId:@"111" name:@"appads" calories:@"sad" sugar:@"djas" fat:@"asldlsad" saturates:@"sda" salt:@"sadasd"];
    XCTAssertTrue([[obj pid] isEqualToString:@"111"], @"workingngngnng param allocation");
}

@end
