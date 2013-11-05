//
//  Soccer.h
//  EazeSportz
//
//  Created by Gil on 11/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Soccer : NSObject

@property(nonatomic, strong) NSString *soccerid;
@property(nonatomic, strong) NSString *gameschedule_id;
@property(nonatomic, strong) NSNumber *goals;
@property(nonatomic, strong) NSNumber *shotstaken;
@property(nonatomic, strong) NSNumber *assists;
@property(nonatomic, strong) NSNumber *steals;
@property(nonatomic, strong) NSNumber *goalsagainst;
@property(nonatomic, strong) NSNumber *goalssaved;
@property(nonatomic, strong) NSNumber *shutouts;
@property(nonatomic, strong) NSNumber *minutesplayed;

- (id)initWithDirectory:(NSDictionary *)soccerDirectory;

- (BOOL)goalieStats;

@end
