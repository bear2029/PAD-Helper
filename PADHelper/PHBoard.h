//
//  PHBoard.h
//  PADHelper
//
//  Created by BIINGYANN HSIUNG on 4/10/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHOrb.h"
#import "PHCalculator.h"

extern const int kSelectedEditData;


@interface PHBoard : NSObject

-(NSMutableArray*)calculateScore;
-(void)addOrb:(PHOrb*)orb OnBoardAt:(int)x andY:(int)y;
-(void)randomAssignColor;
-(void)undo;
-(void)swapOrb1:(PHOrb*)orb1 andOrb2:(PHOrb*)orb2;
-(void)dump;
-(void)stopHighLighting;
-(void)highLightWithCombos:(NSMutableArray *)comboAll;


@end
