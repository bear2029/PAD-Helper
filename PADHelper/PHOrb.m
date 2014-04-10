//
//  PHOrb.m
//  PADHelper
//
//  Created by BIINGYANN HSIUNG on 4/10/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

#import "PHOrb.h"

@implementation PHOrb

-(BOOL)isFromSamePosition:(PHOrb*)_orb
{
    return self.xIndex == _orb.xIndex && self.yIndex == _orb.yIndex;
}

@end
