//
//  EazesportzRetrieveFootballKickerStats.h
//  EazeSportz
//
//  Created by Gil on 1/19/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FootballPlaceKickerStats.h"
#import "FootballPunterStats.h"

@interface EazesportzRetrieveFootballKickerStats : NSObject

@property(nonatomic, strong) NSMutableArray *kicker;
@property(nonatomic, strong) FootballPlaceKickerStats *totals;
@property(nonatomic, strong) NSMutableArray *punter;
@property(nonatomic, strong) FootballPunterStats *puntertotals;

- (void)retrieveFootballKickerStats:(NSString *)sportid Team:(NSString *)teamid Game:(NSString *)gameid;

@end
