//
//  PHBoard.h
//  PADHelper
//
//  Created by BIINGYANN HSIUNG on 4/10/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHOrb.h"

@protocol DelegateToMainScene;



@interface PHMainButton : SKNode
@property NSString* text;
@property id<DelegateToMainScene> delegateToMainScene;
-(id)initWithText:(NSString*)text;
+(id)createWithText:(NSString*)text onScene:(SKScene*)scene atIndexOf:(int)index;

@end

@protocol DelegateToMainScene <NSObject>
-(void)buttonClicked:(NSString *)text;
@end
