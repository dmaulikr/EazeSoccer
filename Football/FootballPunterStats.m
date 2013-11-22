//
//  FootballPunterStats.m
//  EazeSportz
//
//  Created by Gil on 11/20/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "FootballPunterStats.h"

@implementation FootballPunterStats

@synthesize punts;
@synthesize punts_blocked;
@synthesize punts_long;
@synthesize punts_yards;

@synthesize football_punter_id;
@synthesize gameschedule_id;
@synthesize athlete_id;

- (id)init {
    if (self = [super init]) {
        punts = [NSNumber numberWithInt:0];
        punts_blocked = [NSNumber numberWithInt:0];
        punts_long = [NSNumber numberWithInt:0];
        punts_yards = [NSNumber numberWithInt:0];
        
        athlete_id = @"";
        gameschedule_id = @"";
        football_punter_id = @"";
        
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)punterDictionary {
    if ((self = [super init]) && (punterDictionary.count > 0)) {
        punts = [punterDictionary objectForKey:@"punts"];
        punts_blocked = [punterDictionary objectForKey:@"punts_blocked"];
        punts_long = [punterDictionary objectForKey:@"punts_long"];
        punts_yards = [punterDictionary objectForKey:@"punts_yards"];
        
        athlete_id = [punterDictionary objectForKey:@"athlete_id"];
        gameschedule_id = [punterDictionary objectForKey:@"gameschedule_id"];
        football_punter_id = [punterDictionary objectForKey:@"football_punter_id"];
        
        return self;
    } else
        return  nil;
}

@end
