//
//  EazessportzRetrieveDefenseGameStats.h
//  EazeSportz
//
//  Created by Gil on 1/19/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FootballDefenseStats.h"

@interface EazesportzRetrieveFootballDefenseGameStats : NSObject

@property(nonatomic, strong) NSMutableArray *defense;
@property(nonatomic, strong) FootballDefenseStats *totals;

- (void)retrieveFootballDefenseStats:(NSString *)sportid Team:(NSString *)teamid Game:(NSString *)gameid;

@end
