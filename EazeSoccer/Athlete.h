//
//  Athlete.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 3/26/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BasketballStats.h"

#import "FootballPassingStat.h"
#import "FootballDefenseStats.h"
#import "FootballKickerStats.h"
#import "FootballPlaceKickerStats.h"
#import "FootballPunterStats.h"
#import "FootballReceivingStat.h"
#import "FootballRushingStat.h"
#import "FootballReturnerStats.h"

#import "Soccer.h"

@interface Athlete : NSObject

@property(nonatomic, strong) NSNumber *number;
@property(nonatomic, strong) NSString *lastname;
@property(nonatomic, strong) NSString *middlename;
@property(nonatomic, strong) NSString *firstname;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *full_name;
@property(nonatomic, strong) NSString *logname;
@property(nonatomic, strong) NSString *height;
@property(nonatomic, strong) NSNumber *weight;
@property(nonatomic, strong) NSString *position;
@property(nonatomic, strong) NSString *year;
@property(nonatomic, strong) NSString *season;
@property(nonatomic, strong) NSString *bio;
@property(nonatomic, strong) NSString *athleteid;
@property(nonatomic, strong) NSString *teamid;
@property(nonatomic, strong) NSString *tinypic;
@property(nonatomic, strong) NSString *thumb;
@property(nonatomic, strong) NSString *mediumpic;
@property(nonatomic, strong) NSString *largepic;
@property(nonatomic, strong) NSString *teamname;
@property(nonatomic, strong) NSNumber *following;
@property(nonatomic, assign) BOOL hasphotos;
@property(nonatomic, assign) BOOL hasvideos;
@property(nonatomic, assign) BOOL processing;

@property(nonatomic, strong) NSMutableArray *football_passing_stats;
@property(nonatomic, strong) NSMutableArray *football_rushing_stats;
@property(nonatomic, strong) NSMutableArray *football_receiving_stats;
@property(nonatomic, strong) NSMutableArray *football_defense_stats;
@property(nonatomic, strong) NSMutableArray *football_place_kicker_stats;
@property(nonatomic, strong) NSMutableArray *football_returner_stats;
@property(nonatomic, strong) NSMutableArray *football_kicker_stats;
@property(nonatomic, strong) NSMutableArray *football_punter_stats;

@property(nonatomic, strong) NSMutableArray *basketball_stats;

@property(nonatomic, strong) NSMutableArray *soccer_stats;

@property(nonatomic, strong) UIImage *thumbimage;
@property(nonatomic, strong) UIImage *tinyimage;
@property(nonatomic, strong) UIImage *mediumimage;

@property(nonatomic, strong) NSString *httperror;

- (NSString *)numberLogname;

- (void)saveAthlete;
- (id)initWithDictionary:(NSDictionary *)athleteDictionary;
- (void)deleteAthlete;

- (FootballPassingStat *)findFootballPassingStat:(NSString *)gameid;
- (void)updateFootballPassingGameStats:(FootballPassingStat *)passingstat;
- (FootballRushingStat *)findFootballRushingStat:(NSString *)gameid;
- (void)updateFootballRushingGameStats:(FootballRushingStat *)rushingstat;
- (FootballReceivingStat *)findFootballReceivingStat:(NSString *)gameid;
- (void)updateFootballReceivingGameStats:(FootballReceivingStat *)receivingstat;
- (FootballDefenseStats *)findFootballDefenseStat:(NSString *)gameid;
- (void)updateFootballDefenseGameStats:(FootballDefenseStats *)defensestat;
- (FootballKickerStats *)findFootballKickerStat:(NSString *)gameid;
- (void)updateFootballKickerGameStats:(FootballKickerStats *)kickerstat;
- (FootballPlaceKickerStats *)findFootballPlaceKickerStat:(NSString *)gameid;
- (void)updateFootballPlaceKickerGameStats:(FootballPlaceKickerStats *)placekickerstat;
- (FootballPunterStats *)findFootballPunterStat:(NSString *)gameid;
- (void)updateFootballPunterGameStats:(FootballPunterStats *)punterstat;
- (FootballReturnerStats *)findFootballReturnerStat:(NSString *)gameid;
- (void)updateFootballReturnerGameStats:(FootballReturnerStats *)returnerstat;

- (BOOL)saveFootballGameStats:(NSString *)gameid;

- (BOOL)isQB:(NSString *)gameid;
- (BOOL)isRB:(NSString *)gameid;
- (BOOL)isWR:(NSString *)gameid;
- (BOOL)isOL:(NSString *)gameid;
- (BOOL)isDEF:(NSString *)gameid;
- (BOOL)isPK:(NSString *)gameid;
- (BOOL)isKicker:(NSString *)gameid;
- (BOOL)isPunter:(NSString *)gameid;
- (BOOL)isReturner:(NSString *)gameid;

- (NSString *)getBasketballStatGameId:(BasketballStats *)basketball_stat_id;
- (BasketballStats *)findBasketballGameStatEntries:(NSString *)gameid;
- (void)updateBasketballGameStats:(BasketballStats *)bballstats;
- (BOOL)saveBasketballGameStats:(NSString *)gameid;

- (BasketballStats *)basketballSeasonTotals;

- (Soccer *)findSoccerStats:(NSString *)statid;
- (Soccer *)findSoccerGameStats:(NSString *)gameid;
- (void)updateSoccerGameStats:(Soccer *)soccerstat;
- (BOOL)saveSoccerGameStats:(NSString *)gameid;
- (BOOL)isSoccerGoalie;

- (Soccer *)soccerSeasonTotals;

- (UIImage *)getImage:(NSString *)size;

@end
