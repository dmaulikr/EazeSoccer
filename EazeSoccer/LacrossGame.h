//
//  LacrossGame.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LacrossGame : NSObject

@property (nonatomic, strong) NSMutableArray *clears;
@property (nonatomic, strong) NSMutableArray *failedclears;
@property (nonatomic, strong) NSMutableArray *visitor_clears;
@property (nonatomic, strong) NSMutableArray *visitor_badclears;

@property (nonatomic, strong) NSMutableArray *extraman_fail;
@property (nonatomic, strong) NSMutableArray *visitor_extraman_fail;

@property (nonatomic, strong) NSNumber *free_position_sog;

@property (nonatomic, strong) NSDictionary *homepenaltybox;
@property (nonatomic, strong) NSDictionary *visitorpenaltybox;

@property (nonatomic, strong) NSNumber *home_penaltyone_number;
@property (nonatomic, strong) NSNumber *home_penaltyone_minutes;
@property (nonatomic, strong) NSNumber *home_penaltyone_seconds;
@property (nonatomic, strong) NSNumber *home_penaltytwo_number;
@property (nonatomic, strong) NSNumber *home_penaltytwo_minutes;
@property (nonatomic, strong) NSNumber *home_penaltytwo_seconds;
@property (nonatomic, strong) NSNumber *visitor_penaltyone_number;
@property (nonatomic, strong) NSNumber *visitor_penaltyone_minutes;
@property (nonatomic, strong) NSNumber *visitor_penaltyone_seconds;
@property (nonatomic, strong) NSNumber *visitor_penaltytwo_number;
@property (nonatomic, strong) NSNumber *visitor_penaltytwo_minutes;
@property (nonatomic, strong) NSNumber *visitor_penaltytwo_seconds;

@property (nonatomic, strong) NSMutableArray *home_1stperiod_timeouts;
@property (nonatomic, strong) NSMutableArray *home_2ndperiod_timeouts;
@property (nonatomic, strong) NSMutableArray *visitor_1stperiod_timeouts;
@property (nonatomic, strong) NSMutableArray *visitor_2ndperiod_timeouts;

@property (nonatomic, strong) NSNumber *visitor_score_period1;
@property (nonatomic, strong) NSNumber *visitor_score_period2;
@property (nonatomic, strong) NSNumber *visitor_score_period3;
@property (nonatomic, strong) NSNumber *visitor_score_period4;
@property (nonatomic, strong) NSNumber *visitor_score_periodOT1;

@property (nonatomic, strong) NSString *gameschedule_id;
@property (nonatomic, strong) NSString *lacross_game_id;

@property (nonatomic, strong) NSString *visiting_team_id;

- (id)initWithDictionary:(NSDictionary *)lacross_game_dictionary;

- (BOOL)save;
- (BOOL)saveHomeTimeouts;
- (BOOL)saveVisitorTimeouts;
- (BOOL)saveExtraManFails:(NSString *)home;
- (BOOL)saveClears:(NSString *)home;

- (NSArray *)getLacrosseScores:(BOOL)home;
- (NSArray *)getLacrossePenalties:(BOOL)home;
- (NSString *)findScoreLog:(NSString *)scorelogid;
- (NSNumber *)computeVisitorTotal;

@end
