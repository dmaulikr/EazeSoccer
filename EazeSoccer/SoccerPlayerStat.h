//
//  SoccerPlayerStat.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EazesportzAppDelegate.h"

@interface SoccerPlayerStat : NSObject

@property (nonatomic, strong) NSString *soccer_playerstat_id;
@property (nonatomic, strong) NSString *soccer_stat_id;
@property (nonatomic, strong) NSString *athlete_id;
@property (nonatomic, strong) NSString *visitor_roster_id;

@property (nonatomic, strong) NSNumber *shots;
@property (nonatomic, strong) NSNumber *steals;
@property (nonatomic, strong) NSNumber *cornerkicks;
@property (nonatomic, strong) NSNumber *fouls;
@property (nonatomic, strong) NSNumber *period;

@property (nonatomic, assign) BOOL dirty;

- (id)initWithDictionary:(NSDictionary *)soccer_playerstat_dictionary;

- (NSDictionary *)getDictionary;

@end
