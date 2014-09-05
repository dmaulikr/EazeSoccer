//
//  HockeyPenalty.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 8/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "HockeyPenalty.h"

@implementation HockeyPenalty

@synthesize hockey_stat_id;
@synthesize hockey_penalty_id;
@synthesize athlete_id;

@synthesize infraction;
@synthesize gametime;
@synthesize period;

@synthesize dirty;

- (id)initWithDictionary:(NSDictionary *)hockey_penalty_dictionary {
    if (self == [super init]) {
        hockey_penalty_id = [hockey_penalty_dictionary objectForKey:@"hockey_penalty_id"];
        hockey_stat_id = [hockey_penalty_dictionary objectForKey:@"hockey_stat_id"];
        athlete_id = [hockey_penalty_dictionary objectForKey:@"athlete_id"];
        
        infraction = [hockey_penalty_dictionary objectForKey:@"infraction"];
        gametime = [hockey_penalty_dictionary objectForKey:@"gametime"];
        period = [hockey_penalty_dictionary objectForKey:@"period"];
        
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
    
    if (hockey_stat_id)
        [dictionary setValue:hockey_stat_id forKey:@"hockey_stat_id"];
    
    if (hockey_penalty_id)
        [dictionary setValue:hockey_penalty_id forKey:@"hockey_penalty_id"];
    
    if (athlete_id)
        [dictionary setValue:athlete_id forKey:@"athlete_id"];
    
    return dictionary;
}

@end
