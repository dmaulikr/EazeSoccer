//
//  SoccerGame.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/26/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "SoccerGame.h"

@implementation SoccerGame

@synthesize soccer_game_id;
@synthesize gameschedule_id;

@synthesize socceroppsog;
@synthesize socceroppck;
@synthesize socceroppsaves;
@synthesize socceroppfouls;

@synthesize homefouls;
@synthesize visitorfouls;
@synthesize homeoffsides;
@synthesize visitoroffsides;
@synthesize homeplayers;
@synthesize visitorplayers;

@synthesize soccergame_home_score;
@synthesize soccergame_visitor_score;
@synthesize soccergame_home_score_period1;
@synthesize soccergame_home_score_period2;
@synthesize soccergame_home_score_periodOT1;
@synthesize soccergame_home_score_periodOT2;
@synthesize soccergame_visitor_score_period1;
@synthesize soccergame_visitor_score_period2;
@synthesize soccergame_visitor_score_periodOT1;
@synthesize soccergame_visitor_score_periodOT2;
@synthesize soccer_home_shots;
@synthesize soccer_visitor_shots;
@synthesize soccergame_homecornerkicks;
@synthesize soccergame_visitorcornerkicks;
@synthesize soccergame_homesaves;
@synthesize soccergame_visitorsaves;

@synthesize visiting_team_id;

- (id)initWithDictionary:(NSDictionary *)soccer_game_dictionary; {
    if (self == [super init]) {
        soccer_game_id = [soccer_game_dictionary objectForKey:@"soccer_game_id"];
        gameschedule_id = [soccer_game_dictionary objectForKey:@"gameschedule_id"];
        socceroppsog = [soccer_game_dictionary objectForKey:@"socceroppsog"];
        socceroppck = [soccer_game_dictionary objectForKey:@"socceroppck"];
        socceroppsaves = [soccer_game_dictionary objectForKey:@"socceroppsaves"];
        socceroppfouls = [soccer_game_dictionary objectForKey:@"socceroppfouls"];
        
        soccergame_home_score = [soccer_game_dictionary objectForKey:@"soccergame_home_score"];
        soccergame_visitor_score = [soccer_game_dictionary objectForKey:@"soccergame_visitor_score"];
        soccergame_home_score_period1 = [soccer_game_dictionary objectForKey:@"soccergame_home_score_period1"];
        soccergame_home_score_period2 = [soccer_game_dictionary objectForKey:@"soccergame_home_score_period2"];
        soccergame_home_score_periodOT1 = [soccer_game_dictionary objectForKey:@"soccergame_home_score_periodOT1"];
        soccergame_home_score_periodOT2 = [soccer_game_dictionary objectForKey:@"soccergame_home_score_periodOT2"];
        soccergame_visitor_score_period1 = [soccer_game_dictionary objectForKey:@"soccergame_visitor_score_period1"];
        soccergame_visitor_score_period2 = [soccer_game_dictionary objectForKey:@"soccergame_visitor_score_period2"];
        soccergame_visitor_score_periodOT1 = [soccer_game_dictionary objectForKey:@"soccergame_visitor_score_periodOT1"];
        soccergame_visitor_score_periodOT2 = [soccer_game_dictionary objectForKey:@"soccergame_visitor_score_periodOT2"];
        soccer_home_shots = [soccer_game_dictionary objectForKey:@"soccer_home_shots"];
        soccer_visitor_shots = [soccer_game_dictionary objectForKey:@"soccer_visitor_shots"];
        soccergame_homecornerkicks = [soccer_game_dictionary objectForKey:@"soccergame_homecornerkicks"];
        soccergame_visitorcornerkicks = [soccer_game_dictionary objectForKey:@"soccergame_visitorcornerkicks"];
        soccergame_homesaves = [soccer_game_dictionary objectForKey:@"soccergame_homesaves"];
        soccergame_visitorsaves = [soccer_game_dictionary objectForKey:@"soccergame_visitorsaves"];
        
        homefouls = [soccer_game_dictionary objectForKey:@"homefouls"];
        visitorfouls = [soccer_game_dictionary objectForKey:@"visitorfouls"];
        homeoffsides = [soccer_game_dictionary objectForKey:@"homeoffsides"];
        visitoroffsides = [soccer_game_dictionary objectForKey:@"visitoroffsides"];
        homeplayers = [soccer_game_dictionary objectForKey:@"homeplayers"];
        visitorplayers = [soccer_game_dictionary objectForKey:@"visitorplayers"];
        
        return self;
    } else
        return nil;
}

@end
