//
//  EazesportzRetrieveVisitingTeams.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/24/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Sport.h"
#import "User.h"
#import "VisitingTeam.h"

@interface EazesportzRetrieveVisitingTeams : NSObject

@property(nonatomic,strong) NSMutableArray *visitingTeams;

- (void)retrieveVisitingTeams:(Sport *)sport User:(User *)user;

- (VisitingTeam *)findVisitingTeam:(NSString *)visiting_team_id;

@end
