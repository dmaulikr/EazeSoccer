//
//  FootballStats.h
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 5/21/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FootballStats : NSObject

@property(nonatomic, strong) NSString *football_stat;
@property(nonatomic, strong) NSString *gameschedule_id;
@property(nonatomic, strong) NSString *passing;
@property(nonatomic, strong) NSString *rushing;
@property(nonatomic, strong) NSString *receiving;
@property(nonatomic, strong) NSString *defense;
@property(nonatomic, strong) NSString *kickers;
@property(nonatomic, strong) NSString *returners;

@end
