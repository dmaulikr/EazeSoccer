//
//  EazesportzRetrieveVisitorRoster.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/26/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Sport.h"
#import "User.h"
#import "VisitingTeam.h"
#import "VisitorRoster.h"

@interface EazesportzRetrieveVisitorRoster : NSObject

@property(nonatomic,strong) NSMutableArray *visitorRoster;

- (void)retrieveVisitorRoster:(Sport *)sport VisitingTeam:(VisitingTeam *)visitingTeam User:(User *)user;

@end
