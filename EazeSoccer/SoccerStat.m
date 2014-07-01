//
//  SoccerStat.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "SoccerStat.h"

@implementation SoccerStat {
    int responseStatusCode;
    NSMutableData *theData;
}

@synthesize scoring_stats;
@synthesize goalstats;
@synthesize penalty_stats;
@synthesize player_stats;

@synthesize soccer_stat_id;
@synthesize soccer_game_id;
@synthesize athlete_id;
@synthesize visitor_roster_id;

@synthesize player_shots;
@synthesize player_cornerkicks;
@synthesize player_steals;
@synthesize player_fouls;
@synthesize player_assists;
@synthesize player_penalties;
@synthesize player_goals_allowed;
@synthesize player_minutes_played;

@synthesize soccer_scoring;
@synthesize soccer_player_stat;
@synthesize soccer_goalstat;
@synthesize soccer_penalty;

- (id)init {
    if (self = [super init]) {
        scoring_stats = [[NSMutableArray alloc] init];
        goalstats = [[NSMutableArray alloc] init];
        penalty_stats = [[NSMutableArray alloc] init];
        player_stats = [[NSMutableArray alloc] init];
        
        soccer_scoring = @"Scoring";
        soccer_penalty = @"Penalty";
        soccer_player_stat = @"Player Stat";
        soccer_goalstat = @"Goal Stat";
        
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)lacrosstats_dictionary {
    if ((self = [super init]) && (lacrosstats_dictionary.count > 0)) {
        athlete_id = [lacrosstats_dictionary objectForKey:@"athlete_id"];
        soccer_game_id = [lacrosstats_dictionary objectForKey:@"soccer_game_id"];
        visitor_roster_id = [lacrosstats_dictionary objectForKey:@"visitor_roster_id"];
        soccer_stat_id = [lacrosstats_dictionary objectForKey:@"soccer_stat_id"];
        
        scoring_stats = [[NSMutableArray alloc] init];
        NSArray *scoringArray = [lacrosstats_dictionary objectForKey:@"soccer_socrings"];
        
        for (int i = 0; i < scoringArray.count; i++) {
            NSDictionary *stats = [scoringArray objectAtIndex:i];
            SoccerScoring *scoring = [[SoccerScoring alloc] initWithDictionary:stats];
            [scoring_stats addObject:scoring];
        }
        
        goalstats = [[NSMutableArray alloc] init];
        NSArray *goalstatsArray = [lacrosstats_dictionary objectForKey:@"soccer_goalstats"];
        
        for (int i = 0; i < goalstatsArray.count; i++) {
            NSDictionary *stats = [goalstatsArray objectAtIndex:i];
            SoccerGoalstat *goalstat = [[SoccerGoalstat alloc] initWithDictionary:stats];
            [goalstats addObject:goalstat];
        }
        
        player_stats = [[NSMutableArray alloc] init];
        NSArray *playerstatsArray = [lacrosstats_dictionary objectForKey:@"soccer_playerstats"];
        
        for (int i = 0; i < playerstatsArray.count; i++) {
            NSDictionary *stats = [playerstatsArray objectAtIndex:i];
            SoccerPlayerStat *stat = [[SoccerPlayerStat alloc] initWithDictionary:stats];
            [player_stats addObject:stat];
        }
        
        penalty_stats = [[NSMutableArray alloc] init];
        NSArray *penaltystatsArray = [lacrosstats_dictionary objectForKey:@"soccer_penalties"];
        
        for (int i = 0; i < penaltystatsArray.count; i++) {
            NSDictionary *stats = [penaltystatsArray objectAtIndex:i];
            SoccerPenalty *stat = [[SoccerPenalty alloc] initWithDictionary:stats];
            [penalty_stats addObject:stat];
        }
        
        soccer_scoring = @"Scoring";
        soccer_penalty = @"Penalty";
        soccer_player_stat = @"Player Stat";
        soccer_goalstat = @"Goal Stat";
        
        return self;
    } else {
        return nil;
    }
}

@end
