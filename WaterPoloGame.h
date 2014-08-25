//
//  WaterPoloGame.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/19/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaterPoloGame : NSObject

@property (nonatomic, strong) NSNumber *waterpolo_oppsog;
@property (nonatomic, strong) NSNumber *waterpolo_oppassists;
@property (nonatomic, strong) NSNumber *waterpolo_oppsaves;
@property (nonatomic, strong) NSNumber *waterpolo_oppfouls;
@property (nonatomic, strong) NSMutableArray *exclusions;
@property (nonatomic, strong) NSNumber *home_time_outs_left;
@property (nonatomic, strong) NSNumber *visitor_time_outs_left;

@property (nonatomic, strong) NSNumber *waterpolo_home_score;
@property (nonatomic, strong) NSNumber *waterpolo_visitor_score;
@property (nonatomic, strong) NSNumber *waterpolo_home_shots;
@property (nonatomic, strong) NSNumber *waterpolo_visitor_shots;
@property (nonatomic, strong) NSNumber *waterpolo_home_steals;
@property (nonatomic, strong) NSNumber *waterpolo_visitor_steals;
@property (nonatomic, strong) NSNumber *waterpolo_home_saves;
@property (nonatomic, strong) NSNumber *waterpolo_visitor_saves;
@property (nonatomic, strong) NSNumber *waterpolo_home_fouls;
@property (nonatomic, strong) NSNumber *waterpolo_visitor_fouls;
@property (nonatomic, strong) NSNumber *waterpolo_home_goals_allowed;
@property (nonatomic, strong) NSNumber *waterpolo_visitor_goals_allowed;
@property (nonatomic, strong) NSNumber *waterpolo_home_minutes_played;
@property (nonatomic, strong) NSNumber *waterpolo_visitor_minutes_played;

@property (nonatomic, strong) NSNumber *waterpolo_game_home_score_period1;
@property (nonatomic, strong) NSNumber *waterpolo_game_home_score_period2;
@property (nonatomic, strong) NSNumber *waterpolo_game_home_score_period3;
@property (nonatomic, strong) NSNumber *waterpolo_game_home_score_period4;
@property (nonatomic, strong) NSNumber *waterpolo_game_home_score_periodOT1;

@property (nonatomic, strong) NSNumber *waterpolo_game_visitor_score_period1;
@property (nonatomic, strong) NSNumber *waterpolo_game_visitor_score_period2;
@property (nonatomic, strong) NSNumber *waterpolo_game_visitor_score_period3;
@property (nonatomic, strong) NSNumber *waterpolo_game_visitor_score_period4;
@property (nonatomic, strong) NSNumber *waterpolo_game_visitor_score_periodOT1;

@property (nonatomic, strong) NSString *water_polo_game_id;
@property (nonatomic, strong) NSString *gameschedule_id;

@property (nonatomic, strong) NSString *visiting_team_id;

@property (nonatomic, strong) NSMutableArray *soccersubs;

- (id)initWithDictionary:(NSDictionary *)waterpolo_game_dictionary;

- (void)save;

- (NSNumber *)visitorScore;

@end
