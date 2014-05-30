//
//  VisitorRoster.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/23/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Sport.h"
#import "User.h"
#import "GameSchedule.h"
#import "Lacrosstat.h"

@interface VisitorRoster : NSObject

@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) NSString *lastname;
@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSString *numberlogname;
@property (nonatomic, strong) NSString *logname;

@property (nonatomic, strong) NSString *lacrosstat_id;
@property (nonatomic, strong) NSString *visitor_roster_id;
@property (nonatomic, strong) NSString *visiting_team_id;

- (id)initWithDictionary:(NSDictionary *)visitorRosterDictionary;

- (void)save:(Sport *)sport User:(User *)user;

- (void)deleteVisitorRoster:(Sport *)sport User:(User *)user;

- (Lacrosstat *)findLacrossStat:(GameSchedule *)game;

@end
