//
//  HockeyGame.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 8/20/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "HockeyGame.h"

#import "EazesportzAppDelegate.h"
#import "EazesportzGetGame.h"

@implementation HockeyGame {
    long responseStatusCode;
    NSMutableData *theData;
}

@synthesize hockey_oppsog;
@synthesize hockey_oppassists;
@synthesize hockey_oppsaves;
// @synthesize penalties;
@synthesize home_time_outs_left;
@synthesize visitor_time_outs_left;

@synthesize hockey_home_score;
@synthesize hockey_visitor_score;
@synthesize hockey_home_shots;
@synthesize hockey_visitor_shots;
@synthesize hockey_home_saves;
@synthesize hockey_visitor_saves;
@synthesize hockey_home_penalties;
@synthesize hockey_visitor_penalties;
@synthesize hockey_home_goals_allowed;
@synthesize hockey_visitor_goals_allowed;
@synthesize hockey_home_minutes_played;
@synthesize hockey_visitor_minutes_played;

@synthesize hockey_game_home_score_period1;
@synthesize hockey_game_home_score_period2;
@synthesize hockey_game_home_score_period3;
@synthesize hockey_game_home_score_overtime;

@synthesize visitor_score_period1;
@synthesize visitor_score_period2;
@synthesize visitor_score_period3;
@synthesize visitor_score_overtime;

@synthesize home_penalty_one_number;
@synthesize home_penalty_one_minutes;
@synthesize home_penalty_one_seconds;
@synthesize home_penalty_two_number;
@synthesize home_penalty_two_minutes;
@synthesize home_penalty_two_seconds;

@synthesize visitor_penalty_one_number;
@synthesize visitor_penalty_one_minutes;
@synthesize visitor_penalty_one_seconds;
@synthesize visitor_penalty_two_number;
@synthesize visitor_penalty_two_minutes;
@synthesize visitor_penalty_two_seconds;

@synthesize hockey_penalties;

@synthesize hockey_game_id;
@synthesize gameschedule_id;

@synthesize visiting_team_id;

