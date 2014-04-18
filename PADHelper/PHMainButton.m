//
//  PHBoard.m
//  PADHelper
//
//  Created by BIINGYANN HSIUNG on 4/10/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

#import "PHMainButton.h"

@implementation PHMainButton{
    SKLabelNode *label;
    SKShapeNode *shapeNode;
}

-(id)initWithText:(NSString *)text
{
    self = [super init];
    self.userInteractionEnabled = YES;
    self.text = text;
    label = [[SKLabelNode alloc]init];
    label.fontSize = 13;
    label.fontColor = SKColor.whiteColor;
    label.text = text;
    
    CGRect box = CGRectMake(-24.0, -24.0, 48.0, 48.0);
    shapeNode = [[SKShapeNode alloc] init];
    shapeNode.path = [UIBezierPath bezierPathWithRect:box].CGPath;
    shapeNode.fillColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:.8];
    shapeNode.strokeColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1];
    [self addChild:shapeNode];
    [self addChild:label];

    return self;
}
+(id)createWithText:(NSString*)text onScene:(SKScene*)scene atIndexOf:(int)index
{
    PHMainButton *button = [[PHMainButton alloc]initWithText:text];
    button.position = CGPointMake(30+53*index, 310);
    [scene addChild:button];
    return button;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegateToMainScene buttonClicked:self.text];
}

@end
