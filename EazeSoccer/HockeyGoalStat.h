//
//  HockeyGoalStat.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 8/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HockeyGoalStat : NSObject

@property (nonatomic, strong) NSString *hockey_stat_id;
@property (nonatomic, strong) NSString *hockey_goalstat_id;
@property (nonatomic, strong) NSString *athlete_id;

@property (nonatomic, strong) NSNumber *saves;
@property (nonatomic, strong) NSNumber *goals_allowed;
@property (nonatomic, strong) NSNumber *minutes_played;
@property (nonatomic, strong) NSNumber *period;

@property (nonatomic, assign) BOOL dirty;

- (id)initWithDictionary:(NSDictionary *)hockey_goalstat_dictionary;

- (NSDictionary *)getDictionary;

@end
