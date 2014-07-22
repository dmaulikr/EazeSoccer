//
//  WaterPoloScoring.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/19/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaterPoloScoring : NSObject

@property (nonatomic, strong) NSString *waterpolo_scoring_id;
@property (nonatomic, strong) NSString *waterpolo_stat_id;
@property (nonatomic, strong) NSString *athlete_id;
@property (nonatomic, strong) NSString *visitor_roster_id;

@property (nonatomic, strong) NSNumber *period;
@property (nonatomic, strong) NSString *gametime;
@property (nonatomic, strong) NSString *assist;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *videos;
@property (nonatomic, assign) BOOL dirty;

- (id)initWithDictionary:(NSDictionary *)waterpolo_scoring_dictionary;

- (NSMutableDictionary *)getDictionary;

- (NSString *)getScoreLog;

@end
