//
//  SoccerStat.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SoccerGoalstat.h"
#import "SoccerPenalty.h"
#import "SoccerPlayerStat.h"
#import "SoccerScoring.h"
#import "GameSchedule.h"

@interface SoccerStat : NSObject

@property (nonatomic, strong) NSMutableArray *scoring_stats;
@property (nonatomic, strong) NSMutableArray *penalty_stats;
@property (nonatomic, strong) NSMutableArray *player_stats;
@property (nonatomic, strong) NSMutableArray *goalstats;

@property (nonatomic, strong) NSString *soccer_stat_id;
@property (nonatomic, strong) NSString *soccer_game_id;
@property (nonatomic, strong) NSString *athlete_id;
@property (nonatomic, strong) NSString *visitor_roster_id;

@property (nonatomic, strong) NSNumber *player_shots;
@property (nonatomic, strong) NSNumber *player_cornerkicks;
@property (nonatomic, strong) NSNumber *player_steals;
@property (nonatomic, strong) NSNumber *player_fouls;
@property (nonatomic, strong) NSNumber *player_assists;
@property (nonatomic, strong) NSNumber *player_penalties;
@property (nonatomic, strong) NSNumber *player_goals_allowed;
@property (nonatomic, strong) NSNumber *player_minutes_played;

@property (nonatomic, strong) NSString *httperror;

@property (nonatomic, strong, readonly) NSString *soccer_scoring;
@property (nonatomic, strong, readonly) NSString *soccer_player_stat;
@property (nonatomic, strong, readonly) NSString *soccer_goalstat;
@property (nonatomic, strong, readonly) NSString *soccer_penalty;

- (id)initWithDictionary:(NSDictionary *)soccer_stats_dictionary;

- (SoccerPlayerStat *)findPlayerStat:(NSNumber *)period;
- (SoccerGoalstat *)findGoalStat:(NSNumber *)period;

- (NSNumber *)getTotalShots;
- (NSNumber *)getTotalGoals;
- (NSNumber *)getTotalAssists;
- (NSNumber *)getTotalSteals;
- (NSNumber *)getTotalCornerKicks;

- (NSNumber *)getTotalGoalsAllowed;
- (NSNumber *)getTotalSaves;
- (NSNumber *)getTotalMinutes;

- (void)save:(NSString *)gameid StatType:(NSString *)stattype Period:(NSNumber *)period;

@end
