//
//  SoccerScoring.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoccerScoring : NSObject

@property (nonatomic, strong) NSString *soccer_scoring_id;
@property (nonatomic, strong) NSString *soccer_stat_id;
@property (nonatomic, strong) NSString *athlete_id;
@property (nonatomic, strong) NSString *visitor_roster_id;

@property (nonatomic, strong) NSNumber *period;
@property (nonatomic, strong) NSString *gametime;
@property (nonatomic, strong) NSString *assist;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *videos;
@property (nonatomic, assign) BOOL dirty;

- (id)initWithDictionary:(NSDictionary *)soccer_scoring_dictionary;

- (NSMutableDictionary *)getDictionary;

- (NSString *)getScoreLog;

@end
