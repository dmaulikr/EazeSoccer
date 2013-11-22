//
//  FootballPassingStat.m
//  EazeSportz
//
//  Created by Gil on 11/20/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "FootballPassingStat.h"

@implementation FootballPassingStat

@synthesize attempts;
@synthesize completions;
@synthesize comp_percentage;
@synthesize interceptions;
@synthesize sacks;
@synthesize td;
@synthesize yards;
@synthesize yards_lost;
@synthesize firstdowns;
@synthesize twopointconv;

@synthesize football_passing_id;
@synthesize athlete_id;
@synthesize gameschedule_id;

- (id)init {
    if (self = [super init]) {
        attempts = [NSNumber numberWithInt:0];
        completions = [NSNumber numberWithInt:0];
        comp_percentage = [NSNumber numberWithInt:0];
        interceptions = [NSNumber numberWithInt:0];
        sacks = [NSNumber numberWithInt:0];
        td = [NSNumber numberWithInt:0];
        yards = [NSNumber numberWithInt:0];
        yards_lost = [NSNumber numberWithInt:0];
        firstdowns = [NSNumber numberWithInt:0];
        twopointconv = [NSNumber numberWithInt:0];
        
        football_passing_id = @"";
        athlete_id = @"";
        gameschedule_id = @"";
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)passingDictionary {
    if ((self = [super init]) && (passingDictionary.count > 0)) {
        attempts = [passingDictionary objectForKey:@"attempts"];
        completions = [passingDictionary objectForKey:@"completions"];
        comp_percentage = [passingDictionary objectForKey:@"comp_percentage"];
        interceptions = [passingDictionary objectForKey:@"interceptions"];
        sacks = [passingDictionary objectForKey:@"sacks"];
        td = [passingDictionary objectForKey:@"td"];
        yards = [passingDictionary objectForKey:@"yards"];
        yards_lost = [passingDictionary objectForKey:@"yards_lost"];
        firstdowns = [passingDictionary objectForKey:@"firstdowns"];
        twopointconv = [passingDictionary objectForKey:@"twopointconv"];
        
        athlete_id = [passingDictionary objectForKey:@"athlete_id"];
        gameschedule_id = [passingDictionary objectForKey:@"gameschedule_id"];
        football_passing_id = [passingDictionary objectForKey:@"football_passing_id"];
        
        return self;
    } else
        return nil;

}

@end
