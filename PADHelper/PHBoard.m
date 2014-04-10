//
//  PHBoard.m
//  PADHelper
//
//  Created by BIINGYANN HSIUNG on 4/10/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

#import "PHBoard.h"

@implementation PHBoard{
    NSMutableArray *board;
}

-(id)init{
    board = [[NSMutableArray alloc]init];
    return self;
}
-(void)addOrb:(PHOrb *)orb OnBoardAt:(int)x andY:(int)y
{
    if([board count]<x+1){
        [board insertObject:[[NSMutableArray alloc]init] atIndex:x];
    }
    [[board objectAtIndex:x]insertObject:orb atIndex:y];
}
-(PHOrb*)getOrbAtX:(int)x andY:(int)y
{
    return [[board objectAtIndex:x]objectAtIndex:y];
}
-(void)randomAssignColor
{
    NSArray *names = @[@"darkness",@"fire",@"heal",@"light",@"water",@"wood"];
    for (NSMutableArray *col in board) {
        for (PHOrb *orb in col) {
            NSString *randName = [names objectAtIndex:arc4random()%[names count]];
            orb.texture = [SKTexture textureWithImageNamed:randName];
        }
    }
}

@end
