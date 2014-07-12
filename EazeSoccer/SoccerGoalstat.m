//
//  SoccerGoalstat.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "SoccerGoalstat.h"

@implementation SoccerGoalstat

@synthesize soccer_stat_id;
@synthesize soccer_goalstat_id;
@synthesize athlete_id;
@synthesize visitor_roster_id;

@synthesize goals_allowed;
@synthesize saves;
@synthesize minutes_played;
@synthesize period;

@synthesize dirty;

- (id)initWithDictionary:(NSDictionary *)soccer_goalstat_dictionary {
    if (self == [super init]) {
        soccer_goalstat_id = [soccer_goalstat_dictionary objectForKey:@"soccer_goalstat_id"];
        soccer_stat_id = [soccer_goalstat_dictionary objectForKey:@"soccer_stat_id"];
        athlete_id = [soccer_goalstat_dictionary objectForKey:@"athlete_id"];
        visitor_roster_id = [soccer_goalstat_dictionary objectForKey:@"visitor_roster_id"];

        saves = [soccer_goalstat_dictionary objectForKey:@"saves"];
        goals_allowed = [soccer_goalstat_dictionary objectForKey:@"goals_allowed"];
        minutes_played = [soccer_goalstat_dictionary objectForKey:@"minutes_played"];
        period = [soccer_goalstat_dictionary objectForKey:@"period"];
        return self;
    } else
        return nil;
}

- (NSDictionary *)getDictionary {
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:soccer_goalstat_id, @"soccer_goalstat_id",
                                soccer_stat_id, @"soccer_stat_id", athlete_id, @"athlete_id", visitor_roster_id, @"visitor_roster_id",
                                goals_allowed, @"goals_allowed", saves, @"saves", minutes_played, @"minutes_played", period, @"period", nil];
    return dictionary;
}

@end
