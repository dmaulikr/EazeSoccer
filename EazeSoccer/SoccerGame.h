//
//  SoccerGame.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/26/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoccerSubs.h"

@interface SoccerGame : NSObject

@property (nonatomic, strong) NSString *soccer_game_id;
@property (nonatomic, strong) NSString *gameschedule_id;

@property (nonatomic, strong) NSNumber *socceroppsog;
@property (nonatomic, strong) NSNumber *socceroppck;
@property (nonatomic, strong) NSNumber *socceroppsaves;
@property (nonatomic, strong) NSNumber *socceroppfouls;

@property (nonatomic, strong) NSNumber *homefouls;
@property (nonatomic, strong) NSNumber *visitorfouls;
@property (nonatomic, strong) NSNumber *homeoffsides;
@property (nonatomic, strong) NSNumber *visitoroffsides;
@property (nonatomic, strong) NSArray *homeplayers;
@property (nonatomic, strong) NSMutableArray *visitorplayers;

@property (nonatomic, strong) NSNumber *soccergame_home_score;
@property (nonatomic, strong) NSNumber *soccergame_visitor_score;
@property (nonatomic, strong) NSNumber *soccergame_home_score_period1;
@property (nonatomic, strong) NSNumber *soccergame_home_score_period2;
@property (nonatomic, strong) NSNumber *soccergame_home_score_periodOT1;
@property (nonatomic, strong) NSNumber *soccergame_home_score_periodOT2;
@property (nonatomic, strong) NSNumber *soccergame_visitor_score_period1;
@property (nonatomic, strong) NSNumber *soccergame_visitor_score_period2;
@property (nonatomic, strong) NSNumber *soccergame_visitor_score_periodOT1;
@property (nonatomic, strong) NSNumber *soccergame_visitor_score_periodOT2;
@property (nonatomic, strong) NSNumber *soccer_home_shots;
@property (nonatomic, strong) NSNumber *soccer_visitor_shots;
@property (nonatomic, strong) NSNumber *soccergame_homecornerkicks;
@property (nonatomic, strong) NSNumber *soccergame_visitorcornerkicks;
@property (nonatomic, strong) NSNumber *soccergame_homesaves;
@property (nonatomic, strong) NSNumber *soccergame_visitorsaves;

@property (nonatomic, strong) NSString *visiting_team_id;

@property (nonatomic, strong) NSMutableArray *soccersubs;

- (id)initWithDictionary:(NSDictionary *)soccer_game_dictionary;

- (void)saveSub:(SoccerSubs *)soccersub;
- (void)saveSoccerGame;

- (void)deleteSub:(SoccerSubs *)soccersub;

- (NSArray *)getSoccerScores:(BOOL)home;

- (NSNumber *)visitorScore;

@end