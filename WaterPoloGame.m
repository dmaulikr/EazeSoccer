//
//  WaterPoloGame.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/19/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "WaterPoloGame.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzGetGame.h"

@implementation WaterPoloGame {
    long responseStatusCode;
    NSMutableData *theData;
}

@synthesize waterpolo_oppsog;
@synthesize waterpolo_oppassists;
@synthesize waterpolo_oppsaves;
@synthesize waterpolo_oppfouls;
@synthesize exclusions;
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
        exclusions = [waterpolo_game_dictionary objectForKey:@"exclusions"];
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

- (void)save {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *urlstring = [NSString stringWithFormat:@"%@/sports/%@/games/%@/water_polo_games/%@.json?auth_token=%@",
                           [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"], currentSettings.sport.id, gameschedule_id, water_polo_game_id,
                           currentSettings.user.authtoken];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:waterpolo_oppsog, @"waterpolo_oppsog", waterpolo_oppassists,
                                       @"waterpolo_oppassists", waterpolo_oppsaves, @"waterpolo_oppsaves", waterpolo_oppfouls, @"waterpolo_oppfouls",
                                       home_time_outs_left, @"home_time_outs_left", visitor_time_outs_left, @"visitor_time_outs_left",
                                       exclusions, @"exclusions", nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"PUT"];
    
    NSError *jsonSerializationError = nil;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&jsonSerializationError];
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WaterPoloGameStatNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSError *jsonSerializationError = nil;
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:&jsonSerializationError];
    NSLog(@"%@", serverData);
    
    if (responseStatusCode == 200) {
        [[[EazesportzGetGame alloc] init] getGameSynchronous:currentSettings.sport Team:currentSettings.team Game:gameschedule_id
                                                        User:currentSettings.user];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WaterPoloGameStatNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WaterPoloGameStatNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Save Error", @"Result", nil]];
    }
}

@end
