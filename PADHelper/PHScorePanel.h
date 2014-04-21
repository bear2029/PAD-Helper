//
//  PHBoard.h
//  PADHelper
//
//  Created by BIINGYANN HSIUNG on 4/10/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHOrb.h"

@interface PHScorePanel : SKNode

-(void)displayScoreFromCombo:(NSMutableDictionary*)combos;
-(void)reset;

@end
