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
                           @[@"y",@"r",@"h",@"y",@"h",@"y"],
                           @[@"y",@"b",@"b",@"y",@"g",@"b"],
                           @[@"r",@"p",@"p",@"b",@"g",@"r"],
                           @[@"p",@"y",@"y",@"y",@"r",@"g"]];
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
+(NSString*)toJsonString:(NSMutableArray*)arr
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr
                                                       options:0
                                                         error:NULL];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
- (void)testCalculate
{
    //http://appleprogramming.com/blog/2013/12/26/xctest-assertions-documentation/
    PHBoard *board = [self createBoard1];
    NSMutableDictionary* combo = [board calculateScore];
    NSString *comboString = [PADHelperTests toJsonString:combo];
    NSString *expectedComboString = @"{\"Light\":[[25,26,27]],\"Water\":[[13,14,21]],\"Darkness\":[[24,19,20]]}";
    //XCTAssertTrue([comboString isEqualToString:expectedComboString], @"nono");
    XCTAssertEqualObjects(comboString,expectedComboString,@"elimination combo fail");
}


@end
