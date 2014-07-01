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

@synthesize goals_allowed;
@synthesize saves;
@synthesize minutes_played;
@synthesize period;

@synthesize dirty;

- (id)initWithDictionary:(NSDictionary *)soccer_goalstat_dictionary {
    if (self == [super init]) {
        soccer_goalstat_id = [soccer_goalstat_dictionary objectForKey:@"soccer_goalstat_id"];
        soccer_stat_id = [soccer_goalstat_dictionary objectForKey:@"soccer_stat_id"];
        saves = [soccer_goalstat_dictionary objectForKey:@"saves"];
        goals_allowed = [soccer_goalstat_dictionary objectForKey:@"goals_allowed"];
        minutes_played = [soccer_goalstat_dictionary objectForKey:@"minutes_played"];
        period = [soccer_goalstat_dictionary objectForKey:@"period"];
        return self;
    } else
        return nil;
}

@end
