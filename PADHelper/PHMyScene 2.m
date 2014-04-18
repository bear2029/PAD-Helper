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
    SKLabelNode *timer;
    PHScorePanel *scorePanel;
    NSTimer *countDownTimer;
    float mseconds;
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
        [self makeBackground];
        [self makeUtilities];
        [self makeOrbs];
    }
    return self;
}
-(void)makeUtilities
{
    PHMainButton *resetButton = [PHMainButton createWithText:@"reset" onScene:self atIndexOf:1];
    PHMainButton *randButton = [PHMainButton createWithText:@"random" onScene:self atIndexOf:0];
    PHMainButton *replayButton = [PHMainButton createWithText:@"replay" onScene:self atIndexOf:2];
    resetButton.delegateToMainScene = self;
    randButton.delegateToMainScene = self;
    replayButton.delegateToMainScene = self;
    
    [self createTimer];
    
    scorePanel = [[PHScorePanel alloc]init];
    scorePanel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+140);
    [self addChild:scorePanel];
}
-(void)createTimer
{
    timer = [[SKLabelNode alloc]init];
    timer.text = @"TIME: 0";
    timer.fontSize = 15;
    timer.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    timer.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
    timer.position = CGPointMake(CGRectGetMidX(self.frame)-22, CGRectGetMaxY(self.frame)-50);
    [self addChild:timer];
}
-(void)setTime:(NSTimer*)nstimer
{
    mseconds++;
    timer.text = [NSString stringWithFormat:@"TIME: %3.2f",mseconds/100];
}
-(void)makeOrbs
{
    for (int x=0; x<6; x++) {
        for (int y=0; y<5; y++) {
            PHOrb *orb = [[PHOrb alloc]init];
            orb.size = CGSizeMake(_w, _h);
            [self setOrbPosition:orb withX:x andY:y];
            [self addChild:orb];
            orb.zPosition = 1;
            [board addOrb:orb OnBoardAt:x andY:y];
        }
    }
    [board randomAssignColor];
}

-(void)setOrbPosition:(PHOrb*)orb withX:(float)x andY:(float)y
{
    orb.position = CGPointMake(
                               _x+x*w+_w/2,
                               _y+(4-y)*h+_h/2);
}
-(void)makeBackground{
    SKSpriteNode *bg = [[SKSpriteNode alloc]initWithImageNamed:@"pad-bg.jpg"];
    bg.size = CGSizeMake(320, 568);
    bg.anchorPoint = CGPointMake(0, 0);
    bg.position = CGPointMake(0,0);
    [self addChild:bg];
}
-(void)buttonClicked:(NSString *)text
{
    [scorePanel reset];
    [board stopHighLighting];
    if([text isEqualToString:@"random"]){
        [board randomAssignColor];
    }else if([text isEqualToString:@"reset"]){
        [board undo];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject]locationInNode:self];
    NSArray *nodes = [self nodesAtPoint:point];
    [scorePanel reset];
    [board stopHighLighting];
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
            currentOrb.linkedOrb = orb;
            [self addChild:currentOrb];
            mseconds = 0;
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:.01
                                                              target:self
                                                            selector:@selector(setTime:)
                                                            userInfo:nil
                                                             repeats:YES];
            break;
        }
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject]locationInNode:self];
    if(currentOrb){
        NSArray *nodes = [self nodesAtPoint:point];
        for (SKNode *node in nodes) {
            if(![node isKindOfClass:[PHOrb class]]){
                continue;
            }
            PHOrb *orb = (PHOrb*)node;
            PHOrb *lastOrb = currentOrb.linkedOrb;
            if(orb == lastOrb || orb == currentOrb){
                continue;
            }
            if(orb.isMoving || lastOrb.isMoving){
                break;
            }
            [board swapOrb1:lastOrb andOrb2:orb];
            break;
        }
        currentOrb.position = point;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(currentOrb){
        currentOrb.linkedOrb.alpha = 1;
        [currentOrb removeFromParent];
        [countDownTimer invalidate];
        NSMutableArray *combos = [board calculateScore];
        [scorePanel displayScoreFromCombo:combos];
    }
}

@end
