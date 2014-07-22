//
//  WaterPoloPlayerstat.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/19/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaterPoloPlayerstat : NSObject

@property (nonatomic, strong) NSString *waterpolo_playerstat_id;
@property (nonatomic, strong) NSString *waterpolo_stat_id;
@property (nonatomic, strong) NSString *athlete_id;
@property (nonatomic, strong) NSString *visitor_roster_id;

@property (nonatomic, strong) NSNumber *shots;
@property (nonatomic, strong) NSNumber *steals;
@property (nonatomic, strong) NSNumber *fouls;
@property (nonatomic, strong) NSNumber *period;

@property (nonatomic, assign) BOOL dirty;

- (id)initWithDictionary:(NSDictionary *)waterpolo_playerstat_dictionary;

- (NSMutableDictionary *)getDictionary;

@end
