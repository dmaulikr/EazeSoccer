//
//  LacrossAllStats.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/30/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LacrossAllStats : NSObject

@property (nonatomic, strong) NSString *athlete_id;
@property (nonatomic, strong) NSString *visitor_roster_id;
@property (nonatomic, strong) NSNumber *goals;
@property (nonatomic, strong) NSNumber *assists;

@property (nonatomic, strong) NSNumber *shots;
@property (nonatomic, strong) NSNumber *face_off_won;
@property (nonatomic, strong) NSNumber *face_off_lost;
@property (nonatomic, strong) NSNumber *face_off_violation;
@property (nonatomic, strong) NSNumber *ground_ball;
@property (nonatomic, strong) NSNumber *interception;
@property (nonatomic, strong) NSNumber *turnover;
@property (nonatomic, strong) NSNumber *caused_turnover;
@property (nonatomic, strong) NSNumber *steals;

@property (nonatomic, strong) NSNumber *penalties;
@property (nonatomic, strong) NSString *penaltytime;

@property (nonatomic, strong) NSNumber *saves;
@property (nonatomic, strong) NSNumber *goals_allowed;
@property (nonatomic, strong) NSString *minutesplayed;

- (BOOL)hasGoalieStats;

@end
