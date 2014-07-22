//
//  WaterPoloPenalty.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/19/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "WaterPoloPenalty.h"

@implementation WaterPoloPenalty

@synthesize waterpolo_stat_id;
@synthesize waterpolo_penalty_id;
@synthesize athlete_id;
@synthesize visitor_roster_id;

@synthesize infraction;
@synthesize card;
@synthesize gametime;
@synthesize period;

@synthesize dirty;

- (id)initWithDictionary:(NSDictionary *)waterpolo_penalty_dictionary {
    if (self == [super init]) {
        waterpolo_penalty_id = [waterpolo_penalty_dictionary objectForKey:@"waterpolo_penalty_id"];
        waterpolo_stat_id = [waterpolo_penalty_dictionary objectForKey:@"waterpolo_stat_id"];
        athlete_id = [waterpolo_penalty_dictionary objectForKey:@"athlete_id"];
        visitor_roster_id = [waterpolo_penalty_dictionary objectForKey:@"visitor_roster_id"];
        
        infraction = [waterpolo_penalty_dictionary objectForKey:@"infraction"];
        card = [waterpolo_penalty_dictionary objectForKey:@"card"];
        gametime = [waterpolo_penalty_dictionary objectForKey:@"gametime"];
        period = [waterpolo_penalty_dictionary objectForKey:@"period"];
        
        return self;
    } else
        return nil;
}

- (NSMutableDictionary *)getDictionary {
    NSArray *timearray = [gametime componentsSeparatedByString:@":"];
    
    if (timearray.count < 2) {
        timearray = [[NSArray alloc] initWithObjects:@"00", @"00", nil];
    }
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:timearray[0], @"minutes", timearray[1], @"seconds",
                                       period, @"period", nil];
    
    if ([card isEqualToString:@"Y"])
        [dictionary setValue:infraction forKey:@"yellowcard"];
    else
        [dictionary setValue:infraction forKey:@"redcard"];
    
    if (waterpolo_stat_id)
        [dictionary setValue:waterpolo_stat_id forKey:@"waterpolo_stat_id"];
    
    if (waterpolo_penalty_id)
        [dictionary setValue:waterpolo_penalty_id forKey:@"waterpolo_penalty_id"];
    
    if (athlete_id)
        [dictionary setValue:athlete_id forKey:@"athlete_id"];
    else
        [dictionary setValue:visitor_roster_id forKey:@"visitor_roster_id"];
    
    return dictionary;
}

@end
