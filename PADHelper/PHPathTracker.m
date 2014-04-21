//
//  PHPathTracker.m
//  PADHelper
//
//  Created by BIINGYANN HSIUNG on 4/20/14.
//  Copyright (c) 2014 BIINGYANN HSIUNG. All rights reserved.
//

#import "PHPathTracker.h"

@implementation PHPathTracker{
    NSMutableArray *currentTrack;
    NSMutableArray *allTracks;
    PHBoard *board;
}

-(id)init
{
    self = [super init];
    allTracks = [[NSMutableArray alloc]init];
    return self;
}
-(void)createPathWithX:(int)x andY:(int)y fromBoard:(PHBoard *)_board
{
    if([currentTrack count]){
        [allTracks addObject:[currentTrack copy]];
    }
    board = _board;
    NSDictionary *pos = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithInt:x],@"x",
                         [NSNumber numberWithInt:y],@"y",nil];
    currentTrack = [[NSMutableArray alloc]init];
    [currentTrack addObject:pos];
}
-(void)addToPath:(int)x andY:(int)y
{
    // todo validate
    [currentTrack addObject:[NSDictionary
                             dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:x],@"x",
                             [NSNumber numberWithInt:y],@"y", nil]];
}
-(BOOL)isValidStartingPoint:(int)x andY:(int)y
{
    return YES;
}
-(NSArray*)getTrack
{
    return currentTrack;
}
-(NSArray*)getTrack:(int)index
{
    return [allTracks objectAtIndex:index];
}
-(PHOrb*)getLastOrb
{
    NSDictionary *pos = [currentTrack lastObject];
    int x = [[pos objectForKey:@"x"]intValue];
    int y = [[pos objectForKey:@"y"]intValue];
    return [board orbFromX:x andY:y];
}


@end
