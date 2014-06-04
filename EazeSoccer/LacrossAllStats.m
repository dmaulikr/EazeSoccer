//
//  LacrossAllStats.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/30/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "LacrossAllStats.h"

@implementation LacrossAllStats

@synthesize athlete_id;
@synthesize visitor_roster_id;
@synthesize goals;
@synthesize assists;

@synthesize shots;
@synthesize face_off_won;
@synthesize face_off_lost;
@synthesize face_off_violation;
@synthesize ground_ball;
@synthesize interception;
@synthesize turnover;
@synthesize caused_turnover;
@synthesize steals;

@synthesize penalties;
@synthesize penaltytime;

@synthesize saves;
@synthesize goals_allowed;
@synthesize minutesplayed;

- (id)init {
    if (self = [super init]) {
        assists = [NSNumber numberWithInt:0];
        goals = [NSNumber numberWithInt:0];
        
        shots =[NSNumber numberWithInt:0];
        face_off_won = [NSNumber numberWithInt:0];
        face_off_lost = [NSNumber numberWithInt:0];
        face_off_violation = [NSNumber numberWithInt:0];
        ground_ball = [NSNumber numberWithInt:0];
        interception = [NSNumber numberWithInt:0];
        turnover = [NSNumber numberWithInt:0];
        caused_turnover = [NSNumber numberWithInt:0];
        steals = [NSNumber numberWithInt:0];
        
        penalties = [NSNumber numberWithInt:0];
        penaltytime = @"";
        
        saves = [NSNumber numberWithInt:0];
        goals_allowed = [NSNumber numberWithInt:0];
        minutesplayed = @"";
        
        return  self;
    } else
        return nil;
}

- (BOOL)hasGoalieStats {
    if (([saves intValue] > 0) || ([goals_allowed intValue] > 0) || ([minutesplayed intValue] > 0))
        return YES;
    else
        return NO;
}

@end
