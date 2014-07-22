//
//  WaterPoloPlayerstat.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/19/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "WaterPoloPlayerstat.h"

@implementation WaterPoloPlayerstat

{
    int responseStatusCode;
    NSMutableData *theData;
}

@synthesize waterpolo_playerstat_id;
@synthesize waterpolo_stat_id;
@synthesize athlete_id;
@synthesize visitor_roster_id;

@synthesize shots;
@synthesize steals;
@synthesize fouls;
@synthesize period;

@synthesize dirty;

- (id)init {
    if (self = [super init]) {
        shots = 0;
        steals = 0;
        fouls = 0;
        period = [NSNumber numberWithInt:1];
        
        athlete_id = @"";
        visitor_roster_id = @"";
        waterpolo_playerstat_id = @"";
        waterpolo_stat_id = @"";
        
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)waterpolo_playerstat_dictionary {
    if (self == [super init]) {
        waterpolo_playerstat_id = [waterpolo_playerstat_dictionary objectForKey:@"waterpolo_playerstat_id"];
        waterpolo_stat_id = [waterpolo_playerstat_dictionary objectForKey:@"waterpolo_stat_id"];
        athlete_id = [waterpolo_playerstat_dictionary objectForKey:@"athlete_id"];
        visitor_roster_id = [waterpolo_playerstat_dictionary objectForKey:@"visitor_roster_id"];
        
        shots = [waterpolo_playerstat_dictionary objectForKey:@"shots"];
        steals = [waterpolo_playerstat_dictionary objectForKey:@"steals"];
        fouls = [waterpolo_playerstat_dictionary objectForKey:@"fouls"];
        period = [waterpolo_playerstat_dictionary objectForKey:@"period"];
        
        return self;
    } else
        return nil;
}

- (NSMutableDictionary *)getDictionary {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:shots, @"shots", steals, @"steals",
                                       fouls, @"fouls", period, @"period", nil];
    
    if (waterpolo_stat_id)
        [dictionary setValue:waterpolo_stat_id forKey:@"waterpolo_stat_id"];
    
    if (waterpolo_playerstat_id)
        [dictionary setValue:waterpolo_playerstat_id forKey:@"waterpolo_playerstat_id"];
    
    if (athlete_id)
        [dictionary setValue:athlete_id forKey:@"athlete_id"];
    else
        [dictionary setValue:visitor_roster_id forKey:@"visitor_roster_id"];
    
    return dictionary;
}

@end
