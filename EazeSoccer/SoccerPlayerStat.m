//
//  SoccerPlayerStat.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "SoccerPlayerStat.h"

@implementation SoccerPlayerStat {
    int responseStatusCode;
    NSMutableData *theData;
}

@synthesize soccer_playerstat_id;
@synthesize soccer_stat_id;
@synthesize athlete_id;
@synthesize visitor_roster_id;

@synthesize shots;
@synthesize steals;
@synthesize cornerkicks;
@synthesize fouls;
@synthesize period;

@synthesize dirty;

- (id)init {
    if (self = [super init]) {
        shots = 0;
        steals = 0;
        cornerkicks = 0;
        fouls = 0;
        period = [NSNumber numberWithInt:1];
        
        athlete_id = @"";
        visitor_roster_id = @"";
        soccer_stat_id = @"";
        soccer_playerstat_id = @"";
        
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)soccer_playerstat_dictionary {
    if (self == [super init]) {
        soccer_playerstat_id = [soccer_playerstat_dictionary objectForKey:@"soccer_playerstat_id"];
        soccer_stat_id = [soccer_playerstat_dictionary objectForKey:@"soccer_stat_id"];
        athlete_id = [soccer_playerstat_dictionary objectForKey:@"athlete_id"];
        visitor_roster_id = [soccer_playerstat_dictionary objectForKey:@"visitor_roster_id"];
        
        shots = [soccer_playerstat_dictionary objectForKey:@"soccer_playerstat_id"];
        steals = [soccer_playerstat_dictionary objectForKey:@"shots"];
        cornerkicks =  [soccer_playerstat_dictionary objectForKey:@"cornerkicks"];
        fouls = [soccer_playerstat_dictionary objectForKey:@"fouls"];
        period = [soccer_playerstat_dictionary objectForKey:@"period"];
        
        return self;
    } else
        return nil;
}

- (NSDictionary *)getDictionary {
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:soccer_playerstat_id, @"soccer_playerstat_id",
                                soccer_stat_id, @"soccer_stat_id", athlete_id, @"athlete_id", visitor_roster_id, @"visitor_roster_id",
                                shots, @"shots", steals, @"steals", cornerkicks, @"cornerkicks", fouls, @"fouls", period, @"period", nil];
    return dictionary;
}

@end
