//
//  PassingStats.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 3/28/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stats : NSObject

@property(nonatomic, strong) NSString *gamename;
@property(nonatomic, strong) NSString *gameid;
@property(nonatomic, strong) NSString *playername;
@property(nonatomic, strong) NSString *playerid;
@property(nonatomic, strong) NSString *statid;

@property(nonatomic, strong) NSNumber *pass_attempts;
@property(nonatomic, strong) NSNumber *completions;
@property(nonatomic, strong) NSNumber *comp_percentage;
@property(nonatomic, strong) NSNumber *interceptions;
@property(nonatomic, strong) NSNumber *sacks;
@property(nonatomic, strong) NSNumber *pass_tds;
@property(nonatomic, strong) NSNumber *pass_yards;
@property(nonatomic, strong) NSNumber *pass_yards_lost;
@property(nonatomic, strong) NSNumber *pass_firstdowns;
@property(nonatomic, strong) NSNumber *pass_twopointconv;

@property(nonatomic, strong) NSNumber *rush_attempts;
@property(nonatomic, strong) NSNumber *rush_yards;
@property(nonatomic, strong) NSNumber *rush_average;
@property(nonatomic, strong) NSNumber *rush_tds;
@property(nonatomic, strong) NSNumber *rush_longest;
@property(nonatomic, strong) NSNumber *rush_fumbles;
@property(nonatomic, strong) NSNumber *rush_fumbles_lost;
@property(nonatomic, strong) NSNumber *rush_firstdowns;
@property(nonatomic, strong) NSNumber *rush_twopointconv;

@property(nonatomic, strong) NSNumber *rec_receptions;
@property(nonatomic, strong) NSNumber *rec_yards;
@property(nonatomic, strong) NSNumber *rec_tds;
@property(nonatomic, strong) NSNumber *rec_longest;
@property(nonatomic, strong) NSNumber *rec_average;
@property(nonatomic, strong) NSNumber *rec_fumbles;
@property(nonatomic, strong) NSNumber *rec_fumbles_lost;
@property(nonatomic, strong) NSNumber *rec_twopointconv;

@property(nonatomic, strong) NSNumber *tackles;
@property(nonatomic, strong) NSNumber *tackles_assists;
@property(nonatomic, strong) NSNumber *def_sacks;
@property(nonatomic, strong) NSNumber *def_pass_defended;
@property(nonatomic, strong) NSNumber *def_interceptions;
@property(nonatomic, strong) NSNumber *def_int_yards;
@property(nonatomic, strong) NSNumber *def_int_long;
@property(nonatomic, strong) NSNumber *def_td;
@property(nonatomic, strong) NSNumber *def_fumbles_recovered;
@property(nonatomic, strong) NSNumber *safety;

@property(nonatomic, strong) NSNumber *fgattempts;
@property(nonatomic, strong) NSNumber *fgmade;
@property(nonatomic, strong) NSNumber *fgblocked;
@property(nonatomic, strong) NSNumber *fglong;
@property(nonatomic, strong) NSNumber *xpattempts;
@property(nonatomic, strong) NSNumber *xpmade;
@property(nonatomic, strong) NSNumber *xpmissed;
@property(nonatomic, strong) NSNumber *xpblocked;

@property(nonatomic, strong) NSNumber *koreturn;
@property(nonatomic, strong) NSNumber *kotd;
@property(nonatomic, strong) NSNumber *koyards;
@property(nonatomic, strong) NSNumber *kolong;

@property(nonatomic, strong) NSNumber *koattempts;
@property(nonatomic, strong) NSNumber *kotouchbacks;
@property(nonatomic, strong) NSNumber *koreturned;

@property(nonatomic, strong) NSNumber *punt_return;
@property(nonatomic, strong) NSNumber *punt_returnyards;
@property(nonatomic, strong) NSNumber *punt_returntd;
@property(nonatomic, strong) NSNumber *punt_returnlong;

@property(nonatomic, strong) NSNumber *punts;
@property(nonatomic, strong) NSNumber *punts_blocked;
@property(nonatomic, strong) NSNumber *punts_long;
@property(nonatomic, strong) NSNumber *punts_yards;

- (NSDictionary *)getRushingStats;

- (Stats *)parseStats:(NSDictionary *)gamestats;

- (Stats *)parseStatsTotals:(NSDictionary *)stattotals;

- (BOOL)hasPassing;
- (BOOL)hasRushing;
- (BOOL)hasReceiving;
- (BOOL)hasDefense;
- (BOOL)hasPlaceKicker;
- (BOOL)hasKickoff;
- (BOOL)hasPunter;
- (BOOL)hasKickoffReturner;
- (BOOL)hasPuntReturner;

@end
