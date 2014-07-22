//
//  WaterPoloStat.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/19/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WaterPoloGoalstat.h"
#import "WaterPoloPlayerstat.h"
#import "WaterPoloScoring.h"
#import "WaterPoloPenalty.h"

@interface WaterPoloStat : NSObject

@property (nonatomic, strong) NSMutableArray *scoring_stats;
@property (nonatomic, strong) NSMutableArray *penalty_stats;
@property (nonatomic, strong) NSMutableArray *player_stats;
@property (nonatomic, strong) NSMutableArray *goalstats;

@property (nonatomic, strong) NSString *waterpolo_stat_id;
@property (nonatomic, strong) NSString *water_polo_game_id;
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

@property (nonatomic, strong, readonly) NSString *waterpolo_scoring;
@property (nonatomic, strong, readonly) NSString *waterpolo_player_stat;
@property (nonatomic, strong, readonly) NSString *waterpolo_goalstat;
@property (nonatomic, strong, readonly) NSString *waterpolo_penalty;

- (id)initWithDictionary:(NSDictionary *)waterpolo_stats_dictionary;

- (WaterPoloPlayerstat *)findPlayerStat:(NSNumber *)period;
- (WaterPoloGoalstat *)findGoalStat:(NSNumber *)period;
- (WaterPoloPenalty *)findPenaltyStat:(NSNumber *)period;
- (WaterPoloScoring *)findScoringStat:(NSNumber *)period;

- (NSNumber *)getTotalShots;
- (NSNumber *)getTotalGoals;
- (NSNumber *)getTotalAssists;
- (NSNumber *)getTotalSteals;
- (NSNumber *)getTotalFouls;

- (NSNumber *)getTotalGoalsAllowed;
- (NSNumber *)getTotalSaves;
- (NSNumber *)getTotalMinutes;

- (void)saveScoreStat:(NSString *)gameid Score:(WaterPoloScoring *)stat;
- (void)savePlayerStat:(NSString *)gameid PlayerStat:(WaterPoloPlayerstat *)stat;
- (void)saveGoalStat:(NSString *)gameid GoalStat:(WaterPoloGoalstat *)stat;
- (void)savePenaltyStat:(NSString *)gameid PenaltyStat:(WaterPoloPenalty *)stat;

- (void)deleteScoreStat:(NSString *)gameid Score:(WaterPoloScoring *)stat;
- (void)deletePlayerStat:(NSString *)gameid PlayerStat:(WaterPoloPlayerstat *)stat;
- (void)deleteGoalStat:(NSString *)gameid GoalStat:(WaterPoloGoalstat *)stat;
- (void)deletePenaltyStat:(NSString *)gameid PenaltyStat:(WaterPoloPenalty *)stat;

@end
