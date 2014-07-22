//
//  WaterPoloPenalty.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/19/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaterPoloPenalty : NSObject

@property (nonatomic, strong) NSString *waterpolo_penalty_id;
@property (nonatomic, strong) NSString *waterpolo_stat_id;
@property (nonatomic, strong) NSString *athlete_id;
@property (nonatomic, strong) NSString *visitor_roster_id;

@property (nonatomic, strong) NSString *infraction;
@property (nonatomic, strong) NSString *card;
@property (nonatomic, strong) NSString *gametime;
@property (nonatomic, strong) NSNumber *period;

@property (nonatomic, assign) BOOL dirty;

- (id)initWithDictionary:(NSDictionary *)waterpolo_penalty_dictionary;

- (NSDictionary *)getDictionary;

@end
