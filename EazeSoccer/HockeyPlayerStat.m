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
@synthesize plusminus;
@synthesize faceoffwon;
@synthesize faceofflost;
@synthesize timeonice;
@synthesize blockedshots;
@synthesize hits;

@synthesize period;

@synthesize dirty;

- (id)init {
    if (self = [super init]) {
        shots = [NSNumber numberWithInt:0];
        plusminus = [NSNumber numberWithInt:0];
        faceofflost = [NSNumber numberWithInt:0];
        faceoffwon = [NSNumber numberWithInt:0];
        blockedshots = [NSNumber numberWithInt:0];
        hits = [NSNumber numberWithInt:0];
        period = [NSNumber numberWithInt:1];
        
        timeonice = @"00:00";
        
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
        hockey_stat_id = [hockey_playerstat_dictionary objectForKey:@"hockey_stat_id"];
        athlete_id = [hockey_playerstat_dictionary objectForKey:@"athlete_id"];
        
        shots = [hockey_playerstat_dictionary objectForKey:@"shots"];
        plusminus = [hockey_playerstat_dictionary objectForKey:@"plusminus"];
        faceoffwon = [hockey_playerstat_dictionary objectForKey:@"faceoffwon"];
        faceofflost = [hockey_playerstat_dictionary objectForKey:@"faceofflost"];
        timeonice = [hockey_playerstat_dictionary objectForKey:@"timeonice"];
        blockedshots = [hockey_playerstat_dictionary objectForKey:@"blockedshots"];
        hits = [hockey_playerstat_dictionary objectForKey:@"hits"];
        
        period = [hockey_playerstat_dictionary objectForKey:@"period"];
        
        return self;
    } else
        return nil;
}

- (NSMutableDictionary *)getDictionary {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:shots, @"shots", plusminus, @"plusminus",
                                       faceoffwon, @"faceoffwon", faceofflost, @"faceofflost", timeonice, @"timeonice",
                                       blockedshots, @"blockedshots", hits, @"hits", period, @"period", nil];
    
    if (hockey_stat_id)
        [dictionary setValue:hockey_stat_id forKey:@"hockey_stat_id"];
    
    if (hockey_playerstat_id)
        [dictionary setValue:hockey_playerstat_id forKey:@"hockey_playerstat_id"];
    
    if (athlete_id)
        [dictionary setValue:athlete_id forKey:@"athlete_id"];
    
    return dictionary;
}

@end
