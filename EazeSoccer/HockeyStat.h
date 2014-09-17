//
//  HockeyStat.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 8/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HockeyPlayerStat.h"
#import "HockeyScoring.h"
#import "HockeyGoalStat.h"
#import "HockeyPenalty.h"

@interface HockeyStat : NSObject

@property (nonatomic, strong) NSMutableArray *scoring_stats;
@property (nonatomic, strong) NSMutableArray *penalty_stats;
@property (nonatomic, strong) NSMutableArray *player_stats;
@property (nonatomic, strong) NSMutableArray *goalstats;

@property (nonatomic, strong) NSString *hockey_stat_id;
@property (nonatomic, strong) NSString *hockey_game_id;
@property (nonatomic, strong) NSString *athlete_id;

@property (nonatomic, strong) NSNumber *hockey_oppsog;
@property (nonatomic, strong) NSNumber *hockey_oppsaves;
@property (nonatomic, strong) NSNumber *hockey_opppenalties;
@property (nonatomic, strong) NSNumber *hockey_oppassists;

@property (nonatomic, strong) NSMutableArray *penalties;
@property (nonatomic, strong) NSNumber *home_time_outs_left;
@property (nonatomic, strong) NSNumber *visitor_time_outs_left;

@property (nonatomic, strong) NSNumber *home_score;
@property (nonatomic, strong) NSNumber *home_score_period1;
@property (nonatomic, strong) NSNumber *home_score_period2;
@property (nonatomic, strong) NSNumber *home_score_period3;
@property (nonatomic, strong) NSNumber *home_score_periodOT;

@property (nonatomic, strong) NSNumber *visitor_score;
@property (nonatomic, strong) NSNumber *visitor_score_period1;
@property (nonatomic, strong) NSNumber *visitor_score_period2;
@property (nonatomic, strong) NSNumber *visitor_score_period3;
@property (nonatomic, strong) NSNumber *visitor_score_periodOT;

@property (nonatomic, strong) NSNumber *home_shots;
@property (nonatomic, strong) NSNumber *home_assists;
@property (nonatomic, strong) NSNumber *home_penalties;
@property (nonatomic, strong) NSNumber *home_goals_allowed;
@property (nonatomic, strong) NSNumber *home_saves;

@property (nonatomic, strong) NSString *httperror;

@property (nonatomic, strong, readonly) NSString *hockey_scoring;
@property (nonatomic, strong, readonly) NSString *hockey_player_stat;
@property (nonatomic, strong, readonly) NSString *hockey_goalstat;
@property (nonatomic, strong, readonly) NSString *hockey_penalty;

- (id)initWithDictionary:(NSDictionary *)hockey_stats_dictionary;

- (HockeyPlayerStat *)findPlayerStat:(NSNumber *)period;
- (HockeyGoalStat *)findGoalStat:(NSNumber *)period;
- (HockeyPenalty *)findPenaltyStat:(NSNumber *)period;
- (HockeyScoring *)findScoringStat:(NSNumber *)period;

- (NSNumber *)getTotalShots;
- (NSNumber *)getTotalGoals;
- (NSNumber *)getTotalPoints;
- (NSNumber *)getTotalAssists;

- (NSNumber *)getTotalPowerPlayGoals;
- (NSNumber *)getTotalPowerPlayAssists;
- (NSNumber *)getTotalShortHandedGoals;
- (NSNumber *)getTotalShortHandedAssists;
- (NSNumber *)gameWinningGoal;

- (NSNumber *)getTotalGoalsAllowed;
- (NSNumber *)getTotalSaves;
- (NSNumber *)getTotalMinutes;

- (NSNumber *)getTotalPenaltyMinutes;

- (NSNumber *)gettotalFaceOffsWon;
- (NSNumber *)getTotalFaceOffsLost;
- (NSNumber *)getTotalTimeOnIce;
- (NSNumber *)getTotalHits;
- (NSNumber *)getTotalBlockedShots;
- (NSNumber *)getTotalPlusMinues;

- (void)saveScoreStat:(NSString *)gameid Score:(HockeyScoring *)stat;
- (void)savePlayerStat:(NSString *)gameid PlayerStat:(HockeyPlayerStat *)stat;
- (void)saveGoalStat:(NSString *)gameid GoalStat:(HockeyGoalStat *)stat;
- (void)savePenaltyStat:(NSString *)gameid PenaltyStat:(HockeyPenalty *)stat;

- (void)deleteScoreStat:(NSString *)gameid Score:(HockeyScoring *)stat;
- (void)deletePlayerStat:(NSString *)gameid PlayerStat:(HockeyPlayerStat *)stat;
- (void)deleteGoalStat:(NSString *)gameid GoalStat:(HockeyGoalStat *)stat;
- (void)deletePenaltyStat:(NSString *)gameid PenaltyStat:(HockeyPenalty *)stat;

@end
