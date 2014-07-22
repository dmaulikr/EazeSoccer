//
//  WaterPoloGoalstat.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/19/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "WaterPoloGoalstat.h"

@implementation WaterPoloGoalstat

@synthesize waterpolo_stat_id;
@synthesize waterpolo_goalstat_id;
@synthesize athlete_id;
@synthesize visitor_roster_id;

@synthesize goals_allowed;
@synthesize saves;
@synthesize minutes_played;
@synthesize period;

@synthesize dirty;

- (id)initWithDictionary:(NSDictionary *)waterpolo_goalstat_dictionary {
    if (self == [super init]) {
        waterpolo_goalstat_id = [waterpolo_goalstat_dictionary objectForKey:@"waterpolo_goalstat_id"];
        waterpolo_stat_id = [waterpolo_goalstat_dictionary objectForKey:@"waterpolo_stat_id"];
        athlete_id = [waterpolo_goalstat_dictionary objectForKey:@"athlete_id"];
        visitor_roster_id = [waterpolo_goalstat_dictionary objectForKey:@"visitor_roster_id"];
        
        saves = [waterpolo_goalstat_dictionary objectForKey:@"saves"];
        goals_allowed = [waterpolo_goalstat_dictionary objectForKey:@"goals_allowed"];
        minutes_played = [waterpolo_goalstat_dictionary objectForKey:@"minutes_played"];
        period = [waterpolo_goalstat_dictionary objectForKey:@"period"];
        return self;
    } else
        return nil;
}

- (NSMutableDictionary *)getDictionary {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:goals_allowed, @"goals_allowed", saves, @"saves",
                                       minutes_played, @"minutes_played", period, @"period", nil];
    
    if (waterpolo_stat_id)
        [dictionary setValue:waterpolo_stat_id forKey:@"waterpolo_stat_id"];
    
    if (waterpolo_goalstat_id)
        [dictionary setValue:waterpolo_goalstat_id forKey:@"waterpolo_goalstat_id"];
    
    if (athlete_id)
        [dictionary setValue:athlete_id forKey:@"athlete_id"];
    else
        [dictionary setValue:visitor_roster_id forKey:@"visitor_roster_id"];
    
    return dictionary;
}

@end
