//
//  VisitingTeam.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/24/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Sport.h"
#import "User.h"
#import "VisitorRoster.h"

@interface VisitingTeam : NSObject

@property (nonatomic, strong) NSString *teamtitile;
@property (nonatomic, strong) NSString *mascot;
@property (nonatomic, strong) NSString *visiting_team_id;
@property (nonatomic, strong) NSString *httperror;

@property (nonatomic, strong) NSMutableArray *visitor_roster;

- (id)initWithDictionary:(NSDictionary *)visitingTeamDictionary;

- (void)save:(Sport *)sport User:(User *)user;

- (void)deleteTeam:(Sport *)sport User:(User *)user;

- (VisitorRoster *)findAthlete:(NSString *)rosterid;

- (void)refreshRoster;

@end
