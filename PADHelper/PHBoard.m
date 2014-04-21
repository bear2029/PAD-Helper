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
-(PHOrb*)orbFromX:(int)x andY:(int)y
{
    if([orbs count]<=y){
        return nil;
    }
    NSArray *row = [orbs objectAtIndex:y];
    if([row count]<=x){
        return nil;
    }
    return [row objectAtIndex:x];
}
-(NSDictionary*)positionOfOrb:(PHOrb*)_orb
{
    for (int y=0; y<[orbs count]; y++) {
        NSMutableArray *row = [orbs objectAtIndex:y];
        for (int x=0; x<[row count]; x++) {
            if([row objectAtIndex:x] == _orb){
                NSDictionary *pos = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInt:x],@"x",
                                     [NSNumber numberWithInt:y],@"y", nil];
                return pos;
            }
      }
    }
    return nil;
}
-(NSMutableDictionary*)calculateScore
{
    [calculator setIntBoardFromOrbs:orbs];
    NSMutableDictionary *combos = [calculator calculateScore];
    [self highLightWithCombos:combos];
    return combos;
}
-(void)highLightWithCombos:(NSMutableDictionary *)allCombos
{
        for (NSString *color in allCombos) {
            NSMutableArray *combosOfColor = [allCombos objectForKey:color];// combos list for each color
            for (NSMutableArray *combos in combosOfColor) { // each combo for the color
                for (NSNumber *n in combos) {
                    int i = [n floatValue];
                    int y = ceilf(i/6);
                    int x = i%6;
                    PHOrb *orb = [[orbs objectAtIndex:y]objectAtIndex:x];
                    [orb glow];
                    orb.alpha = .8;
                }
            }
        }
}
-(void)stopHighLighting
{
    for (NSMutableArray *row in orbs) {
        for (PHOrb *orb in row) {
            orb.alpha = 1;
            [orb stopGlow];
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
                                         [SKAction moveTo:p2 duration:.05]
                                         ]] completion:^(void){
                                            orb1.isMoving = NO;
    }];
    [orb2 runAction:[SKAction sequence:@[
                                         [SKAction moveTo:p1 duration:.05]
                                         ]] completion:^(void){
                                            orb2.isMoving = NO;
    }];
    NSDictionary *index1 = [self positionOfOrb:orb1];
    NSDictionary *index2 = [self positionOfOrb:orb2];
    int x1 = [[index1 objectForKey:@"x"] intValue];
    int y1 = [[index1 objectForKey:@"y"] intValue];
    int x2 = [[index2 objectForKey:@"x"] intValue];
    int y2 = [[index2 objectForKey:@"y"] intValue];
    [[orbs objectAtIndex:y1] setObject:orb2 atIndex:x1];
    [[orbs objectAtIndex:y2]setObject:orb1 atIndex:x2];
}
-(void)dump
{
    NSString *str = @"\n";
    for (int y=0; y<[orbs count]; y++) {
        NSMutableArray *row = [orbs objectAtIndex:y];
        for (int x=0; x<[row count]; x++) {
            PHOrb *orb = [row objectAtIndex:x];
            str = [NSString stringWithFormat:@"%@ %@",str,orb.type];
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
