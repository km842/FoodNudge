//
//  InitialViewControllerTest.m
//  FoodNudge
//
//  Created by Kunal  on 18/03/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import <XCTest/XCTest.h>
#import "InitialViewController.h"

@interface InitialViewControllerTest : XCTestCase

@end

@implementation InitialViewControllerTest {
    InitialViewController *vc;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    vc = [[InitialViewController alloc] init];

}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//check our labels are created
- (void)testLabelsAndButtons
{
    XCTAssertNil([vc name], @"Name label not set");
    XCTAssertNil([vc lastName], @"last name label not set");
    XCTAssertNil([vc dob], @"dob label not set");
    XCTAssertNil([vc height], @"height label not set");
    XCTAssertNil([vc weight], @"weight label not set");
    XCTAssertNil([[vc signUpButton] actionsForTarget:vc forControlEvent:UIControlEventTouchUpInside], @"hell");
}
@end
