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
    PHCalculator *calculator;
}

-(id)init{
    colors = [[NSMutableArray alloc]init];
    orbs = [[NSMutableArray alloc]init];
    calculator = [[PHCalculator alloc]init];
    return self;
}
-(void)addOrb:(PHOrb *)orb OnBoardAt:(int)x andY:(int)y
{
    if([orbs count]<=y){
        [orbs insertObject:[[NSMutableArray alloc]init] atIndex:y];
    }
    [[orbs objectAtIndex:y]insertObject:orb atIndex:x];
}
-(CGPoint)getPositionOfOrb:(PHOrb*)_orb
{
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
-(NSMutableArray*)calculateScore
{
    [calculator setIntBoardFromOrbs:orbs];
    NSMutableArray *combos = [calculator calculateScore];
    [self highLightWithCombos:combos];
    return combos;
}
-(void)highLightWithCombos:(NSMutableArray *)comboAll
{
    for (NSDictionary *combosLevel in comboAll) { // combos in each level
        for (NSString *color in combosLevel) {
            NSMutableArray *combosPerColor = [combosLevel objectForKey:color];// combos list for each color
            for (NSMutableArray *combos in combosPerColor) { // each combo for the color
                for (NSNumber *n in combos) {
                    int i = [n floatValue];
                    int y = ceilf(i/6);
                    int x = i%6;
                    PHOrb *orb = [[orbs objectAtIndex:y]objectAtIndex:x];
                    [orb runAction:[SKAction repeatActionForever:
                                    [SKAction sequence:@[
                                                         [SKAction fadeAlphaTo:.5 duration:1],
                                                         [SKAction fadeAlphaTo:1 duration:.5]
                                                         ]]]];
                    orb.alpha = .8;
                }
            }
        }
        break;
    }
}
-(void)stopHighLighting
{
    for (NSMutableArray *row in orbs) {
        for (PHOrb *orb in row) {
            orb.alpha = 1;
            [orb removeAllActions];
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
}
-(void)dump
{
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
    colors = previousColors;
    [self setColor];
}
-(void)setColor
{
    [self snapShot];
    for (int y=0; y<[orbs count]; y++) {
        NSMutableArray *row = [orbs objectAtIndex:y];
        for (int x=0; x<[row count]; x++) {
            NSString *colorName = [[colors objectAtIndex:x]objectAtIndex:y];
            PHOrb *orb = [[orbs objectAtIndex:y]objectAtIndex:x];
            [orb setOrbColor:colorName];
        }
    }
}
-(void)snapShot
{
    previousColors = [colors copy];
}
-(void)randomAssignColor
{
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
