//
//  PADHelperTests.m
//  PADHelperTests
//
//  Created by BIINGYANN HSIUNG on 4/10/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "PHOrb.h"
#import "PHBoard.h"

@interface PADHelperTests : XCTestCase

@end

@implementation PADHelperTests

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

-(PHBoard*)createBoard1
{
    NSArray *testBoard = @[@[@"p",@"p",@"h",@"b",@"h",@"p"],
                           @[@"h",@"y",@"y",@"y",@"h",@"y"],
                           @[@"y",@"p",@"p",@"b",@"g",@"b"],
                           @[@"r",@"y",@"p",@"b",@"g",@"r"],
                           @[@"h",@"y",@"h",@"y",@"r",@"g"]];
    PHBoard *board = [[PHBoard alloc]init];
    for (int y=0; y<5; y++) {
        for (int x=0; x<6; x++) {
            NSString *orbColorName = [[testBoard objectAtIndex:y]objectAtIndex:x];
            PHOrb *orb = [[PHOrb alloc]initWithOrbColor:orbColorName];
            [board addOrb:orb OnBoardAt:x andY:y];
        }
    }
    return board;
}
-(PHBoard*)createBoard2
{
    NSArray *testBoard = @[@[@"p",@"p",@"p",@"b",@"h",@"p"],
                           @[@"h",@"y",@"p",@"b",@"h",@"y"],
                           @[@"y",@"p",@"p",@"b",@"h",@"b"],
                           @[@"r",@"y",@"y",@"b",@"g",@"r"],
                           @[@"h",@"y",@"p",@"y",@"r",@"g"]];
    PHBoard *board = [[PHBoard alloc]init];
    for (int y=0; y<5; y++) {
        for (int x=0; x<6; x++) {
            NSString *orbColorName = [[testBoard objectAtIndex:y]objectAtIndex:x];
            PHOrb *orb = [[PHOrb alloc]initWithOrbColor:orbColorName];
            [board addOrb:orb OnBoardAt:x andY:y];
        }
    }
    return board;
}
- (void)testCalculate
{
    PHBoard *board = [self createBoard1];
    //[board dump];
    [board calculateScore];
    NSLog(@"%@",board.combos);
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}


@end
