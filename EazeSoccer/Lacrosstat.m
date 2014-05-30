//
//  Lacrosse.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "Lacrosstat.h"

#import "EazesportzAppDelegate.h"

@implementation Lacrosstat

@synthesize scoring_stats;
@synthesize goalstats;
@synthesize penalty_stats;
@synthesize player_stats;

@synthesize athlete_id;
@synthesize lacross_game_id;
@synthesize visitor_roster_id;
@synthesize lacrosstat_id;

@synthesize lacross_goalies_id;
@synthesize lacross_penalties_id;
@synthesize lacross_player_stats_id;
@synthesize lacross_scoring_id;

@synthesize httperror;

@synthesize lacrosse_scoring;
@synthesize lacrosse_player_stat;
@synthesize lacrosse_goalstat;
@synthesize lacrosse_penalty;

- (id)init {
    if (self = [super init]) {
        scoring_stats = [[NSMutableArray alloc] init];
        goalstats = [[NSMutableArray alloc] init];
        penalty_stats = [[NSMutableArray alloc] init];
        player_stats = [[NSMutableArray alloc] init];
        
        lacrosse_scoring = @"Scoring";
        lacrosse_penalty = @"Penalty";
        lacrosse_player_stat = @"Player Stat";
        lacrosse_goalstat = @"Goal Stat";
        
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)lacrosstats_dictionary {
    if ((self = [super init]) && (lacrosstats_dictionary.count > 0)) {
        athlete_id = [lacrosstats_dictionary objectForKey:@"athlete_id"];
        lacross_game_id = [lacrosstats_dictionary objectForKey:@"lacross_game_id"];
        visitor_roster_id = [lacrosstats_dictionary objectForKey:@"visitor_roster_id"];
        lacrosstat_id = [lacrosstats_dictionary objectForKey:@"lacrosstat_id"];
        
        scoring_stats = [[NSMutableArray alloc] init];
        NSArray *scoringArray = [lacrosstats_dictionary objectForKey:@"lacross_scorings"];
        
        for (int i = 0; i < scoringArray.count; i++) {
            NSDictionary *stats = [scoringArray objectAtIndex:i];
            LacrossScoring *scoring = [[LacrossScoring alloc] initWithDictionary:stats];
            [scoring_stats addObject:scoring];
        }
        
        goalstats = [[NSMutableArray alloc] init];
        NSArray *goalstatsArray = [lacrosstats_dictionary objectForKey:@"lacross_goalstats"];
        
        for (int i = 0; i < goalstatsArray.count; i++) {
            NSDictionary *stats = [goalstatsArray objectAtIndex:i];
            LacrossGoalstat *goalstat = [[LacrossGoalstat alloc] initWithDictionary:stats];
            [goalstats addObject:goalstat];
        }
        
        player_stats = [[NSMutableArray alloc] init];
        NSArray *playerstatsArray = [lacrosstats_dictionary objectForKey:@"lacross_player_stats"];
        
        for (int i = 0; i < playerstatsArray.count; i++) {
            NSDictionary *stats = [playerstatsArray objectAtIndex:i];
            LacrossPlayerStat *stat = [[LacrossPlayerStat alloc] initWithDictionary:stats];
            [player_stats addObject:stat];
        }
        
        penalty_stats = [[NSMutableArray alloc] init];
        NSArray *penaltystatsArray = [lacrosstats_dictionary objectForKey:@"lacross_penalties"];
        
        for (int i = 0; i < penaltystatsArray.count; i++) {
            NSDictionary *stats = [penaltystatsArray objectAtIndex:i];
            LacrossPenalty *stat = [[LacrossPenalty alloc] initWithDictionary:stats];
            [penalty_stats addObject:stat];
        }
        
        lacrosse_scoring = @"Scoring";
        lacrosse_penalty = @"Penalty";
        lacrosse_player_stat = @"Player Stat";
        lacrosse_goalstat = @"Goal Stat";
        
        return self;
    } else {
        return nil;
    }
}

- (void)addScoringStat:(LacrossScoring *)stat {
    BOOL found = NO;
    
    for (int i = 0; i < scoring_stats.count; i++) {
        if ([stat.lacross_scoring_id isEqualToString:stat.lacross_scoring_id]) {
            found = YES;
            break;
        }
    }
    
    if (!found)
        [scoring_stats addObject:stat];
}

- (void)addPenaltyStat:(LacrossPenalty *)stat {
    BOOL found = NO;
    
    for (int i = 0; i < penalty_stats.count; i++) {
        if ([stat.lacross_penalty_id isEqualToString:stat.lacross_penalty_id]) {
            found = YES;
            break;
        }
    }
    
    if (!found)
        [penalty_stats addObject:stat];
}

- (BOOL)deleteStat:(NSString *)statid Game:(NSString *)gameid Stat:(NSString *)lacross_stat {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *urlstring;
    
    if (visitor_roster_id) {
        urlstring = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",[mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/teams/", currentSettings.team.teamid, @"/gameschedules/", gameid];
        
        if ([statid isEqualToString:lacrosse_scoring]) {
            urlstring = [urlstring stringByAppendingString:
                         [NSString stringWithFormat:@"/delete_visiting_score.json?auth_token=%@&lacrosstat_id=%@&lacross_scoring_id=%@",
                                                            currentSettings.user.authtoken, lacrosstat_id, lacross_stat]];
        } else if ([statid isEqualToString:lacrosse_penalty]) {
            urlstring = [urlstring stringByAppendingString:
                         [NSString stringWithFormat:@"/delete_visiting_penalty.json?auth_token=%@&lacrosstat_id=%@&lacross_penalty_id=%@",
                          currentSettings.user.authtoken, lacrosstat_id, lacross_stat]];
        } else if ([statid isEqualToString:lacrosse_player_stat]) {
            urlstring = [urlstring stringByAppendingString:
                         [NSString stringWithFormat:@"/delete_visiting_player_stats.json?auth_token=%@&lacrosstat_id=%@&lacross_player_stat_id=%@",
                          currentSettings.user.authtoken, lacrosstat_id, lacross_stat]];
        } else if ([statid isEqualToString:lacrosse_goalstat]) {
            urlstring = [urlstring stringByAppendingString:[NSString stringWithFormat:@"lacross_goalstat_id=%@", lacross_stat]];
        }

    } else {
        urlstring = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",[mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                     @"/sports/", currentSettings.sport.id, @"/athletes/", athlete_id, @"/lacrosstats/", lacrosstat_id,
                                     @".json?auth_token=", currentSettings.user.authtoken];
    
        if ([statid isEqualToString:lacrosse_scoring]) {
            urlstring = [urlstring stringByAppendingString:[NSString stringWithFormat:@"&lacross_scoring_id=%@", lacross_stat]];
        } else if ([statid isEqualToString:lacrosse_player_stat]) {
            urlstring = [urlstring stringByAppendingString:[NSString stringWithFormat:@"lacross_player_stat_id=%@", lacross_stat]];
        } else if ([statid isEqualToString:lacrosse_penalty]) {
            urlstring = [urlstring stringByAppendingString:[NSString stringWithFormat:@"lacross_penalty_id=%@", lacross_stat]];
        } else if ([statid isEqualToString:lacrosse_goalstat]) {
            urlstring = [urlstring stringByAppendingString:[NSString stringWithFormat:@"lacross_goalstat_id=%@", lacross_stat]];
        }
    }

    NSURL *aurl = [NSURL URLWithString:urlstring];
    NSDictionary *dictionary = [[NSDictionary alloc] init];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
    //    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:dictionary, @"gameschedule", nil];
    
    NSError *jsonSerializationError = nil;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"DELETE"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&jsonSerializationError];
    
    if (!jsonSerializationError) {
        NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Serialized JSON: %@", serJson);
    } else {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonData];
    
    //Capturing server response
    NSURLResponse* response;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&jsonSerializationError];
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:&jsonSerializationError];
    NSLog(@"%@", serverData);
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([httpResponse statusCode] == 200) {
        [self removeStatFromArray:statid Stat:lacross_stat];
        return YES;
    } else {
        return NO;
    }
}

