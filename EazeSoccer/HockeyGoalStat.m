//
//  HockeyGoalStat.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 8/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "HockeyGoalStat.h"

@implementation HockeyGoalStat

@synthesize hockey_stat_id;
@synthesize hockey_goalstat_id;
@synthesize athlete_id;

@synthesize goals_allowed;
@synthesize saves;
@synthesize minutes_played;
@synthesize period;

@synthesize dirty;

- (id)initWithDictionary:(NSDictionary *)hockey_goalstat_dictionary {
    if (self == [super init]) {
        hockey_goalstat_id = [hockey_goalstat_dictionary objectForKey:@"hockey_goalstat_id"];
        hockey_goalstat_id = [hockey_goalstat_dictionary objectForKey:@"hockey_stat_id"];
        athlete_id = [hockey_goalstat_dictionary objectForKey:@"athlete_id"];
        
        saves = [hockey_goalstat_dictionary objectForKey:@"saves"];
        goals_allowed = [hockey_goalstat_dictionary objectForKey:@"goals_allowed"];
        minutes_played = [hockey_goalstat_dictionary objectForKey:@"minutes_played"];
        period = [hockey_goalstat_dictionary objectForKey:@"period"];
        return self;
    } else
        return nil;
}

- (NSMutableDictionary *)getDictionary {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:goals_allowed, @"goals_allowed", saves, @"saves",
                                       minutes_played, @"minutes_played", period, @"period", nil];
    
    if (hockey_stat_id)
        [dictionary setValue:hockey_stat_id forKey:@"hockey_stat_id"];
    
    if (hockey_goalstat_id)
        [dictionary setValue:hockey_goalstat_id forKey:@"hockey_goalstat_id"];
    
    if (athlete_id)
        [dictionary setValue:athlete_id forKey:@"athlete_id"];
    
    return dictionary;
}

@end
