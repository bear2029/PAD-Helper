//
//  PHOrb.h
//  PADHelper
//
//  Created by BIINGYANN HSIUNG on 4/10/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum orbTypeIds {
    orbTypeRed = 0,
    orbTypeGreen = 1,
    orbTypeBlue = 2,
    orbTypePink = 3,
    orbTypeYellow = 4,
    orbTypePurple = 5,
    orbTypeEmpty = -1
} OrbTypeIds;

@interface PHOrb : SKSpriteNode
@property PHOrb *linkedOrb;
@property BOOL isMoving;
@property NSString *type;

-(id)initWithOrbColor: (NSString*)color;
-(void)setOrbColor:(NSString *)color;
-(BOOL)isSameType:(PHOrb*)orb;
-(int)getTypeAsInt;
+(NSString*)colorStringFromInt:(int)colorInt;

@end
