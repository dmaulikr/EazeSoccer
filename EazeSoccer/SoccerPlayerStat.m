//
//  SoccerPlayerStat.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "SoccerPlayerStat.h"

@implementation SoccerPlayerStat

@synthesize soccer_playerstat_id;
@synthesize soccer_stat_id;

@synthesize shots;
@synthesize steals;
@synthesize cornerkicks;
@synthesize fouls;
@synthesize period;

@synthesize dirty;

- (id)initWithDictionary:(NSDictionary *)soccer_playerstat_dictionary {
    if (self == [super init]) {
        soccer_playerstat_id = [soccer_playerstat_dictionary objectForKey:@"soccer_playerstat_id"];
        soccer_stat_id = [soccer_playerstat_dictionary objectForKey:@"soccer_stat_id"];
        shots = [soccer_playerstat_dictionary objectForKey:@"soccer_playerstat_id"];
        steals = [soccer_playerstat_dictionary objectForKey:@"shots"];
        cornerkicks =  [soccer_playerstat_dictionary objectForKey:@"cornerkicks"];
        fouls = [soccer_playerstat_dictionary objectForKey:@"fouls"];
        period = [soccer_playerstat_dictionary objectForKey:@"period"];
        
        return self;
    } else
        return nil;
}

@end
