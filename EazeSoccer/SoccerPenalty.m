//
//  SoccerPenalty.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "SoccerPenalty.h"

@implementation SoccerPenalty

@synthesize soccer_stat_id;
@synthesize soccer_penalty_id;
@synthesize athlete_id;
@synthesize visitor_roster_id;

@synthesize infraction;
@synthesize card;
@synthesize gametime;
@synthesize period;

@synthesize dirty;

- (id)initWithDictionary:(NSDictionary *)soccer_penalty_dictionary {
    if (self == [super init]) {
        soccer_penalty_id = [soccer_penalty_dictionary objectForKey:@"soccer_penalty_id"];
        soccer_stat_id = [soccer_penalty_dictionary objectForKey:@"soccer_stat_id"];
        athlete_id = [soccer_penalty_dictionary objectForKey:@"athlete_id"];
        visitor_roster_id = [soccer_penalty_dictionary objectForKey:@"visitor_roster_id"];

        infraction = [soccer_penalty_dictionary objectForKey:@"infraction"];
        card = [soccer_penalty_dictionary objectForKey:@"card"];
        gametime = [soccer_penalty_dictionary objectForKey:@"gametime"];
        period = [soccer_penalty_dictionary objectForKey:@"period"];
        
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
    
    if (soccer_stat_id)
        [dictionary setValue:soccer_stat_id forKey:@"soccer_stat_id"];
    
    if (soccer_penalty_id)
        [dictionary setValue:soccer_penalty_id forKey:@"soccer_penalty_id"];
    
    if (athlete_id)
        [dictionary setValue:athlete_id forKey:@"athlete_id"];
    else
        [dictionary setValue:visitor_roster_id forKey:@"visitor_roster_id"];
    
    return dictionary;
}

@end
