//
//  Athlete.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 3/26/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasketballStats.h"
#import "Stats.h"
#import "FootballStats.h"
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

@property(nonatomic, strong) NSMutableArray *football_stats;
@property(nonatomic, strong) Stats *stats;

@property(nonatomic, strong) NSMutableArray *basketball_stats;

@property(nonatomic, strong) NSMutableArray *soccer_stats;

@property(nonatomic, strong) UIImage *thumbimage;
@property(nonatomic, strong) UIImage *tinyimage;
@property(nonatomic, strong) UIImage *mediumimage;


- (id)initWithDictionary:(NSDictionary *)athleteDictionary;

- (FootballStats *)findFootballGameStatEntries:(NSString *)gameid;

- (BasketballStats *)findBasketballGameStatEntries:(NSString *)gameid;
- (void)updateBasketballGameStats:(BasketballStats *)bballstats Game:(NSString *)gameid;

- (Soccer *)findSoccerGameStats:(NSString *)gameid;
- (void)updateSoccerGameStats:(Soccer *)soccerstat Game:(NSString *)gameid;
- (BOOL)isSoccerGoalie;

- (UIImage *)getImage:(NSString *)size;

@end
