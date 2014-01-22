//
//  EazesportzRetrievePassingGameStats.h
//  EazeSportz
//
//  Created by Gil on 1/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FootballPassingStat.h"

@interface EazesportzRetrievePassingGameStats : NSObject

@property(nonatomic, strong) NSMutableArray *passing;
@property(nonatomic, strong) FootballPassingStat *totals;

- (void)retrieveFootballPassingStats:(NSString *)sportid Team:(NSString *)teamid Game:(NSString *)gameid;

@end
