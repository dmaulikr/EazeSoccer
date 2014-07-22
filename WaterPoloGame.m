//
//  WaterPoloGame.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/19/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "WaterPoloGame.h"

@implementation WaterPoloGame

@synthesize waterpolo_oppsog;
@synthesize waterpolo_oppassists;
@synthesize waterpolo_oppsaves;
@synthesize waterpolo_oppfouls;
@synthesize home_exclusions;
@synthesize visitor_exclusions;
@synthesize home_time_outs_left;
@synthesize visitor_time_outs_left;

@synthesize waterpolo_home_score;
@synthesize waterpolo_visitor_score;
@synthesize waterpolo_home_shots;
@synthesize waterpolo_visitor_shots;
@synthesize waterpolo_home_steals;
@synthesize waterpolo_visitor_steals;
@synthesize waterpolo_home_saves;
@synthesize waterpolo_visitor_saves;
@synthesize waterpolo_home_fouls;
@synthesize waterpolo_visitor_fouls;
@synthesize waterpolo_home_goals_allowed;
@synthesize waterpolo_visitor_goals_allowed;
@synthesize waterpolo_home_minutes_played;
@synthesize waterpolo_visitor_minutes_played;

@synthesize waterpolo_game_home_score_period1;
@synthesize waterpolo_game_home_score_period2;
@synthesize waterpolo_game_home_score_period3;
@synthesize waterpolo_game_home_score_period4;
@synthesize waterpolo_game_visitor_score_period1;
@synthesize waterpolo_game_visitor_score_period2;
@synthesize waterpolo_game_visitor_score_period3;
@synthesize waterpolo_game_visitor_score_period4;

@synthesize water_polo_game_id;
@synthesize gameschedule_id;

@synthesize visiting_team_id;

- (id)initWithDictionary:(NSDictionary *)waterpolo_game_dictionary ; {
    if (self == [super init]) {
        water_polo_game_id = [waterpolo_game_dictionary  objectForKey:@"water_polo_game_id"];
        gameschedule_id = [waterpolo_game_dictionary  objectForKey:@"gameschedule_id"];
        waterpolo_oppsog = [waterpolo_game_dictionary  objectForKey:@"waterpolo_oppsog"];
        waterpolo_oppsaves = [waterpolo_game_dictionary  objectForKey:@"waterpolo_oppsaves"];
        waterpolo_oppfouls = [waterpolo_game_dictionary  objectForKey:@"waterpolo_oppfouls"];
        waterpolo_oppassists = [waterpolo_game_dictionary  objectForKey:@"waterpolo_oppassists"];
        home_exclusions = [waterpolo_game_dictionary objectForKey:@"home_exclusions"];
        visitor_exclusions = [waterpolo_game_dictionary objectForKey:@"waterpolo_game_dictionary"];
        home_time_outs_left = [waterpolo_game_dictionary objectForKey:@"home_time_outs_left"];
        visitor_time_outs_left = [waterpolo_game_dictionary objectForKey:@"visitor_time_outs_left"];
        
        waterpolo_home_score = [waterpolo_game_dictionary  objectForKey:@"waterpolo_home_score"];
        waterpolo_visitor_score = [waterpolo_game_dictionary  objectForKey:@"waterpolo_visitor_score"];
        waterpolo_game_home_score_period1 = [waterpolo_game_dictionary  objectForKey:@"waterpolo_game_home_score_period1"];
        waterpolo_game_home_score_period2 = [waterpolo_game_dictionary  objectForKey:@"waterpolo_game_home_score_period2"];
        waterpolo_game_home_score_period3 = [waterpolo_game_dictionary  objectForKey:@"waterpolo_game_home_score_period3"];
        waterpolo_game_home_score_period4 = [waterpolo_game_dictionary  objectForKey:@"waterpolo_game_home_score_period4"];
        waterpolo_game_visitor_score_period1 = [waterpolo_game_dictionary  objectForKey:@"waterpolo_game_visitor_score_period1"];
        waterpolo_game_visitor_score_period2 = [waterpolo_game_dictionary  objectForKey:@"waterpolo_game_visitor_score_period2"];
        waterpolo_game_visitor_score_period3 = [waterpolo_game_dictionary  objectForKey:@"waterpolo_game_visitor_score_period3"];
        waterpolo_game_visitor_score_period4 = [waterpolo_game_dictionary  objectForKey:@"waterpolo_game_visitor_score_period4"];
        waterpolo_home_shots = [waterpolo_game_dictionary  objectForKey:@"waterpolo_home_shots"];
        waterpolo_visitor_shots = [waterpolo_game_dictionary  objectForKey:@"waterpolo_visitor_shots"];
        waterpolo_home_saves = [waterpolo_game_dictionary  objectForKey:@"waterpolo_home_saves"];
        waterpolo_visitor_saves = [waterpolo_game_dictionary  objectForKey:@"waterpolo_visitor_saves"];
        waterpolo_home_steals = [waterpolo_game_dictionary  objectForKey:@"waterpolo_home_steals"];
        waterpolo_visitor_steals = [waterpolo_game_dictionary  objectForKey:@"waterpolo_visitor_steals"];
        waterpolo_home_fouls = [waterpolo_game_dictionary  objectForKey:@"waterpolo_home_fouls"];
        waterpolo_visitor_fouls = [waterpolo_game_dictionary  objectForKey:@"waterpolo_visitor_fouls"];
        waterpolo_home_goals_allowed = [waterpolo_game_dictionary  objectForKey:@"waterpolo_home_goals_allowed"];
        waterpolo_visitor_goals_allowed = [waterpolo_game_dictionary  objectForKey:@"waterpolo_visitor_goals_allowed"];
        waterpolo_home_minutes_played = [waterpolo_game_dictionary  objectForKey:@"waterpolo_home_minutes_played"];
        waterpolo_visitor_minutes_played = [waterpolo_game_dictionary  objectForKey:@"waterpolo_visitor_minutes_played"];
        
        visiting_team_id = [waterpolo_game_dictionary  objectForKey:@"visiting_team_id"];
        
        return self;
    } else
        return nil;
}

@end