- (void)removeStatFromArray:(NSString *)statid Stat:(NSString *)lacross_stat {
    if ([statid isEqualToString:lacrosse_scoring]) {
        for (int i = 0; i < scoring_stats.count; i++) {
            if ([[[scoring_stats objectAtIndex:i] lacross_scoring_id] isEqualToString:lacross_stat])
                [scoring_stats removeObjectAtIndex:i];
        }
    } else if ([statid isEqualToString:lacrosse_player_stat]) {
        for (int i = 0; i < player_stats.count; i++) {
            if ([[[player_stats objectAtIndex:i] lacross_player_stat_id] isEqualToString:lacross_stat])
                [player_stats removeObjectAtIndex:i];
        }
    } else if ([statid isEqualToString:lacrosse_penalty]) {
        for (int i = 0; i < penalty_stats.count; i++) {
            if ([[[penalty_stats objectAtIndex:i] lacross_penalty_id] isEqualToString:lacross_stat])
                [penalty_stats removeObjectAtIndex:i];
        }
    } else {
        for (int i = 0; i < goalstats.count; i++) {
            if ([[[goalstats objectAtIndex:i] lacross_goalstat_id] isEqualToString:lacross_stat])
                [goalstats removeObjectAtIndex:i];
        }
    }
}

@end
