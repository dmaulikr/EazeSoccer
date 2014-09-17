//
//  HockeyStat.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 8/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "HockeyStat.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzRetrievePlayers.h"
#import "EazesportzGetGame.h"

@implementation HockeyStat {
    long responseStatusCode;
    NSMutableData *theData;
    NSString *gameidentifier;
}

@synthesize scoring_stats;
@synthesize player_stats;
@synthesize goalstats;
@synthesize penalty_stats;

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

@synthesize hockey_goalstat;
@synthesize hockey_penalty;
@synthesize hockey_player_stat;
@synthesize hockey_scoring;

- (id)init {
    if (self = [super init]) {
        scoring_stats = [[NSMutableArray alloc] init];
        goalstats = [[NSMutableArray alloc] init];
        penalty_stats = [[NSMutableArray alloc] init];
        player_stats = [[NSMutableArray alloc] init];
        
        hockey_scoring = @"Scoring";
        hockey_penalty = @"Penalty";
        hockey_player_stat = @"Player Stat";
        hockey_goalstat = @"Goal Stat";
        
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)hockey_dictionary {
    if ((self = [super init]) && (hockey_dictionary.count > 0)) {
        [self parseDictionary:hockey_dictionary];
        return self;
    } else {
        return nil;
    }
}

- (void)parseDictionary:(NSDictionary *)hockey_dictionary {
    athlete_id = [hockey_dictionary objectForKey:@"athlete_id"];
    hockey_game_id = [hockey_dictionary objectForKey:@"hockey_game_id"];
    hockey_stat_id = [hockey_dictionary objectForKey:@"hockey_stat_id"];
    
    scoring_stats = [[NSMutableArray alloc] init];
    NSArray *scoringArray = [hockey_dictionary objectForKey:@"hockey_scorings"];
    
    for (int i = 0; i < scoringArray.count; i++) {
        NSDictionary *stats = [scoringArray objectAtIndex:i];
        HockeyScoring *scoring = [[HockeyScoring alloc] initWithDictionary:stats];
        [scoring_stats addObject:scoring];
    }
    
    goalstats = [[NSMutableArray alloc] init];
    NSArray *goalstatsArray = [hockey_dictionary objectForKey:@"hockey_goalstats"];
    
    for (int i = 0; i < goalstatsArray.count; i++) {
        NSDictionary *stats = [goalstatsArray objectAtIndex:i];
        HockeyGoalStat *goalstat = [[HockeyGoalStat alloc] initWithDictionary:stats];
        [goalstats addObject:goalstat];
    }
    
    player_stats = [[NSMutableArray alloc] init];
    NSArray *playerstatsArray = [hockey_dictionary objectForKey:@"hockey_playerstats"];
    
    for (int i = 0; i < playerstatsArray.count; i++) {
        NSDictionary *stats = [playerstatsArray objectAtIndex:i];
        HockeyPlayerStat *stat = [[HockeyPlayerStat alloc] initWithDictionary:stats];
        [player_stats addObject:stat];
    }
    
    penalty_stats = [[NSMutableArray alloc] init];
    NSArray *penaltystatsArray = [hockey_dictionary objectForKey:@"hockey_penalties"];
    
    for (int i = 0; i < penaltystatsArray.count; i++) {
        NSDictionary *stats = [penaltystatsArray objectAtIndex:i];
        HockeyPenalty *stat = [[HockeyPenalty alloc] initWithDictionary:stats];
        [penalty_stats addObject:stat];
    }
    
    hockey_scoring = @"Scoring";
    hockey_penalty = @"Penalty";
    hockey_player_stat = @"Player Stat";
    hockey_goalstat = @"Goal Stat";
}

- (HockeyPlayerStat *)findPlayerStat:(NSNumber *)period {
    HockeyPlayerStat *entry = [[HockeyPlayerStat alloc] init];
    
    for (int i = 0; i < [player_stats count]; i++) {
        if ([[[player_stats objectAtIndex:i] period] isEqual:period]) {
            entry = [player_stats objectAtIndex:i];
        }
    }
    
    if (entry.hockey_playerstat_id.length == 0) {
        entry.hockey_stat_id = hockey_stat_id;
        entry.athlete_id = athlete_id;
    }
    
    return entry;
}

- (HockeyGoalStat *)findGoalStat:(NSNumber *)period {
    HockeyGoalStat *entry = [[HockeyGoalStat alloc] init];
    
    for (int i = 0; i < [goalstats count]; i++) {
        if ([[[goalstats objectAtIndex:i] period] isEqual:period]) {
            entry = [goalstats objectAtIndex:i];
        }
    }
    
    if (entry.hockey_goalstat_id.length == 0) {
        entry.hockey_stat_id = hockey_stat_id;
        entry.athlete_id = athlete_id;
    }
    
    return entry;
}

- (HockeyPenalty *)findPenaltyStat:(NSNumber *)period {
    HockeyPenalty *entry = [[HockeyPenalty alloc] init];
    
    for (int i = 0; i < [penalty_stats count]; i++) {
        if ([[[penalty_stats objectAtIndex:i] period] isEqual:period]) {
            entry = [penalty_stats objectAtIndex:i];
        }
    }
    
    if (entry.hockey_penalty_id.length == 0) {
        entry.hockey_stat_id = hockey_stat_id;
        entry.athlete_id = athlete_id;
    }
    
    return entry;
}

- (HockeyScoring *)findScoringStat:(NSNumber *)period {
    HockeyScoring *entry = [[HockeyScoring alloc] init];
    
    for (int i = 0; i < [scoring_stats count]; i++) {
        if ([[[scoring_stats objectAtIndex:i] period] isEqual:period]) {
            entry = [scoring_stats objectAtIndex:i];
        }
    }
    
    if (entry.hockey_scoring_id.length == 0) {
        entry.hockey_stat_id = hockey_stat_id;
        entry.athlete_id = athlete_id;
    }
    
    return entry;
}

- (NSNumber *)getTotalShots {
    int shots = 0;
    
    for (int i = 0; i < player_stats.count; i++) {
        shots += [[[player_stats objectAtIndex:i] shots] intValue];
    }
    
    return [NSNumber numberWithInt:shots];
}

- (NSNumber *)getTotalGoals {
    return [NSNumber numberWithInteger:scoring_stats.count];
}

- (NSNumber *)getTotalAssists {
    int assists = 0;
    
    for (int i = 0; i < currentSettings.roster.count; i++) {
        HockeyStat *stats = [[currentSettings.roster objectAtIndex:i] findHockeyStat:[currentSettings findGame:hockey_game_id]];
        
        for (int cnt = 0; cnt < stats.scoring_stats.count; cnt++) {
            if ([[[stats.scoring_stats objectAtIndex:cnt] assist] isEqualToString:athlete_id]) {
                assists += 1;
            }
        }
    }
    
    return [NSNumber numberWithInt:assists];
}

- (NSNumber *)getTotalPoints {
    int points = 0;
    
    for (int i = 0; i < scoring_stats.count; i++) {
        points += 1;
    }
    
    points += [[self getTotalAssists] intValue];
    
    return [NSNumber numberWithInt:points];
}

- (NSNumber *)getTotalPowerPlayGoals {
    int ppg = 0;
    
    for (int i = 0; i < scoring_stats.count; i++) {
        if ([[[scoring_stats objectAtIndex:i] goaltype] isEqualToString:@"Power Play"]) {
            ppg += 1;
        }
    }
    
    return [NSNumber numberWithInt:ppg];
}

- (NSNumber *)getTotalPowerPlayAssists {
    int ppa = 0;
    
    for (int i = 0; i < currentSettings.roster.count; i++) {
        HockeyStat *stats = [[currentSettings.roster objectAtIndex:i] findHockeyStat:[currentSettings findGame:hockey_game_id]];
        
        for (int cnt = 0; cnt < stats.scoring_stats.count; cnt++) {
            if (([[[stats.scoring_stats objectAtIndex:cnt] assist] isEqualToString:athlete_id]) &&
                ([[[scoring_stats objectAtIndex:i] assist_type] isEqualToString:@"Power Play Assist"])) {
                ppa += 1;
            }
        }
    }

    return [NSNumber numberWithInt:ppa];
}

- (NSNumber *)getTotalShortHandedGoals {
    int goals = 0;
    
    for (int i = 0; i < scoring_stats.count; i++) {
        if ([[[scoring_stats objectAtIndex:i] goaltype] isEqualToString:@"Short Handed"]) {
            goals += 1;
        }
    }

    return [NSNumber numberWithInt:goals];
}

- (NSNumber *)getTotalShortHandedAssists {
    int assists = 0;
    
    for (int i = 0; i < currentSettings.roster.count; i++) {
        HockeyStat *stats = [[currentSettings.roster objectAtIndex:i] findHockeyStat:[currentSettings findGame:hockey_game_id]];
        
        for (int cnt = 0; cnt < stats.scoring_stats.count; cnt++) {
            if (([[[stats.scoring_stats objectAtIndex:cnt] assist] isEqualToString:athlete_id]) &&
                ([[[scoring_stats objectAtIndex:i] assist_type] isEqualToString:@"Short Handed Assist"])) {
                assists += 1;
            }
        }
    }

    return [NSNumber numberWithInt:assists];
}

- (NSNumber *)getTotalPenaltyMinutes {
    int minutes = 0, seconds = 0;
    
    for (int i = 0; i < penalty_stats.count; i++) {
        NSArray *timearray = [[[penalty_stats objectAtIndex:i] penaltytime] componentsSeparatedByString:@":"];
        minutes += [timearray[0] intValue];
        seconds += [timearray[1] intValue];
    }
    
    return [NSNumber numberWithInt:(minutes + seconds/60)];
}

- (NSNumber *)gettotalFaceOffsWon {
    int fow = 0;
    
    for (int i = 0; i < player_stats.count; i++) {
        fow += [[[player_stats objectAtIndex:i] faceoffwon] intValue];
    }
    
    return [NSNumber numberWithInt:fow];
}

- (NSNumber *)getTotalFaceOffsLost {
    int fol = 0;
    
    for (int i = 0; i < player_stats.count; i++) {
        fol += [[[player_stats objectAtIndex:i] faceofflost] intValue];
    }
    
    return [NSNumber numberWithInt:fol];
}

- (NSNumber *)getTotalTimeOnIce {
    int minutes = 0, seconds = 0;
    
    for (int i = 0; i < player_stats.count; i++) {
        NSArray *timearray = [[[player_stats objectAtIndex:i] timeonice] componentsSeparatedByString:@":"];
        minutes += [timearray[0] intValue];
        seconds += [timearray[1] intValue];
//        timeonice += [[[player_stats objectAtIndex:i] timeonice] intValue];
    }
    
    return [NSNumber numberWithInt:(minutes += seconds/60)];
}

- (NSNumber *)getTotalHits {
    int hits = 0;
    
    for (int i = 0; i < player_stats.count; i++) {
        hits += [[[player_stats objectAtIndex:i] hits] intValue];
    }
    
    return [NSNumber numberWithInt:hits];
}

- (NSNumber *)getTotalBlockedShots {
    int blockedshots = 0;
    
    for (int i = 0; i < player_stats.count; i++) {
        blockedshots += [[[player_stats objectAtIndex:i] blockedshots] intValue];
    }
    
    return [NSNumber numberWithInt:blockedshots];
}

- (NSNumber *)getTotalPlusMinues {
    int plusminus = 0;
    
    for (int i = 0; i < player_stats.count; i++) {
        plusminus += [[[player_stats objectAtIndex:i] plusminus] intValue];
    }
    
    return [NSNumber numberWithInt:plusminus];
}

- (NSNumber *)gameWinningGoal {
    int gwgoal = 0;
    
    for (int i = 0; i < scoring_stats.count; i++) {
        if ([[scoring_stats objectAtIndex:i] game_winning_goal])
            gwgoal += 1;
    }
    
    return [NSNumber numberWithInt:gwgoal];
}

- (NSNumber *)getTotalGoalsAllowed {
    int goals = 0;
    
    for (int i = 0; i < goalstats.count; i++) {
        goals += [[[goalstats objectAtIndex:i] goals_allowed] intValue];
    }
    
    return [NSNumber numberWithInt:goals];
}


- (NSNumber *)getTotalSaves {
    int saves = 0;
    
    for (int i = 0; i < goalstats.count; i++) {
        saves += [[[goalstats objectAtIndex:i] saves] intValue];
    }
    
    return [NSNumber numberWithInt:saves];
}

- (NSNumber *)getTotalMinutes {
    int minutes = 0;
    
    for (int i = 0; i < goalstats.count; i++) {
        minutes += [[[goalstats objectAtIndex:i] minutes_played] intValue];
    }
    
    return [NSNumber numberWithInt:minutes];
}

- (void)saveStat:(NSString *)gameid Dictionary:(NSMutableDictionary *)dictionary {
    gameidentifier = gameid;
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *urlstring;
    
    if (athlete_id)
        urlstring = [NSString stringWithFormat:@"%@/sports/%@/athletes/%@/hockey_stats",
                     [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"], currentSettings.sport.id, athlete_id];
    else {
    }
    
    [dictionary setValue:hockey_game_id forKey:@"hockey_game_id"];
    
    if (hockey_stat_id)
        urlstring = [urlstring stringByAppendingFormat:@"/%@.json?auth_token=%@", hockey_stat_id, currentSettings.user.authtoken];
    else
        urlstring = [urlstring stringByAppendingFormat:@".json?auth_token=%@", currentSettings.user.authtoken];
    
    NSURL *url = [NSURL URLWithString:urlstring];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    if (hockey_stat_id) {
        [request setHTTPMethod:@"PUT"];
    } else {
        [request setHTTPMethod:@"POST"];
    }
    
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
    [[NSURLConnection alloc] initWithRequest:request  delegate:self];
}

- (void)saveScoreStat:(NSString *)gameid Score:(HockeyScoring *)stat {
    NSMutableDictionary *dictionary = [stat getDictionary];
    [dictionary setValue:@"scorestat" forKey:@"scorestat"];
    [self saveStat:gameid Dictionary:dictionary];
}

- (void)savePlayerStat:(NSString *)gameid PlayerStat:(HockeyPlayerStat *)stat {
    NSMutableDictionary *dictionary = [stat getDictionary];
    [dictionary setValue:@"playerstat" forKey:@"playerstat"];
    [self saveStat:gameid Dictionary:dictionary];
}

- (void)saveGoalStat:(NSString *)gameid GoalStat:(HockeyScoring *)stat {
    NSMutableDictionary *dictionary = [stat getDictionary];
    [dictionary setValue:@"goalstat" forKey:@"goalstat"];
    [self saveStat:gameid Dictionary:dictionary];
}

- (void)savePenaltyStat:(NSString *)gameid PenaltyStat:(HockeyPlayerStat *)stat {
    NSMutableDictionary *dictionary = [stat getDictionary];
    [dictionary setValue:@"penaltystat" forKey:@"penaltystat"];
    [self saveStat:gameid Dictionary:dictionary];
}

- (void)deleteScoreStat:(NSString *)gameid Score:(HockeyScoring *)stat {
    [self deleteStat:gameid Stat:@"hockey_scoring" Id:stat.hockey_scoring_id Period:stat.period];
}

- (void)deletePlayerStat:(NSString *)gameid PlayerStat:(HockeyPlayerStat *)stat {
    [self deleteStat:gameid Stat:@"hockey_playerstat" Id:stat.hockey_playerstat_id Period:stat.period];
}

- (void)deletePenaltyStat:(NSString *)gameid PenaltyStat:(HockeyPenalty *)stat {
    [self deleteStat:gameid Stat:@"hockey_penalty" Id:stat.hockey_penalty_id Period:stat.period];
}

- (void)deleteGoalStat:(NSString *)gameid GoalStat:(HockeyGoalStat *)stat {
    [self deleteStat:gameid Stat:@"hockey_goalstat" Id:stat.hockey_goalstat_id Period:stat.period];
}

- (void)deleteStat:(NSString *)gameid Stat:(NSString *)stattype Id:(NSString *)statid Period:(NSNumber *)period {
    gameidentifier = gameid;
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *urlstring;
    
    if (athlete_id)
        urlstring = [NSString stringWithFormat:@"%@/sports/%@/athletes/%@/hockey_stats/%@.json?auth_token=%@",
                     [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"], currentSettings.sport.id, athlete_id, hockey_stat_id,
                     currentSettings.user.authtoken];
    else {
    }
    
    NSURL *url = [NSURL URLWithString:urlstring];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setValue:statid forKey:stattype];
    
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
    [[NSURLConnection alloc] initWithRequest:request  delegate:self];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HockeyStatNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSError *jsonSerializationError = nil;
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:&jsonSerializationError];
    NSLog(@"%@", serverData);
    
    if (responseStatusCode == 200) {
        
        [[[EazesportzGetGame alloc] init] getGameSynchronous:currentSettings.sport Team:currentSettings.team Game:gameidentifier
                                                        User:currentSettings.user];
        if (hockey_stat_id)
            [self parseDictionary:serverData];
        else
            [[[EazesportzRetrievePlayers alloc] init] getAthleteSynchronous:currentSettings.sport.id Team:currentSettings.team.teamid Athlete:athlete_id];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HockeyStatNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HockeyStatNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Save Error", @"Result", nil]];
    }
}

@end