- (id)initWithDictionary:(NSDictionary *)hockey_game_dictionary {
    if (self = [super init]) {
        
        hockey_oppsog = [hockey_game_dictionary objectForKey:@"hockey_oppsog"];
        hockey_oppassists = [hockey_game_dictionary objectForKey:@"hockey_oppassists"];
        hockey_oppsaves = [hockey_game_dictionary objectForKey:@"hockey_oppsaves"];
//        penalties = [hockey_game_dictionary objectForKey:@"penalties"];
        home_time_outs_left = [hockey_game_dictionary objectForKey:@"home_time_outs_left"];
        visitor_time_outs_left = [hockey_game_dictionary objectForKey:@"visitor_time_outs_left"];
        
        hockey_home_score = [hockey_game_dictionary objectForKey:@"hockey_home_score"];
        hockey_visitor_score = [hockey_game_dictionary objectForKey:@"hockey_visitor_score"];
        hockey_home_shots = [hockey_game_dictionary objectForKey:@"hockey_home_shots"];
        hockey_visitor_shots = [hockey_game_dictionary objectForKey:@"hockey_visitor_shots"];
        hockey_home_saves = [hockey_game_dictionary objectForKey:@"hockey_home_saves"];
        hockey_home_penalties = [hockey_game_dictionary objectForKey:@"hockey_home_penalties"];
        hockey_visitor_penalties = [hockey_game_dictionary objectForKey:@"hockey_visitor_penalties"];
        hockey_home_goals_allowed = [hockey_game_dictionary objectForKey:@"hockey_home_goals_allowed"];
        hockey_visitor_goals_allowed = [hockey_game_dictionary objectForKey:@"hockey_visitor_goals_allowed"];
        hockey_home_minutes_played = [hockey_game_dictionary objectForKey:@"hockey_home_minutes_played"];
        hockey_visitor_minutes_played = [hockey_game_dictionary objectForKey:@"hockey_visitor_minutes_played"];
        
        hockey_game_home_score_period1 = [hockey_game_dictionary objectForKey:@"home_score_period1"];
        hockey_game_home_score_period2 = [hockey_game_dictionary objectForKey:@"home_score_period2"];
        hockey_game_home_score_period3 = [hockey_game_dictionary objectForKey:@"home_score_period3"];
        hockey_game_home_score_overtime = [hockey_game_dictionary objectForKey:@"home_score_periodOT"];
        
        visitor_score_period1 = [hockey_game_dictionary objectForKey:@"visitor_score_period1"];
        visitor_score_period2 = [hockey_game_dictionary objectForKey:@"visitor_score_period2"];
        visitor_score_period3 = [hockey_game_dictionary objectForKey:@"visitor_score_period3"];
        visitor_score_overtime = [hockey_game_dictionary objectForKey:@"visitor_score_periodOT"];
        
        home_penalty_one_number = [hockey_game_dictionary objectForKey:@"home_penalty_one_number"];
        home_penalty_one_minutes = [hockey_game_dictionary objectForKey:@"home_penalty_one_minutes"];
        home_penalty_one_seconds = [hockey_game_dictionary objectForKey:@"home_penalty_one_seconds"];
        home_penalty_two_number = [hockey_game_dictionary objectForKey:@"home_penalty_two_number"];
        home_penalty_two_minutes = [hockey_game_dictionary objectForKey:@"home_penalty_two_minutes"];
        home_penalty_two_seconds = [hockey_game_dictionary objectForKey:@"home_penalty_two_seconds"];
        
        visitor_penalty_one_number = [hockey_game_dictionary objectForKey:@"visitor_penalty_one_number"];
        visitor_penalty_one_minutes = [hockey_game_dictionary objectForKey:@"visitor_penalty_one_minutes"];
        visitor_penalty_one_seconds = [hockey_game_dictionary objectForKey:@"visitor_penalty_one_seconds"];
        visitor_penalty_two_number = [hockey_game_dictionary objectForKey:@"visitor_penalty_two_number"];
        visitor_penalty_two_minutes = [hockey_game_dictionary objectForKey:@"visitor_penalty_two_minutes"];
        visitor_penalty_two_seconds = [hockey_game_dictionary objectForKey:@"visitor_penalty_two_seconds"];
        
        hockey_penalties = [self parsePositions:[hockey_game_dictionary objectForKey:@"hockey_penalties"]];
        
        hockey_game_id = [hockey_game_dictionary objectForKey:@"hockey_game_id"];
        gameschedule_id = [hockey_game_dictionary objectForKey:@"gameschedule_id"];
        
        return self;
    } else
        return nil;
}

- (NSMutableDictionary *)parsePositions:(NSArray *)positions {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < positions.count; i++) {
        NSArray *pospair = [positions objectAtIndex:i];
        for (int cnt = 0; cnt < pospair.count; cnt = cnt + 2) {
            [result setObject:[pospair objectAtIndex:cnt + 1] forKey:[pospair objectAtIndex:cnt]];
        }
    }
    
    return result;
}

