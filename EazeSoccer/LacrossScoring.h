//
//  LacrossScoring.h
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

@interface LacrossScoring : NSObject

@property (nonatomic, strong, readonly) NSDictionary *scorecodes;

@property (nonatomic, strong) NSString *gametime;
@property (nonatomic, strong) NSString *scorecode;
@property (nonatomic, strong) NSString *assist;
@property (nonatomic, strong) NSNumber *period;

@property (nonatomic, strong) NSString *lacross_scoring_id;
@property (nonatomic, strong) NSString *lacrosstat_id;
@property (nonatomic, strong) NSString *athlete_id;
@property (nonatomic, strong) NSString *visitor_roster_id;

@property (nonatomic, strong) NSString *httperror;

- (id)initWithDictionary:(NSDictionary *)lacross_scoring_dictionary; 

- (void)save:(Sport *)sport Team:(Team *)team Gameschedule:(GameSchedule *)game User:(User *)user;

- (BOOL)isExtraManScore;

@end
