//
//  EazesportzRetrieveFootballReturnerGameStats.h
//  EazeSportz
//
//  Created by Gil on 1/19/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FootballReturnerStats.h"

@interface EazesportzRetrieveFootballReturnerGameStats : NSObject

@property(nonatomic, strong) NSMutableArray *returner;
@property(nonatomic, strong) FootballReturnerStats *totals;

- (void)retrieveFootballReturnerStats:(NSString *)sportid Team:(NSString *)teamid Game:(NSString *)gameid;

@end
