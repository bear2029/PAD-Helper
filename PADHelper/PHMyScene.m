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
    PHPathTracker *tracker;
    SKShapeNode *indicationLine;
    SceneModes mode;
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
        tracker = [[PHPathTracker alloc]init];
        mode = sceneEditable;
    }
    return self;
}
-(void)makeUtilities
{
    PHMainButton *resetButton = [PHMainButton createWithText:@"reset" onScene:self atIndexOf:1];
    PHMainButton *randButton = [PHMainButton createWithText:@"random" onScene:self atIndexOf:0];
    PHMainButton *replayButton = [PHMainButton createWithText:@"replay" onScene:self atIndexOf:2];
    PHMainButton *debugButton = [PHMainButton createWithText:@"debug" onScene:self atIndexOf:3];
    resetButton.delegateToMainScene = self;
    randButton.delegateToMainScene = self;
    replayButton.delegateToMainScene = self;
    debugButton.delegateToMainScene = self;
    
    [self createTimer];
    
    scorePanel = [[PHScorePanel alloc]init];
    scorePanel.position = CGPointMake(0, 350);
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

-(void)setOrbPosition:(PHOrb*)orb withX:(int)x andY:(int)y
{
    orb.position = CGPointMake(
                               [self physicalX:x],
                               [self physicalY:y]);
}
-(int)physicalX:(int)x
{
    return _x+x*w+_w/2;
}
-(int)physicalY:(int)y
{
    return _y+(4-y)*h+_h/2;
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
    if([text isEqualToString:@"random"]){
        [board randomAssignColor];
        [board stopHighLighting];
        [self hideIndication];
    }else if([text isEqualToString:@"reset"]){
        [board stopHighLighting];
        [board undo];
        [self hideIndication];
    }else if([text isEqualToString:@"replay"]){
        [board stopHighLighting];
        [board undo];
        [self hideIndication];
        NSMutableArray *path = [[tracker getTrack]mutableCopy];
        [self replayRoutine:path onIndex:0 withPreviousOrb:nil];
    }
    else if([text isEqualToString:@"debug"]){
        [board dump];
    }
}
-(void)replayRoutine:(NSMutableArray*)path onIndex:(int)index withPreviousOrb:(PHOrb*)previousOrb
{
    if([path count]>index){
        NSDictionary *pos = [path objectAtIndex:index];
        int x = [[pos objectForKey:@"x"] intValue];
        int y = [[pos objectForKey:@"y"] intValue];
        NSLog(@"pos:%@ => %d,%d",pos,x,y);
        PHOrb *orb = [board orbFromX:x andY:y];
        if(index>0){
            NSLog(@"before swap");
            [board swapOrb1:previousOrb andOrb2:orb onSuccess:^(void){
                [self replayRoutine:path onIndex:index+1 withPreviousOrb:previousOrb];
            }];
        }else{
            [self replayRoutine:path onIndex:index+1 withPreviousOrb:orb];
        }
    }
}
-(void)startPathWithOrb:(PHOrb*)orb andPosition:(CGPoint)point
{
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
    [self startTimer];
    // create tracker
    NSDictionary *pos = [board positionOfOrb:orb];
    
    int x = [[pos objectForKey:@"x"] intValue];
    int y = [[pos objectForKey:@"y"] intValue];
    [tracker createPathWithX:x andY:y fromBoard:board];
}
-(void)startTimer
{
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:.01
                                                      target:self
                                                    selector:@selector(setTime:)
                                                    userInfo:nil
                                                     repeats:YES];
}
-(void)showIndication
{
    mode = sceneIndication;
    NSArray *path = [tracker getTrack];
    [indicationLine removeFromParent];
    indicationLine = [SKShapeNode node];
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    for (int i=0; i<[path count]; i++) {
        NSDictionary *pos = [path objectAtIndex:i];
        int x = [self physicalX:[[pos objectForKey:@"x"] intValue]];
        int y = [self physicalY:[[pos objectForKey:@"y"] intValue]];
        if(i==0){
            CGPathMoveToPoint(pathToDraw, NULL, x, y);
        }else{
            CGPathAddLineToPoint(pathToDraw, NULL, x, y);
        }
    }
    indicationLine.path = pathToDraw;
    indicationLine.lineWidth = 3;
    indicationLine.zPosition = 3;
    [indicationLine setStrokeColor:[UIColor redColor]];
    [self addChild:indicationLine];
}
-(void)hideIndication
{
    mode = sceneEditable;
    [indicationLine removeFromParent];
    [scorePanel reset];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject]locationInNode:self];
    NSArray *nodes = [self nodesAtPoint:point];
    for (SKNode *node in nodes) {
        if(mode == sceneEditable && [node isKindOfClass:[PHOrb class]]){
            [board stopHighLighting];
            PHOrb *orb = (PHOrb*)node;
            [self startPathWithOrb:orb andPosition:point];
            break;
        }
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject]locationInNode:self];
    if(mode == sceneEditable && currentOrb){
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
            
            NSDictionary *pos1 = [board positionOfOrb:lastOrb];
            int x1 = [[pos1 objectForKey:@"x"] intValue];
            int y1 = [[pos1 objectForKey:@"y"] intValue];
            NSDictionary *pos2 = [board positionOfOrb:orb];
            int x2 = [[pos2 objectForKey:@"x"] intValue];
            int y2 = [[pos2 objectForKey:@"y"] intValue];
            if(abs(x1-x2)>1 ||abs(y1-y2)>1){
                continue;
            }
            [board swapOrb1:lastOrb andOrb2:orb];
            // add to tracker
            [tracker addToPath:x2 andY:y2];
            break;
        }
        currentOrb.position = point;
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(currentOrb && mode == sceneEditable){
        currentOrb.linkedOrb.alpha = 1;
        [currentOrb removeFromParent];
        [countDownTimer invalidate];
        NSMutableDictionary *combos = [board calculateScore];
        [scorePanel displayScoreFromCombo:combos];
        // high light the last orb
        PHOrb *lastOrb = [tracker getLastOrb];
        [lastOrb glowSpecial];
        [self showIndication];
    }
}

@end
