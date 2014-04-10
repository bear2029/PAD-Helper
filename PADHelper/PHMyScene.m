//
//  PHMyScene.m
//  PADHelper
//
//  Created by BIINGYANN HSIUNG on 4/10/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

#import "PHMyScene.h"

@implementation PHMyScene{
    PHOrb *currentOrb;
    float _x,_y,w,_w,h,_h;
    PHBoard *board;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _x = 3;
        _y = 0;
        w = 53;
        _w = 50;
        h = 53;
        _h = 50;
        board = [[PHBoard alloc]init];
        /* Setup your scene here */
        [self makeBackground];
        [self makeOrbs];
        SKLabelNode *label = [[SKLabelNode alloc]init];
        label.text = @"rand";
        label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+50);
        [self addChild:label];
    }
    return self;
}
-(void)makeOrbs
{
    for (int x=0; x<6; x++) {
        for (int y=0; y<5; y++) {
            PHOrb *orb = [[PHOrb alloc]init];
            orb.size = CGSizeMake(_w, _h);
            [self setOrbPosition:orb withX:x andY:y];
            orb.xIndex = x;
            orb.yIndex = y;
            [self addChild:orb];
            orb.zPosition = 1;
            [board addOrb:orb OnBoardAt:x andY:y];
        }
    }
    [board randomAssignColor];
}

-(void)setOrbPosition:(PHOrb*)orb withX:(float)x andY:(float)y
{
    orb.position = CGPointMake(_x+x*w+_w/2,_y+y*h+_h/2);
}
-(void)makeBackground{
    SKSpriteNode *bg = [[SKSpriteNode alloc]initWithImageNamed:@"pad-bg.jpg"];
    bg.size = CGSizeMake(320, 568);
    bg.anchorPoint = CGPointMake(0, 0);
    bg.position = CGPointMake(0,0);
    [self addChild:bg];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject]locationInNode:self];
    NSArray *nodes = [self nodesAtPoint:point];
    for (SKNode *node in nodes) {
        if([node isKindOfClass:[PHOrb class]]){
            PHOrb *orb = (PHOrb*)node;
            orb.alpha = .5;
            if(!currentOrb){
                currentOrb = [[PHOrb alloc]init];
                currentOrb.size = CGSizeMake(_w, _h);
                currentOrb.zPosition = 2;
            }
            currentOrb.texture = orb.texture;
            currentOrb.position = point;
            currentOrb.xIndex = orb.xIndex;
            currentOrb.yIndex = orb.yIndex;
            currentOrb.linkedOrb = orb;
            [self addChild:currentOrb];
            break;
        }else if([node isKindOfClass:[SKLabelNode class]]){
            SKLabelNode *label = (SKLabelNode*)node;
            if([label.text isEqualToString:@"rand"]){
                [board randomAssignColor];
            }
        }
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject]locationInNode:self];
    if(currentOrb){
        NSArray *nodes = [self nodesAtPoint:point];
        for (SKNode *node in nodes) {
            if([node isKindOfClass:[PHOrb class]]){
                PHOrb *orb = (PHOrb*)node;
                if(![orb isFromSamePosition:currentOrb]){
                    PHOrb *lastOrb = currentOrb.linkedOrb;
                    lastOrb.alpha = 1;
                    currentOrb.linkedOrb = orb;
                    currentOrb.linkedOrb.alpha = .5;
                    lastOrb.texture = orb.texture;
                    orb.texture = currentOrb.texture;
                }
                break;
            }
        }
        currentOrb.position = point;
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //CGPoint point = [[touches anyObject]locationInNode:self];
    if(currentOrb){
        currentOrb.linkedOrb.alpha = 1;
        [currentOrb removeFromParent];
    }

}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
