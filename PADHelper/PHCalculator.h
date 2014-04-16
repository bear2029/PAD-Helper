//
//  PHCalculator.h
//  PADHelper
//
//  Created by BIINGYANN HSIUNG on 4/16/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHOrb.h"

@interface PHCalculator : NSObject
@property NSMutableDictionary *combos;
-(NSMutableArray*)calculateScore;
-(void)setIntBoardFromOrbs:(NSMutableArray *)orbs;

@end
