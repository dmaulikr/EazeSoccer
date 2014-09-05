//
//  HockeyStat.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 8/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "HockeyStat.h"

@implementation HockeyStat {
    long responseStatusCode;
    NSMutableData *theData;
}

@synthesize hockey_oppsog;
@synthesize hockey_oppassists;
@synthesize hockey_oppsaves;
@synthesize hockey_opppenalties;

@synthesize penalties;

@synthesize home_time_outs_left;
@synthesize visitor_time_outs_left;

@synthesize home_score;
@synthesize visitor_score;

@synthesize home_shots;
@synthesize home_saves;
@synthesize home_goals_allowed;

@synthesize home_score_period1;
@synthesize home_score_period2;
@synthesize home_score_period3;
@synthesize home_score_periodOT;

@synthesize visitor_score_period1;
@synthesize visitor_score_period2;
@synthesize visitor_score_period3;
@synthesize visitor_score_periodOT;

@synthesize hockey_game_id;
@synthesize hockey_stat_id;
@synthesize athlete_id;

@end
