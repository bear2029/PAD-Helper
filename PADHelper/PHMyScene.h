//
//  PHMyScene.h
//  PADHelper
//

//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PHOrb.h"
#import "PHBoard.h"
#import "PHScorePanel.h"
#import "PHMainButton.h"
#import "PHPathTracker.h"

typedef enum sceneModes {
    sceneEditable = 1,
    sceneIndication = 2
} SceneModes;

@interface PHMyScene : SKScene<DelegateToMainScene>

@end
