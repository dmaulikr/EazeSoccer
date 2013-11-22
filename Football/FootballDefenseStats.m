//
//  FootballDefenseStats.m
//  EazeSportz
//
//  Created by Gil on 11/20/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "FootballDefenseStats.h"

@implementation FootballDefenseStats

@synthesize tackles;
@synthesize fumbles_recovered;
@synthesize int_long;
@synthesize int_yards;
@synthesize interceptions;
@synthesize pass_defended;
@synthesize sacks;
@synthesize td;
@synthesize assists;
@synthesize safety;

@synthesize football_defense_id;
@synthesize athlete_id;
@synthesize gameschedule_id;

- (id)init {
    if (self = [super init]) {
        tackles = [NSNumber numberWithInt:0];
        fumbles_recovered = [NSNumber numberWithInt:0];
        int_long = [NSNumber numberWithInt:0];
        int_yards = [NSNumber numberWithInt:0];
        interceptions = [NSNumber numberWithInt:0];
        pass_defended = [NSNumber numberWithInt:0];
        sacks = [NSNumber numberWithInt:0];
        td = [NSNumber numberWithInt:0];
        assists = [NSNumber numberWithInt:0];
        safety = [NSNumber numberWithInt:0];
        
        athlete_id = @"";
        gameschedule_id = @"";
        football_defense_id = @"";
        
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)defenseDirectory {
    if ((self = [super init]) && (defenseDirectory.count > 0)) {
        tackles = [defenseDirectory objectForKey:@"tackles"];
        assists = [defenseDirectory objectForKey:@"assists"];
        interceptions = [defenseDirectory objectForKey:@"interceptions"];
        int_long = [defenseDirectory objectForKey:@"int_long"];
        int_yards = [defenseDirectory objectForKey:@"int_yards"];
        pass_defended = [defenseDirectory objectForKey:@"pass_defended"];
        sacks = [defenseDirectory objectForKey:@"sacks"];
        td = [defenseDirectory objectForKey:@"int_td"];
        safety = [defenseDirectory objectForKey:@"safety"];
        fumbles_recovered = [defenseDirectory objectForKey:@"fumbles_recovered"];
        
        athlete_id = [defenseDirectory objectForKey:@"athlete_id"];
        gameschedule_id = [defenseDirectory objectForKey:@"gameschedule_id"];
        football_defense_id = [defenseDirectory objectForKey:@"football_defense_id"];
        
        return self;
    } else
        return nil;
}

@end
