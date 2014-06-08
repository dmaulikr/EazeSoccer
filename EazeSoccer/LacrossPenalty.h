//
//  LacrossPenalty.h
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

@interface LacrossPenalty : NSObject

@property (nonatomic, strong) NSString *infraction;
@property (nonatomic, strong) NSString *gametime;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *period;

@property (nonatomic, strong) NSString *lacross_penalty_id;
@property (nonatomic, strong) NSString *lacrosstat_id;
@property (nonatomic, strong) NSString *athlete_id;
@property (nonatomic, strong) NSString *visitor_roster_id;

@property (nonatomic, strong) NSString *httperror;

@property (nonatomic, assign) BOOL dirty;

- (id)initWithDictionary:(NSDictionary *)lacross_penalty_dictionary;

- (void)save:(Sport *)sport Team:(Team *)team Gameschedule:(GameSchedule *)game User:(User *)user;

@end
