//
//  HockeyPlayerStat.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 8/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HockeyPlayerStat : NSObject

@property (nonatomic, strong) NSString *hockey_playerstat_id;
@property (nonatomic, strong) NSString *hockey_stat_id;
@property (nonatomic, strong) NSString *athlete_id;

@property (nonatomic, strong) NSNumber *shots;
@property (nonatomic, strong) NSNumber *period;

@property (nonatomic, assign) BOOL dirty;

- (id)initWithDictionary:(NSDictionary *)hockey_playerstat_dictionary;

- (NSMutableDictionary *)getDictionary;

@end
