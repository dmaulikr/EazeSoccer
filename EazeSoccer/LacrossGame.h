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

@property (nonatomic, strong) NSMutableArray *home_1stperiod_timeouts;
@property (nonatomic, strong) NSMutableArray *home_2ndperiod_timeouts;
@property (nonatomic, strong) NSMutableArray *visitor_1stperiod_timeouts;
@property (nonatomic, strong) NSMutableArray *visitor_2ndperiod_timeouts;

@property (nonatomic, strong) NSString *gameschedule_id;
@property (nonatomic, strong) NSString *lacross_game_id;

@property (nonatomic, strong) NSString *visiting_team_id;

- (id)initWithDictionary:(NSDictionary *)lacross_game_dictionary;

- (BOOL)saveHomeTimeouts;
- (BOOL)saveVisitorTimeouts;
- (BOOL)saveExtraManFails:(NSString *)home;

@end