- (void)save {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *urlstring = [NSString stringWithFormat:@"%@/sports/%@/teams/%@/gameschedules/%@/hockey_games/%@.json?auth_token=%@",
                           [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"], currentSettings.sport.id, currentSettings.team.teamid,
                           gameschedule_id, hockey_game_id, currentSettings.user.authtoken];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:hockey_oppsog, @"hockey_oppsog", hockey_oppassists,
                                       @"hockey_oppassists", hockey_oppsaves, @"hockey_oppsaves",
                                       home_time_outs_left, @"home_time_outs_left", visitor_time_outs_left, @"visitor_time_outs_left",
                                       visitor_score_period1, @"visitor_score_period1",  visitor_score_period2, @"visitor_score_period2",
                                       visitor_score_period3, @"visitor_score_period3", visitor_score_overtime, @"visitor_score_periodOT1",
                                       home_penalty_one_number, @"home_penalty_one_number", home_penalty_one_minutes, @"home_penalty_one_minutes",
                                       home_penalty_one_seconds, @"home_penalty_one_seconds", home_penalty_two_number, @"home_penalty_two_number",
                                       home_penalty_two_minutes, @"home_penalty_two_minutes", home_penalty_two_seconds, @"home_penalty_two_seconds",
                                       visitor_penalty_one_number, @"visitor_penalty_one_number",
                                       visitor_penalty_one_minutes, @"visitor_penalty_one_minutes",
                                       visitor_penalty_one_seconds, @"visitor_penalty_one_seconds",
                                       visitor_penalty_two_number, @"visitor_penalty_two_number",
                                       visitor_penalty_two_minutes, @"visitor_penalty_two_minutes",
                                       visitor_penalty_two_seconds, @"visitor_penalty_two_seconds", nil];
//                                       penalties, @"penalties", nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"PUT"];
    
    NSError *jsonSerializationError = nil;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[[NSDictionary  alloc] initWithObjectsAndKeys:dictionary, @"hockey_game", nil] options:0 error:&jsonSerializationError];
    
    if (!jsonSerializationError) {
        NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Serialized JSON: %@", serJson);
    } else {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonData];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    responseStatusCode = [httpResponse statusCode];
    theData = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [theData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HockeyGameSavedNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSError *jsonSerializationError = nil;
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:&jsonSerializationError];
    NSLog(@"%@", serverData);
    
    if (responseStatusCode == 200) {
        [[[EazesportzGetGame alloc] init] getGameSynchronous:currentSettings.sport Team:currentSettings.team Game:gameschedule_id User:currentSettings.user];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HockeyGameSavedNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HockeyGameSavedNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Save Error", @"Result", nil]];
    }
}

- (NSNumber *)visitorScore {
    return [NSNumber numberWithInt:([visitor_score_period1 intValue] + [visitor_score_period2 intValue] +
                                    [visitor_score_period3 intValue] + [visitor_score_overtime intValue])];
}

- (NSArray *)getHockeyScores {
    NSMutableArray *gamescoreings = [[NSMutableArray alloc] init];
    GameSchedule *game = [currentSettings findGame:gameschedule_id];
    
    for (int i = 0; i < currentSettings.roster.count; i++) {
        HockeyStat *astat = [[currentSettings.roster objectAtIndex:i] findHockeyStat:game];
        
        if (astat.scoring_stats.count > 0) {
            for (int cnt = 0; cnt < astat.scoring_stats.count; cnt++) {
                [gamescoreings addObject:[astat.scoring_stats objectAtIndex:cnt]];
            }
        }
    }
    
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"period" ascending:YES];
    NSSortDescriptor *secondDescriptor = [[NSSortDescriptor alloc] initWithKey:@"gametime" ascending:NO
                                                                      selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *descriptors = [NSArray arrayWithObjects:firstDescriptor, secondDescriptor, nil];
    [gamescoreings sortUsingDescriptors:descriptors];
    
    return gamescoreings;
}

- (NSString *)findScoreLog:(NSString *)scorelogid {
    NSString *scorelog;
    GameSchedule *game = [currentSettings findGame:gameschedule_id];
    
    if ([currentSettings.sport.name isEqualToString:@"Hockey"]) {
        for (int i = 0; i < currentSettings.roster.count; i++) {
            HockeyStat *hockeystat = [[currentSettings.roster objectAtIndex:i] findHockeyStat:game];
            
            for (int cnt = 0; cnt < hockeystat.scoring_stats.count; cnt++) {
                
                if ([[[hockeystat.scoring_stats objectAtIndex:cnt] hockey_scoring_id] isEqualToString:scorelogid]) {
                    HockeyScoring *scorestat = [hockeystat.scoring_stats objectAtIndex:cnt];
                    scorelog = [scorestat getScoreLog];
                    goto Done;
                }
                
            }
            
        }
    }
    
Done:
    return scorelog;
}

@end
