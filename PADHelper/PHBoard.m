//
//  PHBoard.m
//  PADHelper
//
//  Created by BIINGYANN HSIUNG on 4/10/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

#import "PHBoard.h"

const int kSelectedEditData = 1;

@implementation PHBoard{
    NSMutableArray *orbs;
    NSMutableArray *colors;
    NSMutableArray *previousColors;
    NSMutableDictionary *combos;
    int intBoard[6][5];
}

-(id)init{
    colors = [[NSMutableArray alloc]init];
    orbs = [[NSMutableArray alloc]init];
    self.score = [[NSMutableDictionary alloc]init];
    return self;
}
-(void)addOrb:(PHOrb *)orb OnBoardAt:(int)x andY:(int)y
{
    if([orbs count]<=y){
        [orbs insertObject:[[NSMutableArray alloc]init] atIndex:y];
    }
    [[orbs objectAtIndex:y]insertObject:orb atIndex:x];
}
-(PHOrb*)getOrbAtX:(int)x andY:(int)y
{
    NSLog(@"get orb at pos");
    if([orbs count]>y && [[orbs objectAtIndex:y]count]>x){
        return [[orbs objectAtIndex:y]objectAtIndex:x];
    }
    return nil;
}
-(CGPoint)getPositionOfOrb:(PHOrb*)_orb
{
    NSLog(@"get pos");
    for (int y=0; y<[orbs count]; y++) {
        NSMutableArray *row = [orbs objectAtIndex:y];
        for (int x=0; x<[row count]; x++) {
            if([row objectAtIndex:x] == _orb){
                return CGPointMake(x,y);
            }
      }
    }
    return CGPointMake(-1, -1);
}
-(void)snapShot
{
    NSLog(@"snap");
    previousColors = [colors copy];
}
-(void)calculateScore
{
    [self getIntBoard];
    combos = [[NSMutableDictionary alloc]init];
    [self calculateHorizontalScore];
    [self calculateVerticalScore];
    NSLog(@"%@",combos);
}
-(void)calculateHorizontalScore
{
    int previousType,count;
    for (int y=0; y<5; y++) {
        count = 1;
        previousType = intBoard[0][y];
        for (int x=1; x<6; x++) {
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
    NSString *colorKey = [NSString stringWithFormat:@"%d", colorInt];
    NSMutableArray *colorCombos = [combos objectForKey:colorKey];
    if(!colorCombos){
        colorCombos = [[NSMutableArray alloc]init];
        [combos setObject:colorCombos forKey:colorKey];
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
-(void)traverse:(void(^)(PHOrb*,int x,int y))handler
{
    NSLog(@"traverse");
    for (int y=0; y<[orbs count]; y++) {
        NSMutableArray *row = [orbs objectAtIndex:y];
        for (int x=0; x<[row count]; x++) {
            PHOrb *orb = [row objectAtIndex:x];
            handler(orb,x,y);
        }
    }
}

-(void)getIntBoard
{
    for (int y=0; y<5; y++) {
        NSMutableArray *row = [orbs objectAtIndex:y];
        for (int x=0; x<6; x++) {
            PHOrb *orb = [row objectAtIndex:x];
            intBoard[x][y] = [orb getTypeAsInt];
        }
    }
}
-(void)swapOrb1:(PHOrb*)orb1 andOrb2:(PHOrb*)orb2
{
    CGPoint p1 = orb1.position;
    CGPoint p2 = orb2.position;
    orb1.isMoving = YES;
    orb2.isMoving = YES;
    [orb1 runAction:[SKAction sequence:@[
                                         [SKAction moveTo:p2 duration:.1]
                                         ]] completion:^(void){
                                            orb1.isMoving = NO;
    }];
    [orb2 runAction:[SKAction sequence:@[
                                         [SKAction moveTo:p1 duration:.1]
                                         ]] completion:^(void){
                                            orb2.isMoving = NO;
    }];
    CGPoint index1 = [self getPositionOfOrb:orb1];
    CGPoint index2 = [self getPositionOfOrb:orb2];
    [[orbs objectAtIndex:index1.y]setObject:orb2 atIndex:index1.x];
    [[orbs objectAtIndex:index2.y]setObject:orb1 atIndex:index2.x];
    NSLog(@"swap");
    [self dump];
}
-(void)dump
{
    NSLog(@"dump");
    NSString *str = @"\n";
    for (int y=0; y<[orbs count]; y++) {
        NSMutableArray *row = [orbs objectAtIndex:y];
        for (int x=0; x<[row count]; x++) {
            PHOrb *orb = [row objectAtIndex:x];
            str = [NSString stringWithFormat:@"%@ %@",str,[orb.type substringToIndex:1]];
            if(x>=[row count]-1){
                str = [NSString stringWithFormat:@"%@\n",str];
            }
        }
    }
    NSLog(@"%@",str);
}
-(void)undo
{
    NSLog(@"undo");
    colors = previousColors;
    [self setColor];
}
-(void)setColor
{
    NSLog(@"set color");
    [self snapShot];
    for (int y=0; y<[orbs count]; y++) {
        NSMutableArray *row = [orbs objectAtIndex:y];
        for (int x=0; x<[row count]; x++) {
            NSString *colorName = [[colors objectAtIndex:x]objectAtIndex:y];
            PHOrb *orb = [[orbs objectAtIndex:y]objectAtIndex:x];
            [orb setOrbColor:colorName];
        }
    }
    [self dump];
}

-(void)randomAssignColor
{
    NSLog(@"rand");
    NSArray *names = @[@"p",@"r",@"h",@"y",@"b",@"g"];
    for (int x=0; x<6; x++) {
        for (int y=0; y<5; y++) {
            if([colors count]<=x){
                [colors insertObject:[[NSMutableArray alloc]init] atIndex:x];
            }
            NSString *randName = [names objectAtIndex:arc4random()%[names count]];
            [[colors objectAtIndex:x]insertObject:randName atIndex:y];
        }
    }
    [self setColor];
}

@end
