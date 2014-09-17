//
//  HockeyScoring.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 8/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HockeyScoring : NSObject

@property (nonatomic, strong) NSString *hockey_scoring_id;
@property (nonatomic, strong) NSString *hockey_stat_id;
@property (nonatomic, strong) NSString *athlete_id;

@property (nonatomic, strong) NSNumber *period;
@property (nonatomic, strong) NSString *gametime;
@property (nonatomic, strong) NSString *assist;
@property (nonatomic, strong) NSString *assist_type;
@property (nonatomic, strong) NSString *goaltype;
@property (nonatomic, assign) BOOL game_winning_goal;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *videos;
@property (nonatomic, assign) BOOL dirty;

- (id)initWithDictionary:(NSDictionary *)hockey_scoring_dictionary;

- (NSMutableDictionary *)getDictionary;

- (NSString *)getScoreLog;

@end
