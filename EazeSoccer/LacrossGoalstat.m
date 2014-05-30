//
//  LacrossGoalstat.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/22/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "LacrossGoalstat.h"

@implementation LacrossGoalstat

@synthesize saves;
@synthesize goals_allowed;
@synthesize minutesplayed;
@synthesize period;

@synthesize lacrosstat_id;
@synthesize lacross_goalstat_id;
@synthesize athlete_id;
@synthesize visitor_roster_id;

- (id)initWithDictionary:(NSDictionary *)lacross_goalstat_dictionary {
    if (self = [super init]) {
        saves = [lacross_goalstat_dictionary objectForKey:@"saves"];
        goals_allowed = [lacross_goalstat_dictionary objectForKey:@"goals_allowed"];
        minutesplayed = [lacross_goalstat_dictionary objectForKey:@"minutesplayed"];
        period = [lacross_goalstat_dictionary objectForKey:@"period"];
        
        lacross_goalstat_id = [lacross_goalstat_dictionary objectForKey:@"lacross_goalstat_id"];
        lacrosstat_id = [lacross_goalstat_dictionary objectForKey:@"lacrosstat_id"];
        athlete_id = [lacross_goalstat_dictionary objectForKey:@"athlete_id"];
        visitor_roster_id = [lacross_goalstat_dictionary objectForKey:@"visitor_roster_id"];
        
        return self;
    } else
        return nil;
}

@end
