//
//  HockeyPlayerStat.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 8/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "HockeyPlayerStat.h"

@implementation HockeyPlayerStat

@synthesize hockey_playerstat_id;
@synthesize hockey_stat_id;
@synthesize athlete_id;

@synthesize shots;
@synthesize period;

@synthesize dirty;

- (id)init {
    if (self = [super init]) {
        shots = 0;
        period = [NSNumber numberWithInt:1];
        
        athlete_id = @"";
        hockey_playerstat_id = @"";
        hockey_stat_id = @"";
        
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)hockey_playerstat_dictionary {
    if (self == [super init]) {
        hockey_playerstat_id = [hockey_playerstat_dictionary objectForKey:@"hockey_playerstat_id"];
        hockey_playerstat_id = [hockey_playerstat_dictionary objectForKey:@"hockey_playerstat_id"];
        athlete_id = [hockey_playerstat_dictionary objectForKey:@"athlete_id"];
        
        shots = [hockey_playerstat_dictionary objectForKey:@"shots"];
        period = [hockey_playerstat_dictionary objectForKey:@"period"];
        
        return self;
    } else
        return nil;
}

- (NSMutableDictionary *)getDictionary {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:shots, @"shots", period, @"period", nil];
    
    if (hockey_stat_id)
        [dictionary setValue:hockey_stat_id forKey:@"hockey_stat_id"];
    
    if (hockey_playerstat_id)
        [dictionary setValue:hockey_playerstat_id forKey:@"hockey_playerstat_id"];
    
    if (athlete_id)
        [dictionary setValue:athlete_id forKey:@"athlete_id"];
    
    return dictionary;
}

@end
