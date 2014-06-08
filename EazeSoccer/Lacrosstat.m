//
//  Lacrosse.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "Lacrosstat.h"

#import "EazesportzAppDelegate.h"

@implementation Lacrosstat {
    int responseStatusCode;
    NSMutableData *theData;
}

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

- (LacrossAllStats *)summarizeStats {
    LacrossAllStats *stats = [[LacrossAllStats alloc] init];
    
    stats.athlete_id = athlete_id;
    stats.visitor_roster_id = visitor_roster_id;
    stats.goals = [NSNumber numberWithLong:scoring_stats.count];
    
    for (int i = 0; i < player_stats.count; i++) {
        LacrossPlayerStat *thestats = [player_stats objectAtIndex:i];
        stats.shots = [NSNumber numberWithLong:thestats.shot.count + [stats.shots longValue]];
        stats.face_off_won = [NSNumber numberWithInt:[thestats.face_off_won intValue] + [stats.face_off_won intValue]];
        stats.face_off_lost = [NSNumber numberWithInt:[thestats.face_off_won intValue] + [stats.face_off_won intValue]];
        stats.face_off_violation = [NSNumber numberWithInt:[thestats.face_off_violation intValue] + [stats.face_off_violation intValue]];
        stats.ground_ball = [NSNumber numberWithInt:[thestats.ground_ball intValue] + [stats.ground_ball intValue]];
        stats.interception = [NSNumber numberWithInt:[thestats.interception intValue] + [stats.interception intValue]];
        stats.turnover = [NSNumber numberWithInt:[thestats.turnover intValue] + [stats.turnover intValue]];
        stats.caused_turnover = [NSNumber numberWithInt:[thestats.caused_turnover intValue] + [stats.caused_turnover intValue]];
        stats.steals = [NSNumber numberWithInt:[thestats.steals intValue] + [stats.steals intValue]];
    }
    
    stats.penalties = [NSNumber numberWithLong:penalty_stats.count];
    int minutes = 0;
    int seconds = 0;
    
    for (int i = 0; i < penalty_stats.count; i++) {
        NSArray *penaltytime = [[[penalty_stats objectAtIndex:i] gametime] componentsSeparatedByString:@":"];
        minutes += [penaltytime[0] intValue];
        seconds += [penaltytime[1] intValue];
    }
    
    int minsecs = seconds % 60;
    int secmins = seconds / 60;
    minutes += secmins;
    
    stats.penaltytime = [NSString stringWithFormat:@"%@:%@", [self padzerotime:minutes], [self padzerotime:minsecs]];
    
    NSNumber *goalminutes = [NSNumber numberWithInt:0];
    
    for (int i = 0; i < goalstats.count; i++) {
        LacrossGoalstat *goalstat = [goalstats objectAtIndex:i];
        stats.saves = [NSNumber numberWithInt:[goalstat.saves intValue] + [stats.saves intValue]];
        stats.goals_allowed = [NSNumber numberWithInt:[goalstat.goals_allowed intValue] + [stats.goals_allowed intValue]];
        goalminutes = [NSNumber numberWithInt:[goalstat.minutesplayed intValue] + [goalminutes intValue]];
    }
    
    minutes = [goalminutes intValue] % 60;
    int hours = [goalminutes intValue] / 60;
    stats.minutesplayed = [NSString stringWithFormat:@"%@:%@", [self padzerotime:hours], [self padzerotime:minutes]];
    
    return stats;
}

- (NSString *)padzerotime:(int)entry {
    NSString *result;
    
    if (entry < 10) {
        result = [NSString stringWithFormat:@"0%d", entry];
    } else {
        result = [NSString stringWithFormat:@"%d", entry];
    }
    
    return result;
}

- (BOOL)hasPlayerStatPeriod:(NSNumber *)period {
    BOOL hasperiod = NO;
    
    for (int i = 0; i < player_stats.count; i++) {
        if ([[[player_stats objectAtIndex:i] period] isEqual:period]) {
            hasperiod = YES;
            break;
        }
    }
    
    return hasperiod;
}

- (BOOL)hasGoalieStatPeriod:(NSNumber *)period {
    BOOL hasperiod = NO;
    
    for (int i = 0; i < goalstats.count; i++) {
        if ([[[goalstats objectAtIndex:i] period] isEqual:period]) {
            hasperiod = YES;
            break;
        }
    }
    
    return hasperiod;
}

- (LacrossPlayerStat *)getPlayerStatPeriod:(NSNumber *)period {
    LacrossPlayerStat *thestat;
    
    for (int i = 0; i < player_stats.count; i++) {
        if ([[[player_stats objectAtIndex:i] period] isEqual:period]) {
            thestat = [player_stats objectAtIndex:i];
            break;
        }
    }
    
    return thestat;
}

