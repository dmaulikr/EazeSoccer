//
//  LacrossPlayerStat.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/22/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Sport.h"
#import "Team.h"
#import "GameSchedule.h"
#import "User.h"

@interface LacrossPlayerStat : NSObject

@property (nonatomic, strong) NSMutableArray *shot;

@property (nonatomic, strong) NSNumber *face_off_won;
@property (nonatomic, strong) NSNumber *face_off_lost;
@property (nonatomic, strong) NSNumber *face_off_violation;

@property (nonatomic, strong) NSNumber *ground_ball;
@property (nonatomic, strong) NSNumber *interception;

@property (nonatomic, strong) NSNumber *turnover;
@property (nonatomic, strong) NSNumber *caused_turnover;

@property (nonatomic, strong) NSNumber *steals;

@property (nonatomic, strong) NSNumber *period;

@property (nonatomic, strong) NSString *lacross_player_stat_id;
@property (nonatomic, strong) NSString *lacrosstat_id;
@property (nonatomic, strong) NSString *athlete_id;
@property (nonatomic, strong) NSString *visitor_roster_id;

@property (nonatomic, strong) NSString *httperror;

- (id)initWithDictionary:(NSDictionary *)lacross_player_stat_dictionary;

- (void)save:(Sport *)sport Team:(Team *)team Game:(GameSchedule *)game User:(User *)user;

@end
