//
//  PHOrb.h
//  PADHelper
//
//  Created by BIINGYANN HSIUNG on 4/10/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PHOrb : SKSpriteNode
@property int xIndex;
@property int yIndex;
@property PHOrb *linkedOrb;
@property BOOL isMoving;

@end
