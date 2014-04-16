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
    SKLabelNode *timer,*scoreText;
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
        /* Setup your scene here */
        [self makeBackground];
        [self makeOrbs];
        [self makeUtilities];
    }
    return self;
}
-(void)makeUtilities
{
    SKLabelNode *rand = [[SKLabelNode alloc]init];
    rand.text = @"rand";
    rand.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+50);
    [self addChild:rand];
    
    SKLabelNode *reset = [[SKLabelNode alloc]init];
    reset.text = @"reset";
    reset.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+80);
    [self addChild:reset];
    [self createTimer];
    
    scoreText = [[SKLabelNode alloc]init];
    scoreText.fontSize = 13;
    scoreText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+110);
    [self addChild:scoreText];
    
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
            currentOrb.linkedOrb = orb;
            [self addChild:currentOrb];
            mseconds = 0;
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:.01
                                                              target:self
                                                            selector:@selector(setTime:)
                                                            userInfo:nil
                                                             repeats:YES];
            break;
        }else if([node isKindOfClass:[SKLabelNode class]]){
            SKLabelNode *label = (SKLabelNode*)node;
            if([label.text isEqualToString:@"rand"]){
                [board randomAssignColor];
            }else if([label.text isEqualToString:@"reset"]){
                [board undo];
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
    //CGPoint point = [[touches anyObject]locationInNode:self];
    if(currentOrb){
        currentOrb.linkedOrb.alpha = 1;
        [currentOrb removeFromParent];
        [countDownTimer invalidate];
        NSMutableArray *combos = [board calculateScore];
        [self displayScoreFromCombo:combos];
    }
}
-(void)displayScoreFromCombo:(NSMutableArray*)comboAll
{
    NSString *text = @"";
    for (NSDictionary *colorCombo in comboAll) {
        for (NSString *color in colorCombo) {
            NSArray *combos = [colorCombo objectForKey:color];
            text = [NSString stringWithFormat:@"%@%@: %lu\n",
                    text,
                    [PHOrb colorStringFromInt: [color intValue]],
                    (unsigned long)[combos count]];
        }
    }
    scoreText.text = text;
}
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
