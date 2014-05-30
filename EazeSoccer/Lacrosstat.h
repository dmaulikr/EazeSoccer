//
//  Lacrosse.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LacrossGoalstat.h"
#import "LacrossPenalty.h"
#import "LacrossPlayerStat.h"
#import "LacrossScoring.h"

@interface Lacrosstat : NSObject

@property (nonatomic, strong) NSMutableArray *scoring_stats;
@property (nonatomic, strong) NSMutableArray *penalty_stats;
@property (nonatomic, strong) NSMutableArray *player_stats;
@property (nonatomic, strong) NSMutableArray *goalstats;

@property (nonatomic, strong) NSString *athlete_id;
@property (nonatomic, strong) NSString *lacross_game_id;
@property (nonatomic, strong) NSString *visitor_roster_id;
@property (nonatomic, strong) NSString *lacrosstat_id;

@property (nonatomic, strong) NSString *lacross_scoring_id;
@property (nonatomic, strong) NSString *lacross_penalties_id;
@property (nonatomic, strong) NSString *lacross_player_stats_id;
@property (nonatomic, strong) NSString *lacross_goalies_id;

@property (nonatomic, strong) NSString *httperror;

@property (nonatomic, strong, readonly) NSString *lacrosse_scoring;
@property (nonatomic, strong, readonly) NSString *lacrosse_player_stat;
@property (nonatomic, strong, readonly) NSString *lacrosse_goalstat;
@property (nonatomic, strong, readonly) NSString *lacrosse_penalty;

- (id)initWithDictionary:(NSDictionary *)lacross_stats_dictionary;

- (void)addScoringStat:(LacrossScoring *)stat;
- (void)addPenaltyStat:(LacrossPenalty *)stat;

- (BOOL)deleteStat:(const NSString *)statid Game:(NSString *)gameid Stat:(NSString *)lacross_stat;

@end
    
