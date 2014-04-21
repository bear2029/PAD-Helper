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
-(void)glow
{
    [self stopGlow];
    [self runAction:[SKAction repeatActionForever:
                    [SKAction sequence:@[
                                         [SKAction fadeAlphaTo:.5 duration:1],
                                         [SKAction fadeAlphaTo:1 duration:.5]
                                         ]]] withKey:@"glow"];
}
-(void)glowSpecial
{
    [self stopGlow];
    [self runAction:[SKAction repeatActionForever:
                     [SKAction sequence:@[
                                          [SKAction fadeAlphaTo:.2 duration:.5],
                                          [SKAction fadeAlphaTo:1 duration:.2]
                                          ]]] withKey:@"glow"];
}
-(void)stopGlow
{
    [self removeActionForKey:@"glow"];
}
-(id)initWithOrbColor:(NSString *)color
{
    self = [super init];
    [self setOrbColor:color];
    return self;
}
-(void)setOrbColor:(NSString *)color
{
    self.type = color;
    self.texture = [SKTexture textureWithImageNamed:color];
}
-(BOOL)isSameType:(PHOrb*)orb
{
    return [orb.type isEqualToString: self.type];
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
+(NSString*)getIconFileNameFromColorString:(NSString*)colorString
{
    if([colorString isEqualToString:@"Fire"]){
        return @"r";
    }else if([colorString isEqualToString:@"Wood"]){
        return @"g";
    }else if([colorString isEqualToString:@"Water"]){
        return @"b";
    }else if([colorString isEqualToString:@"Light"]){
        return @"y";
    }else if([colorString isEqualToString:@"Darkness"]){
        return @"p";
    }else if([colorString isEqualToString:@"Heal"]){
        return @"h";
    }
    return @"none";
}
+(NSString*)colorStringFromInt:(int)colorInt
{
    NSArray *colorNames = @[@"Fire",@"Wood",@"Water",@"Heal",
                            @"Light",@"Darkness"];
    return [colorNames objectAtIndex:colorInt];
}

@end
