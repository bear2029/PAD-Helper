//
//  PHScreenParser.h
//  PADHelper
//
//  Created by kt on 4/17/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColorProcess.h"

@interface PHScreenParser : NSObject

@property (strong, nonatomic) UIImage *chosenImage;

-(void)setChosenImage:(UIImage *)chosenImage;

-(id)initWithImage:(UIImage *) image;
-(void)setScreenShot:(UIImage *) screenShot;
-(void)parseScreenShot;
-(NSString *)getColorCodeOf:(int)row :(int)column;
-(NSString *)mapAverageColor: (UIColor *) avgCol;
-(UIColor *)mergedColor: (UIImage *)orbRect;
-(UIColor *)averageColor: (UIImage *)orbRect;

@end
