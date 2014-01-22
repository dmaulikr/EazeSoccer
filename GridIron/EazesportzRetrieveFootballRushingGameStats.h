//
//  EazesportzRetrieveFootballRushingGameStats.h
//  EazeSportz
//
//  Created by Gil on 1/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FootballRushingStat.h"

@interface EazesportzRetrieveFootballRushingGameStats : NSObject

@property(nonatomic, strong) NSMutableArray *rushing;
@property(nonatomic, strong) FootballRushingStat *totals;

- (void)retrieveFootballRushingStats:(NSString *)sportid Team:(NSString *)teamid Game:(NSString *)gameid;

@end
