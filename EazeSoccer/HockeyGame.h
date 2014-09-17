//
//  HockeyGame.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 8/20/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HockeyGame : NSObject

@property (nonatomic, strong) NSNumber *hockey_oppsog;
@property (nonatomic, strong) NSNumber *hockey_oppassists;
@property (nonatomic, strong) NSNumber *hockey_oppsaves;
// @property (nonatomic, strong) NSMutableArray *penalties;
@property (nonatomic, strong) NSNumber *home_time_outs_left;
@property (nonatomic, strong) NSNumber *visitor_time_outs_left;

@property (nonatomic, strong) NSNumber *hockey_home_score;
@property (nonatomic, strong) NSNumber *hockey_visitor_score;
@property (nonatomic, strong) NSNumber *hockey_home_shots;
@property (nonatomic, strong) NSNumber *hockey_visitor_shots;
@property (nonatomic, strong) NSNumber *hockey_home_saves;
@property (nonatomic, strong) NSNumber *hockey_visitor_saves;
@property (nonatomic, strong) NSNumber *hockey_home_penalties;
@property (nonatomic, strong) NSNumber *hockey_visitor_penalties;
@property (nonatomic, strong) NSNumber *hockey_home_goals_allowed;
@property (nonatomic, strong) NSNumber *hockey_visitor_goals_allowed;
@property (nonatomic, strong) NSNumber *hockey_home_minutes_played;
@property (nonatomic, strong) NSNumber *hockey_visitor_minutes_played;

@property (nonatomic, strong) NSNumber *hockey_game_home_score_period1;
@property (nonatomic, strong) NSNumber *hockey_game_home_score_period2;
@property (nonatomic, strong) NSNumber *hockey_game_home_score_period3;
@property (nonatomic, strong) NSNumber *hockey_game_home_score_overtime;

@property (nonatomic, strong) NSNumber *visitor_score_period1;
@property (nonatomic, strong) NSNumber *visitor_score_period2;
@property (nonatomic, strong) NSNumber *visitor_score_period3;
@property (nonatomic, strong) NSNumber *visitor_score_overtime;

@property (nonatomic, strong) NSNumber *home_penalty_one_number;
@property (nonatomic, strong) NSNumber *home_penalty_one_minutes;
@property (nonatomic, strong) NSNumber *home_penalty_one_seconds;
@property (nonatomic, strong) NSNumber *home_penalty_two_number;
@property (nonatomic, strong) NSNumber *home_penalty_two_minutes;
@property (nonatomic, strong) NSNumber *home_penalty_two_seconds;

@property (nonatomic, strong) NSNumber *visitor_penalty_one_number;
@property (nonatomic, strong) NSNumber *visitor_penalty_one_minutes;
@property (nonatomic, strong) NSNumber *visitor_penalty_one_seconds;
@property (nonatomic, strong) NSNumber *visitor_penalty_two_number;
@property (nonatomic, strong) NSNumber *visitor_penalty_two_minutes;
@property (nonatomic, strong) NSNumber *visitor_penalty_two_seconds;

@property (nonatomic, strong) NSMutableDictionary *hockey_penalties;

@property (nonatomic, strong) NSString *hockey_game_id;
@property (nonatomic, strong) NSString *gameschedule_id;

@property (nonatomic, strong) NSString *visiting_team_id;

- (id)initWithDictionary:(NSDictionary *)hockey_game_dictionary;

- (void)save;

- (NSNumber *)visitorScore;

@end
