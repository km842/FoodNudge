//
//  ProductsDatabaseTest.m
//  FoodNudge
//
//  Created by Kunal  on 19/03/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ProductsDatabase.h"
#import "Products.h"

@interface ProductsDatabaseTest : XCTestCase

@end

@implementation ProductsDatabaseTest

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

- (void)testDatabaseNotEmpty
{
    XCTAssertNotNil([ProductsDatabase database], @"empty");
}

- (void)testProductInfo {
    
    Products *obj = [[ProductsDatabase database] getProductInfoById:@"260691779"];
    XCTAssertNotNil(obj, @"is nil");
    XCTAssertTrue([[obj pid] isEqualToString:@"260691779"], @"got the wrong product back!");
}

@end
