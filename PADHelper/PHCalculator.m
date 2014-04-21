//
//  PHCalculator.m
//  PADHelper
//
//  Created by BIINGYANN HSIUNG on 4/16/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

#import "PHCalculator.h"

@implementation PHCalculator
{
    int intBoard[6][5];
    int associate[30];
}
-(void)setIntBoardFromOrbs:(NSMutableArray *)orbs
{
    for (int y=0; y<5; y++) {
        NSMutableArray *row = [orbs objectAtIndex:y];
        for (int x=0; x<6; x++) {
            PHOrb *orb = [row objectAtIndex:x];
            intBoard[x][y] = [orb getTypeAsInt];
        }
    }
}
-(NSMutableDictionary*)calculateScore
{
    //[self dump];
    self.globalCombos = [NSMutableDictionary dictionary];
    int count = 0,limit = 20;
    // init associate
    for (int x=0; x<6; x++) {
        for(int y=0; y<5; y++){
            associate[x+y*6] = x+y*6;
        }
    }
    do {
        self.combos = [[NSMutableDictionary alloc]init];
        [self calculateHorizontalScore];
        [self calculateVerticalScore];
        if([self.combos count]){
            //[comboForAllLevels addObject:self.combos];
            [self mergeToGlobalCombos:self.combos];
            [self eliminateCombo];
            //[self dumpAssociate];
        }else{
            break;
        }
        if(count>limit){ // add this to prevent infinate loop
            NSLog(@"something wrong, can't be doing so many times");
            break;
        }
        //NSLog(@"==================================================\n\n");
    } while ([self.combos count]);
    //NSLog(@"global %@",globalCombos);
    return self.globalCombos;
}
-(void)mergeToGlobalCombos:(NSMutableDictionary*)newCombo
{
    for (NSString *color in newCombo) {
        NSMutableArray *globalCombosOfColor = [self.globalCombos objectForKey:color];
        NSMutableArray *combosOfColor = [newCombo objectForKey:color];
        if(!globalCombosOfColor){ // init for that color in global combos
            globalCombosOfColor = [[NSMutableArray alloc]init];
            [self.globalCombos setObject:globalCombosOfColor forKey:color];
        }
        for (NSMutableArray *combo in combosOfColor) {
            NSMutableArray *adjustedCombo = [[NSMutableArray alloc]init];
            for (NSNumber *n in combo) {
                int i = [self findAssociationOrigin:[n intValue]];
                //NSLog(@"convert %@ to %d based on %@ => %@",n,i,[PHCalculator intPosToString:i],[PHCalculator intPosToString:associate[[n intValue]]]);
                [adjustedCombo addObject:[NSNumber numberWithInt:i]];
            }
            [globalCombosOfColor addObject:adjustedCombo];
        }
    }
}
-(int)findAssociationOrigin:(int)j
{
    for(int i=0; i<30; i++){
        if(associate[i] == j){
            return i;
        }
    }
    return -1;
}
-(void)eliminateCombo
{
    NSMutableArray *flatCombos = [[NSMutableArray alloc]init];
    // init new board
    int newIntBoard[6][5];
    for (int x=0; x<6; x++) {
        for(int y=0; y<5; y++){
            newIntBoard[x][y] = orbTypeEmpty;
        }
    }
    // create flat array of position of the combo, to check which one to eliminate
    for(id key in self.combos) {
        NSArray *colorCombos = [self.combos objectForKey:key];
        for (NSArray *colorCombo in colorCombos) {
            for (NSNumber *n in colorCombo) {
                [flatCombos addObject:n];
            }
        }
    }
    // create the new board after combo elimination
    for (int x=0; x<6; x++) {
        for(int y=4; y>=0; y--){
            BOOL isPartOfCombo = NO;
            for (NSNumber *n in flatCombos) {
                if([n intValue] == x+6*y){
                    isPartOfCombo = YES;
                    break;
                }
            }
            if(!isPartOfCombo){
                // insert from the bottom
                for (int _y=4; _y>=0; _y--) {
                    if(newIntBoard[x][_y] == orbTypeEmpty){//insert current to the bottom
                        newIntBoard[x][_y] = intBoard[x][y];
                        int origPos = x+y*6;
                        int afterPos = x+_y*6;
                        for (int i=0; i<30; i++) {
                            if(associate[i] == origPos){
                                associate[i] = afterPos;
                            }
                        }
                        break;
                    }
                }
            }
        }
    }
    memcpy(&intBoard, &newIntBoard, sizeof intBoard);
}
-(void)calculateHorizontalScore
{
    int previousType,count;
    for (int y=0; y<5; y++) {
        count = 1;
        previousType = intBoard[0][y];
        for (int x=1; x<6; x++) {
            if(intBoard[x][y] == orbTypeEmpty){
                continue;
            }
            bool isComboAtEndOfRow = intBoard[x][y] == previousType && x>=5 && count>=2;
            bool isComboJustBroke = intBoard[x][y] != previousType && count>=3;
            if(isComboAtEndOfRow || isComboJustBroke){ // end of the list, time to go
                int begin = isComboAtEndOfRow ? x-count : x-count;
                int to = isComboAtEndOfRow ? x : begin + count - 1;
                NSMutableArray *combo = [[NSMutableArray alloc]init];
                for(int i=begin;i<=to;i++){
                    [combo addObject:[NSNumber numberWithInt: i+y*6]];
                }
                [self addUpCombos:combo withColorInt:intBoard[to][y]];
                if(isComboAtEndOfRow){
                    break;
                }else{
                    count = 1;
                }
            }else if(intBoard[x][y] == previousType){ // equal, keep bet
                count++;
            }else{ // different, reset
                count = 1;
                previousType = intBoard[x][y];
            }
        }
    }
}
-(void)calculateVerticalScore
{
    int previousType,count;
    for (int x=0; x<6; x++) {
        count = 1;
        previousType = intBoard[x][0];
        for (int y=1; y<5; y++) {
            if(intBoard[x][y] == orbTypeEmpty){
                continue;
            }
            bool isComboAtEndOfRow = intBoard[x][y] == previousType && y>=4 && count>=2;
            bool isComboJustBroke = intBoard[x][y] != previousType && count>=3;
            if(isComboAtEndOfRow || isComboJustBroke){ // end of the list, time to go
                int begin = isComboAtEndOfRow ? y-count : y-count;
                int to = isComboAtEndOfRow ? y : begin + count - 1;
                NSMutableArray *combo = [[NSMutableArray alloc]init];
                for(int i=begin;i<=to;i++){
                    [combo addObject:[NSNumber numberWithInt: x+i*6]];
                }
                [self addUpCombos:combo withColorInt:intBoard[x][to]];
                if(isComboAtEndOfRow){
                    break;
                }else{
                    count = 1;
                }
            }else if(intBoard[x][y] == previousType){ // equal, keep bet
                count++;
            }else{ // different, reset
                count = 1;
                previousType = intBoard[x][y];
            }
        }
    }
}
-(void)addUpCombos:(NSMutableArray*)combo withColorInt:(int)colorInt
{
    NSString *colorKey = [PHOrb colorStringFromInt:colorInt];
    NSMutableArray *colorCombos = [self.combos objectForKey:colorKey];
    if(!colorCombos){
        colorCombos = [[NSMutableArray alloc]init];
        [self.combos setObject:colorCombos forKey:colorKey];
    }
    BOOL repeated = NO;
    for (int i=0; i<[colorCombos count]; i++) {
        NSMutableArray *colorCombo = colorCombos[i];
        NSMutableSet *intersection = [NSMutableSet setWithArray:colorCombo];
        [intersection intersectSet:[NSSet setWithArray:combo]];
        if([intersection count]>0){
            NSMutableSet *intersection = [NSMutableSet setWithArray:colorCombo];
            [intersection unionSet:[NSSet setWithArray:combo]];
            colorCombos[i] = [intersection allObjects];
            repeated = YES;
            break;
        }
    }
    if(!repeated){
        [colorCombos addObject:combo];
    }
}
-(void)dumpAssociate
{
    NSString *str = @"";
    int count = 0;
    for (int i=0; i<30; i++) {
        if(i!=associate[i]){
            str = [NSString stringWithFormat:@"%@\n%@ => %@",
                   str,
                   [PHCalculator intPosToString:i],
                   [PHCalculator intPosToString:associate[i]]];
            count++;
        }
    }
    //NSLog(@"associate: %@\ncount: %d",str,count);
}
+(NSString*)intPosToString:(int)pos
{
    int x = pos % 6;
    int y = (pos-x)/6;
    return [NSString stringWithFormat:@"(%d,%d)",x,y];
}
-(void)dump
{
    NSString *str = @"\n";
    for (int y=0; y<5; y++) {
        for (int x=0; x<6; x++) {
            str = [NSString stringWithFormat:@"%@ %d",str,intBoard[x][y]];
            if(x>=5){
                str = [NSString stringWithFormat:@"%@\n",str];
            }
        }
    }
    NSLog(@"%@",str);
}


@end
