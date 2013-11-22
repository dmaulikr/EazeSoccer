//
//  FootballRushingStat.m
//  EazeSportz
//
//  Created by Gil on 11/20/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "FootballRushingStat.h"

@implementation FootballRushingStat

@synthesize attempts;
@synthesize average;
@synthesize fumbles;
@synthesize fumbles_lost;
@synthesize longest;
@synthesize td;
@synthesize yards;
@synthesize firstdowns;
@synthesize twopointconv;

@synthesize football_rushing_id;
@synthesize athlete_id;
@synthesize gameschedule_id;

- (id)init {
    if (self = [super init]) {
        attempts = [NSNumber numberWithInt:0];
        average = [NSNumber numberWithInt:0];
        fumbles = [NSNumber numberWithInt:0];
        fumbles_lost = [NSNumber numberWithInt:0];
        longest = [NSNumber numberWithInt:0];
        td = [NSNumber numberWithInt:0];
        yards = [NSNumber numberWithInt:0];
        firstdowns = [NSNumber numberWithInt:0];
        twopointconv = [NSNumber numberWithInt:0];
        
        athlete_id = @"";
        gameschedule_id = @"";
        football_rushing_id = @"";
        
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)rushingDictionary {
    if ((self = [super init]) && (rushingDictionary.count > 0)) {
        attempts = [rushingDictionary objectForKey:@"attempts"];
        average = [rushingDictionary objectForKey:@"average"];
        fumbles_lost = [rushingDictionary objectForKey:@"fumbles_lost"];
        fumbles = [rushingDictionary objectForKey:@"fumbles"];
        longest = [rushingDictionary objectForKey:@"longest"];
        td = [rushingDictionary objectForKey:@"td"];
        yards = [rushingDictionary objectForKey:@"yards"];
        firstdowns = [rushingDictionary objectForKey:@"firstdowns"];
        twopointconv = [rushingDictionary objectForKey:@"twopointconv"];
        
        athlete_id = [rushingDictionary objectForKey:@"athlete_id"];
        gameschedule_id = [rushingDictionary objectForKey:@"gameschedule_id"];
        football_rushing_id = [rushingDictionary objectForKey:@"football_rushing_id" ];

        return self;
    } else
        return nil;
}

@end
