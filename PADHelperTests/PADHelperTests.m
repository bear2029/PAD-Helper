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

-(void)testBoard1
{
    PHBoard *board = [self createBoard:@[@[@"p",@"p",@"h",@"b",@"h",@"p"],
                                         @[@"y",@"r",@"h",@"y",@"h",@"y"],
                                         @[@"y",@"b",@"b",@"y",@"g",@"b"],
                                         @[@"r",@"p",@"p",@"b",@"g",@"r"],
                                         @[@"p",@"y",@"y",@"y",@"r",@"g"]]];
    NSString *expectedComboString = @"{\"Light\":[[25,26,27]],\"Water\":[[13,14,21]],\"Darkness\":[[24,19,20]]}";
    [self calculateBoard:board andExcpectJson:expectedComboString];
}
-(void)testBoard2
{
    PHBoard *board = [self createBoard:@[@[@"p",@"p",@"p",@"b",@"h",@"p"],
                                         @[@"h",@"y",@"p",@"b",@"h",@"y"],
                                         @[@"y",@"p",@"p",@"b",@"h",@"b"],
                                         @[@"r",@"y",@"y",@"b",@"g",@"r"],
                                         @[@"h",@"y",@"p",@"y",@"r",@"g"]]];
    NSString *expectedComboString = @"{\"Water\":[[3,9,15,21]],\"Darkness\":[[0,14,2,1,8]],\"Heal\":[[4,10,16]]}";
    NSMutableDictionary* combo = [board calculateScore];
    NSString *comboString = [PADHelperTests toJsonString:combo];
    XCTAssertEqualObjects(comboString,expectedComboString,@"elimination combo fail");
}
-(void)testBoard3
{
    PHBoard *board = [self createBoard:@[@[@"p",@"p",@"p",@"g",@"g",@"g"],
                                         @[@"h",@"y",@"y",@"g",@"h",@"y"],
                                         @[@"p",@"r",@"p",@"r",@"b",@"b"],
                                         @[@"y",@"r",@"y",@"p",@"r",@"p"],
                                         @[@"h",@"y",@"p",@"y",@"r",@"g"]]];
    NSString *expectedComboString = @"{\"Wood\":[[3,4,5]],\"Darkness\":[[0,1,2]]}";
    [self calculateBoard:board andExcpectJson:expectedComboString];
}

-(void)testBoard5
{
    PHBoard *board = [self createBoard:@[@[@"p",@"b",@"y",@"b",@"h",@"p"],
                                         @[@"y",@"r",@"y",@"y",@"y",@"r"],
                                         @[@"y",@"b",@"y",@"y",@"g",@"b"],
                                         @[@"r",@"p",@"r",@"b",@"g",@"r"],
                                         @[@"p",@"y",@"g",@"y",@"r",@"g"]]];
    NSString *expectedComboString = @"{\"Light\":[[14,10,9,2,8]]}";
    NSMutableDictionary* combo = [board calculateScore];
    NSString *comboString = [PADHelperTests toJsonString:combo];
    XCTAssertEqualObjects(comboString,expectedComboString,@"elimination combo fail");
}
-(void)testBoard4
{
    PHBoard *board = [self createBoard:@[@[@"p",@"p",@"p",@"h",@"g",@"g"],
                                         @[@"h",@"p",@"p",@"p",@"h",@"y"],
                                         @[@"p",@"r",@"b",@"r",@"b",@"b"],
                                         @[@"y",@"r",@"y",@"p",@"r",@"p"],
                                         @[@"h",@"y",@"p",@"y",@"r",@"g"]]];
    NSString *expectedComboString = @"{\"Darkness\":[[0,1,2,7,8,9]]}";
    NSMutableDictionary* combo = [board calculateScore];
    NSString *comboString = [PADHelperTests toJsonString:combo];
    XCTAssertEqualObjects(comboString,expectedComboString,@"elimination combo fail");
}

-(PHBoard *)createBoard:(NSArray*)arr
{
    PHBoard *board = [[PHBoard alloc]init];
    for (int y=0; y<5; y++) {
        for (int x=0; x<6; x++) {
            NSString *orbColorName = [[arr objectAtIndex:y]objectAtIndex:x];
            PHOrb *orb = [[PHOrb alloc]initWithOrbColor:orbColorName];
            [board addOrb:orb OnBoardAt:x andY:y];
        }
    }
    return board;
}
+(NSString*)toJsonString:(NSMutableDictionary*)arr
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr
                                                       options:0
                                                         error:NULL];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
- (void)calculateBoard:(PHBoard*)board andExcpectJson:(NSString*)jsonString
{
    //http://appleprogramming.com/blog/2013/12/26/xctest-assertions-documentation/
    NSMutableDictionary* combo = [board calculateScore];
    NSString *comboString = [PADHelperTests toJsonString:combo];
    XCTAssertEqualObjects(comboString,jsonString,@"elimination combo fail");
}


@end
