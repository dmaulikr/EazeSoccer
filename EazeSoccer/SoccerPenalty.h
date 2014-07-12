//
//  SoccerPenalty.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoccerPenalty : NSObject

@property (nonatomic, strong) NSString *soccer_penalty_id;
@property (nonatomic, strong) NSString *soccer_stat_id;
@property (nonatomic, strong) NSString *athlete_id;
@property (nonatomic, strong) NSString *visitor_roster_id;

@property (nonatomic, strong) NSString *infraction;
@property (nonatomic, strong) NSString *card;
@property (nonatomic, strong) NSString *gametime;
@property (nonatomic, strong) NSNumber *period;

@property (nonatomic, assign) BOOL dirty;

- (id)initWithDictionary:(NSDictionary *)soccer_penalty_dictionary;

@end
