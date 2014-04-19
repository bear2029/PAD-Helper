//
//  PHBoard.m
//  PADHelper
//
//  Created by BIINGYANN HSIUNG on 4/10/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

#import "PHScorePanel.h"

@implementation PHScorePanel{
    SKLabelNode *title;
    SKShapeNode *shapeNode;
    NSMutableArray *icons;
    NSMutableArray *colorLabels;
}

-(id)init{
    self = [super init];
    return self;
}

-(void)hide
{
}
-(void)displayScoreFromCombo:(NSMutableDictionary*)combos
{
    [self createBg];
    int index = 0;
    int totalCount = 0;

    for (NSString *colorString in combos) {
        
        NSArray *colorCombos = [combos objectForKey:colorString];
        NSString *iconFileName = [PHOrb getIconFileNameFromColorString:colorString];
        //self.texture = [SKTexture textureWithImageNamed:color];
        SKSpriteNode *icon = [[SKSpriteNode alloc]initWithImageNamed:iconFileName];
        icon.size = CGSizeMake(20, 20);
        icon.position = CGPointMake(50+index*35, 100);
        [self addChild:icon];
        [icons addObject:icon];
        
        SKLabelNode *label = [[SKLabelNode alloc]init];
        label.fontSize = 13;
        label.fontColor = SKColor.whiteColor;
        NSString *str = @"";
        for (int i=0; i<[colorCombos count]; i++) {
            NSArray *combo = [colorCombos objectAtIndex:i];
            totalCount++;
            int count = (unsigned long)[combo count];
            if(i!=0){
                str = [NSString stringWithFormat:@"%@ + %d",str,count];
            }else{
                str = [NSString stringWithFormat:@"%d",count];
            }
        }
        label.text = str;
        label.position = CGPointMake(65+index*35, 60);
        label.zRotation = -1;
        [self addChild:label];
        [colorLabels addObject:label];
        
        index++;
    }
    title = [[SKLabelNode alloc]init];
    title.text = [NSString stringWithFormat:@"%d combos total!",totalCount];
    title.fontSize = 15;
    title.fontColor = SKColor.whiteColor;
    title.position = CGPointMake(80, 150);
    [self addChild:title];
}
-(void)createBg
{
    shapeNode = [[SKShapeNode alloc]init];
    CGRect box = CGRectMake(10, 0, 300.0, 180.0);
    shapeNode = [[SKShapeNode alloc] init];
    shapeNode.path = [UIBezierPath bezierPathWithRect:box].CGPath;
    shapeNode.fillColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:.8];
    shapeNode.strokeColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1];
    [self addChild:shapeNode];
}

@end
