//
//  EazesportzRetrieveFootballStatTotals.h
//  EazeSportz
//
//  Created by Gil on 1/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FootballStatTotals.h"

@interface EazesportzRetrieveFootballStatTotals : NSObject

@property(nonatomic, strong) FootballStatTotals *totals;

- (void)retrieveFootballStats:(NSString *)sportid Team:(NSString *)teamid Game:(NSString *)gameid;

@end
