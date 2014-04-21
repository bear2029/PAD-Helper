//
//  PHPathTracker.h
//  PADHelper
//
//  Created by BIINGYANN HSIUNG on 4/20/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHBoard.h"
#import "PHOrb.h"

@interface PHPathTracker : NSObject

-(void)createPathWithX:(int)x andY:(int)y fromBoard:(PHBoard*)board;
-(void)addToPath:(int)x andY:(int)y;
-(BOOL)isValidStartingPoint:(int)x andY:(int)y;
-(NSArray*)getTrack;
-(NSArray*)getTrack:(int)index;
-(PHOrb*)getLastOrb;

@end
