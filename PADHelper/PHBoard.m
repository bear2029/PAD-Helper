//
//  PHBoard.m
//  PADHelper
//
//  Created by BIINGYANN HSIUNG on 4/10/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

#import "PHBoard.h"

@implementation PHBoard{
    NSMutableArray *orbs;
    NSMutableArray *colors;
    NSMutableArray *previousColors;
}

-(id)init{
    colors = [[NSMutableArray alloc]init];
    orbs = [[NSMutableArray alloc]init];
    return self;
}
-(void)addOrb:(PHOrb *)orb OnBoardAt:(int)x andY:(int)y
{
    [orbs addObject:orb];
}
-(PHOrb*)getOrbAtX:(int)x andY:(int)y
{
    for (PHOrb *orb in orbs) {
        if(orb.xIndex == x && orb.yIndex == y){
            return orb;
        }
    }
    return nil;
}
-(void)snapShot
{
    previousColors = [colors copy];
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
    int x1 = orb1.xIndex;
    int y1 = orb1.yIndex;
    orb1.xIndex = orb2.xIndex;
    orb1.yIndex = orb2.yIndex;
    orb2.xIndex = x1;
    orb2.yIndex = y1;
}
-(void)undo
{
    colors = previousColors;
    [self setColor];
}
-(void)setColor
{
    [self snapShot];
    for (PHOrb *orb in orbs) {
        NSString *randName = [[colors objectAtIndex:orb.xIndex]objectAtIndex:orb.yIndex];
        orb.texture = [SKTexture textureWithImageNamed:randName];
    }
}
-(void)randomAssignColor
{
    NSArray *names = @[@"darkness",@"fire",@"heal",@"light",@"water",@"wood"];
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
