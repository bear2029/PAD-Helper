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
    [self dump];
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
    NSMutableArray *combos = [[NSMutableArray alloc]init];
    combos = [self calculateHorizontalScore];
    [combos addObjectsFromArray:[self calculateVerticalScore]];
    for (int i=0; i<[combos count]; i++) {
        NSArray *targetCombo = [combos objectAtIndex:i];
        for (int j=0;j<[combos count];j++) {
            NSArray *compareComble = [combos objectAtIndex:j];
        }
    }
    NSLog(@"%@",combos);
}
-(NSMutableArray*)calculateHorizontalScore
{
    //NSMutableDictionary *score = [[NSMutableDictionary alloc]init];
    NSMutableArray *combos = [[NSMutableArray alloc]init];

    // horizontal
    for (int y=0; y<[orbs count]; y++) {
        NSMutableArray *row = [orbs objectAtIndex:y];
        int _count = 1;
        NSString *previousType;
        for (int x=0; x<[row count]; x++) {
            PHOrb *orb = [row objectAtIndex:x];
            if(x==0){
                previousType = orb.type;
                continue;
            }
            if([orb.type isEqualToString: previousType]){ // equal, keep bet
                _count++;
                if(x>=[row count]-1 && _count>=3){ // end of the list, time to go
                    NSMutableArray *combo = [[NSMutableArray alloc]init];
                    for(int i=x-_count;i<=x;i++){
                        [combo addObject:[NSValue valueWithCGPoint:CGPointMake(i, y)]];
                    }
                    [combos addObject:combo];
                }
            }else{ // not equal
                if(_count>=3){ // equal more than three, cash out
                    NSMutableArray *combo = [[NSMutableArray alloc]init];
                    for(int i=x-_count;i<=x-1;i++){
                        [combo addObject:[NSValue valueWithCGPoint:CGPointMake(i, y)]];
                    }
                    [combos addObject:combo];
                }
                //reset
                _count = 1;
                previousType = orb.type;
            }
        }
    }
    return combos;
}
-(NSMutableArray *)calculateVerticalScore
{
    // once per col
    // todo remove hard code
    NSMutableArray *combos = [[NSMutableArray alloc]init];
    int count[6] = {1,1,1,1,1,1};
    NSMutableArray *previousTypes = [[NSMutableArray alloc]init];
    for (int y=0; y<[orbs count]; y++) {
        NSMutableArray *row = [orbs objectAtIndex:y];
        for (int x=0; x<[row count]; x++) {
            PHOrb *orb = [row objectAtIndex:x];
            if(y==0){
                [previousTypes insertObject:orb.type atIndex:x];
                continue;
            }
            if([orb.type isEqualToString: [previousTypes objectAtIndex:x]]){ // equal, keep bet
                count[x]++;
                if(y>=4 && count[x]>=3){ // end of the list, time to go
                    NSMutableArray *combo = [[NSMutableArray alloc]init];
                    for(int i=y-count[x];i<=y;i++){
                        [combo addObject:[NSValue valueWithCGPoint:CGPointMake(x, i)]];
                    }
                    [combos addObject:combo];
                }
            }else{ // not equal
                if(count[x]>=3){ // equal more than three, cash out
                    NSMutableArray *combo = [[NSMutableArray alloc]init];
                    for(int i=y-count[x];i<=y-1;i++){
                        [combo addObject:[NSValue valueWithCGPoint:CGPointMake(x, i)]];
                    }
                    [combos addObject:combo];
                }
                //reset
                count[x] = 1;
                [previousTypes replaceObjectAtIndex:x withObject: orb.type];
            }
        }
    }
    return combos;
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
/*
-(int*)getIntBoard
{
    int intBoard[5][6];
    for (int y=0; y<[orbs count]; y++) {
        NSMutableArray *row = [orbs objectAtIndex:y];
        for (int x=0; x<[row count]; x++) {
            PHOrb *orb = [row objectAtIndex:x];
            intBoard[y][x] = [orb getTypeAsInt];
        }
    }
    return intBoard;
}*/
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