- (void)save:(Sport *)sport Game:(GameSchedule *)game User:(User *)user {
    BOOL savestats = NO;
    BOOL savescores = NO;
    BOOL savepenalties = NO;
    BOOL savegoalies = NO;
    
    NSURL *url;
    
    if (lacrosstat_id.length > 0) {
        if (athlete_id.length > 0) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/sports/%@/athletes/%@/lacrosstats/%@.json?auth_token=%@",
                                        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"], sport.id, athlete_id, lacrosstat_id,
                                        user.authtoken]];
            } else {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/sports/%@visitor_roster/%@/lacrosstats/%@.json?auth_token=%@",
                                        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"], sport.id, visitor_roster_id,
                                        lacrosstat_id, user.authtoken]];
        }
    } else {
        if (athlete_id.length > 0) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/sports/%@/athletes/%@/lacrosstats.json?auth_token=%@",
                                        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"], sport.id, athlete_id,
                                        user.authtoken]];
        } else {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/sports/%@visitor_roster/%@/lacrosstats.json?auth_token=%@",
                                        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"], sport.id, visitor_roster_id,
                                        user.authtoken]];
        }
    }
    
    NSMutableDictionary *statDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:game.lacross_game.lacross_game_id,
                                           @"lacross_game_id", nil];
        
    NSMutableArray *statsarray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < player_stats.count; i++) {

        if ([[player_stats objectAtIndex:i] dirty]) {
            savestats = YES;
            LacrossPlayerStat *playerstat = [player_stats objectAtIndex:i];
            NSDictionary *adict = [[NSDictionary alloc] initWithObjectsAndKeys:playerstat.ground_ball, @"ground_ball",
                                   playerstat.face_off_won, @"face_off_won", playerstat.face_off_lost, @"face_off_lost",
                                   playerstat.face_off_violation, @"face_off_violation", playerstat.interception, @"interception",
                                   playerstat.turnover, @"turnover", playerstat.caused_turnover, @"caused_turnover",
                                   playerstat.steals, @"steals", playerstat.period, @"period", playerstat.shot, @"shot",
                                   playerstat.lacrosstat_id, @"lacrosstat_id", nil];
            
            if (playerstat.lacross_player_stat_id.length > 0)
                [adict setValue:playerstat.lacross_player_stat_id forKey:@"lacross_player_stat_id"];
            
            playerstat.dirty = NO;
            
            [statsarray addObject:adict];
        }
    }
    
    if (savestats)
        [statDictionary setObject:statsarray forKey:@"lacross_player_stats"];
    
    statsarray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < goalstats.count; i++) {
        if ([[goalstats objectAtIndex:i] dirty]) {
            savegoalies = YES;
            LacrossGoalstat *goalstat = [goalstats objectAtIndex:i];
            NSDictionary *adict = [[NSDictionary alloc] initWithObjectsAndKeys:goalstat.saves, @"saves", goalstat.minutesplayed, @"minutesplayed",
                                   goalstat.goals_allowed, @"goals_allowed", goalstat.period, @"period", goalstat.lacrosstat_id, @"lacrosstat_id", nil];
            
            if (goalstat.lacross_goalstat_id.length > 0)
                [adict setValue:goalstat.lacross_goalstat_id forKeyPath:@"lacross_goalstat_id"];
            
            goalstat.dirty = NO;
            
            [statsarray addObject:adict];
        }
    }
    
    if (savegoalies)
        [statDictionary setObject:statsarray forKey:@"lacross_goalstats"];
    
    statsarray = [[NSMutableArray alloc] init];

    for (int i = 0; i < scoring_stats.count; i++) {
        if ([[scoring_stats objectAtIndex:i] dirty]) {
            savescores = YES;
            LacrossScoring *score = [scoring_stats objectAtIndex:i];
            NSDictionary *adict = [[NSDictionary alloc] initWithObjectsAndKeys:score.scorecode, @"scorecode", score.gametime, @"gametime",
                                   score.period, @"period", score.assist, @"assist", score.lacrosstat_id, @"lacrosstat_id", nil];
            
            if (score.lacross_scoring_id.length > 0)
                [adict setValue:score.lacross_scoring_id forKeyPath:@"lacross_scoring_id"];
            
            score.dirty = NO;
            
            [statsarray addObject:adict];
        }
    }
    
    if (savescores)
        [statDictionary setObject:statsarray forKey:@"lacross_scorings"];
    
    statsarray = [[NSMutableArray alloc] init];

    for (int i = 0; i < penalty_stats.count; i++) {
        if ([[penalty_stats objectAtIndex:i] dirty]) {
            savepenalties = YES;
            LacrossPenalty *penalty = [penalty_stats objectAtIndex:i];
            NSDictionary *adict = [[NSDictionary alloc] initWithObjectsAndKeys:penalty.infraction, @"infraction", penalty.gametime, @"gametime",
                                   penalty.period, @"period", penalty.type, @"type", penalty.lacrosstat_id, @"lacrosstat_id", nil];
            
            if (penalty.lacross_penalty_id.length > 0)
                [adict setValue:penalty.lacross_penalty_id forKeyPath:@"lacross_penalty_id"];
            
            penalty.dirty = NO;
            
            [statsarray addObject:adict];
        }
    }
    
    if (savepenalties)
        [statDictionary setObject:statsarray forKey:@"lacross_penalties"];
    
    if ((savepenalties) || (savegoalies) || (savescores) || (savestats)) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSError *jsonSerializationError = nil;
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        if (lacrosstat_id.length > 0)
            [request setHTTPMethod:@"PUT"];
        else
            [request setHTTPMethod:@"POST"];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[[NSDictionary alloc] initWithObjectsAndKeys:statDictionary, @"lacrosstats", nil]
                                                           options:0 error:&jsonSerializationError];
        
        if (!jsonSerializationError) {
            NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"Serialized JSON: %@", serJson);
        } else {
            NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
        }
        
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:jsonData];
        [[NSURLConnection alloc] initWithRequest:request  delegate:self];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    responseStatusCode = [httpResponse statusCode];
    theData = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [theData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LacrosstatUpdatedNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSError *jsonSerializationError = nil;
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:&jsonSerializationError];
    NSLog(@"%@", serverData);
    NSDictionary *items = [serverData objectForKey:@"lacrosstat_id"];
    
    if (responseStatusCode == 200) {
        if (lacrosstat_id.length == 0) {
            lacrosstat_id = [items objectForKey:@"_id"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LacrosstatUpdatedNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LacrosstatUpdatedNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Save Error", @"Result", nil]];
    }
}

@end
