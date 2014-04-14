//
//  PHOrb.m
//  PADHelper
//
//  Created by BIINGYANN HSIUNG on 4/10/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

#import "PHOrb.h"

@implementation PHOrb

-(id)init
{
    self.isMoving = NO;
    self = [super init];
    return self;
}
-(void)setOrbColor:(NSString *)color
{
    self.type = color;
    self.texture = [SKTexture textureWithImageNamed:color];
}
-(BOOL)isSameType:(PHOrb*)orb
{
    return orb.type = self.type;
}
-(int)getTypeAsInt
{
    if([self.type isEqualToString:@"p"]){
        return orbTypePurple;
    }else if([self.type isEqualToString:@"r"]){
        return orbTypeRed;
    }else if([self.type isEqualToString:@"h"]){
        return orbTypePink;
    }else if([self.type isEqualToString:@"y"]){
        return orbTypeYellow;
    }else if([self.type isEqualToString:@"b"]){
        return orbTypeBlue;
    }else{ // g
        return orbTypeGreen;
    }
}

@end
