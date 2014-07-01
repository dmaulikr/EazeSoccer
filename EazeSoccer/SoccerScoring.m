//
//  SoccerScoring.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "SoccerScoring.h"

@implementation SoccerScoring

@synthesize soccer_scoring_id;
@synthesize soccer_stat_id;

@synthesize gametime;
@synthesize assist;
@synthesize period;

@synthesize photos;
@synthesize videos;
@synthesize dirty;

- (id)init {
    if (self = [super init]) {
        period = [NSNumber numberWithInt:0];
        assist = @"";
        gametime = @"00:00";
        photos = [[NSMutableArray alloc] init];
        videos = [[NSMutableArray alloc] init];
        dirty = NO;
        
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)soccer_scoring_dictionary {
    if (self == [super init]) {
        soccer_scoring_id = [soccer_scoring_dictionary objectForKey:@"soccer_scoring_id"];
        soccer_stat_id = [soccer_scoring_dictionary objectForKey:@"soccer_stat_id"];
        gametime = [soccer_scoring_dictionary objectForKey:@"soccer_scoring_id"];
        soccer_stat_id = [soccer_scoring_dictionary objectForKey:@"gametime"];
        assist = [soccer_scoring_dictionary objectForKey:@"assist"];
        period = [soccer_scoring_dictionary objectForKey:@"period"];
        
        NSArray *photoarray = [soccer_scoring_dictionary objectForKey:@"photos"];
        photos = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < photoarray.count; i++) {
            NSDictionary *dictionary = [photoarray objectAtIndex:i];
            [photos addObject:[dictionary objectForKey:@"id"]];
        }
        
        NSArray *videoarray = [soccer_scoring_dictionary objectForKey:@"videos"];
        videos = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < videoarray.count; i++) {
            NSDictionary *dictionary = [videoarray objectAtIndex:i];
            [videos addObject:[dictionary objectForKey:@"id"]];
        }
        
        return  self;
    } else
        return nil;
}

@end
