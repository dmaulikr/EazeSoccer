//
//  FootballKickerStats.m
//  EazeSportz
//
//  Created by Gil on 11/20/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "FootballKickerStats.h"

@implementation FootballKickerStats

@synthesize koattempts;
@synthesize koreturned;
@synthesize kotouchbacks;

@synthesize football_kicker_id;
@synthesize gameschedule_id;
@synthesize athlete_id;

- (id)init {
    if (self = [super init]) {
        koattempts = [NSNumber numberWithInt:0];
        koreturned = [NSNumber numberWithInt:0];
        kotouchbacks = [NSNumber numberWithInt:0];
        
        athlete_id = @"";
        gameschedule_id = @"";
        football_kicker_id = @"";
        
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)kickerDictionary {
    if ((self = [super init]) && (kickerDictionary.count > 0)) {
        koattempts = [kickerDictionary objectForKey:@"koattempts"];
        koreturned = [kickerDictionary objectForKey:@"koreturned"];
        kotouchbacks = [kickerDictionary objectForKey:@"kotouchbacks"];
        
        athlete_id = [kickerDictionary objectForKey:@"athlete_id"];
        gameschedule_id = [kickerDictionary objectForKey:@"gameschedule_id"];
        football_kicker_id = [kickerDictionary objectForKey:@"football_kicker_id"];
        
        return self;
    } else
        return nil;
}

@end
