//
//  HockeyPenalty.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 8/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HockeyPenalty : NSObject

@property (nonatomic, strong) NSString *hockey_penalty_id;
@property (nonatomic, strong) NSString *hockey_stat_id;
@property (nonatomic, strong) NSString *athlete_id;

@property (nonatomic, strong) NSString *infraction;
@property (nonatomic, strong) NSString *gametime;
@property (nonatomic, strong) NSString *penaltytime;
@property (nonatomic, strong) NSNumber *period;

@property (nonatomic, assign) BOOL dirty;

- (id)initWithDictionary:(NSDictionary *)hockey_penalty_dictionary;

- (NSDictionary *)getDictionary;

@end
