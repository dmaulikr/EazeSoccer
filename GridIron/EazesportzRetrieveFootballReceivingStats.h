//
//  EazesportzRetrieveFootballReceivingStats.h
//  EazeSportz
//
//  Created by Gil on 1/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FootballReceivingStat.h"

@interface EazesportzRetrieveFootballReceivingStats : NSObject

@property(nonatomic, strong) NSMutableArray *receiving;
@property(nonatomic, strong) FootballReceivingStat *totals;

- (void)retrieveFootballReceivingStats:(NSString *)sportid Team:(NSString *)teamid Game:(NSString *)gameid;

@end
