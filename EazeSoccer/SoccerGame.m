//
//  SoccerGame.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/26/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzAppDelegate.h"
#import "SoccerGame.h"
#import "EazesportzGetGame.h"

@implementation SoccerGame {
    long responseStatusCode;
    NSMutableData *theData;
}

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

@synthesize soccersubs;

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
        
        visiting_team_id = [soccer_game_dictionary objectForKey:@"visiting_team_id"];
        
        NSArray *subs = [soccer_game_dictionary objectForKey:@"soccer_subs"];
        
        if (subs.count > 0) {
            soccersubs = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < subs.count; i++) {
                [soccersubs addObject:[[SoccerSubs alloc] initWithDictionary:[subs objectAtIndex:i]]];
            }
        }
        
        return self;
    } else
        return nil;
}

- (void)saveSoccerGame {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *urlstring = [NSString stringWithFormat:@"%@/sports/%@/games/%@/soccer_games/%@.json?auth_token=%@",
                           [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"], currentSettings.sport.id, gameschedule_id, soccer_game_id,
                           currentSettings.user.authtoken];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:socceroppsog, @"socceroppsog", socceroppck,
                                       @"socceroppck", socceroppsaves, @"socceroppsaves", socceroppfouls, @"socceroppfouls", visitorfouls, @"visitorfouls",
                                       visitoroffsides, @"visitoroffsides", nil];
    
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

- (void)saveSub:(SoccerSubs *)soccersub {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *urlstring = [NSString stringWithFormat:@"%@/sports/%@/games/%@/soccer_games/%@/addsubstitute_player?auth_token=%@",
                           [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"], currentSettings.sport.id, gameschedule_id, soccer_game_id,
                           currentSettings.user.authtoken];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSArray *timearray = [soccersub.gametime componentsSeparatedByString:@":"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:soccersub.inplayer, @"inplayer", soccersub.outplayer,
                                       @"outplayer", timearray[0], @"minutes", timearray[1], @"seconds", soccersub.home, @"home",  nil];

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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SoccerGameStatNotification" object:nil
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SoccerGameStatNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SoccerGameStatNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Save Error", @"Result", nil]];
    }
}

- (void)deleteSub:(SoccerSubs *)soccersub {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *urlstring = [NSString stringWithFormat:@"%@/sports/%@/games/%@/soccer_games/%@/deletesub?auth_token=%@",
                           [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"], currentSettings.sport.id, gameschedule_id, soccer_game_id,
                           currentSettings.user.authtoken];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:soccersub.soccer_sub_id, @"subs",  nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"DELETE"];
    
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

- (NSArray *)getSoccerScores:(BOOL)home {
    NSMutableArray *gamescoreings = [[NSMutableArray alloc] init];
    GameSchedule *game = [currentSettings findGame:gameschedule_id];
    
    if (home) {
        for (int i = 0; i < currentSettings.roster.count; i++) {
            SoccerStat *astat = [[currentSettings.roster objectAtIndex:i] getSoccerGameStat:game.soccer_game.soccer_game_id];
            
            if (astat.scoring_stats.count > 0) {
                for (int cnt = 0; cnt < astat.scoring_stats.count; cnt++) {
                    [gamescoreings addObject:[astat.scoring_stats objectAtIndex:cnt]];
                }
            }
        }
    } else if ((!home) && (visiting_team_id.length > 0)) {
        VisitingTeam *visitors = [currentSettings findVisitingTeam:game.lacross_game.visiting_team_id];
        
        for (int i = 0; i < visitors.visitor_roster.count; i++) {
            SoccerStat *astat = [[visitors.visitor_roster objectAtIndex:i] getSoccerGameStat:game.soccer_game.soccer_game_id];
            
            if (astat) {
                if (astat.scoring_stats.count > 0) {
                    for (int cnt = 0; cnt < astat.scoring_stats.count; cnt++) {
                        [gamescoreings addObject:[astat.scoring_stats objectAtIndex:cnt]];
                    }
                }
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

@end
