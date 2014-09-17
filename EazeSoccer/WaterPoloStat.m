//
//  WaterPoloStat.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/19/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "WaterPoloStat.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzGetGame.h"
#import "EazesportzRetrievePlayers.h"

@implementation WaterPoloStat {
    long responseStatusCode;
    NSMutableData *theData;
    NSString *gameidentifier;
}

@synthesize scoring_stats;
@synthesize goalstats;
@synthesize penalty_stats;
@synthesize player_stats;

@synthesize waterpolo_stat_id;
@synthesize water_polo_game_id;
@synthesize athlete_id;
@synthesize visitor_roster_id;

@synthesize player_shots;
@synthesize player_steals;
@synthesize player_fouls;
@synthesize player_assists;
@synthesize player_penalties;
@synthesize player_goals_allowed;
@synthesize player_minutes_played;
@synthesize player_saves;

@synthesize waterpolo_scoring;
@synthesize waterpolo_player_stat;
@synthesize waterpolo_goalstat;
@synthesize waterpolo_penalty;

- (id)init {
    if (self = [super init]) {
        scoring_stats = [[NSMutableArray alloc] init];
        goalstats = [[NSMutableArray alloc] init];
        penalty_stats = [[NSMutableArray alloc] init];
        player_stats = [[NSMutableArray alloc] init];
        
        waterpolo_scoring = @"Scoring";
        waterpolo_penalty = @"Penalty";
        waterpolo_player_stat = @"Player Stat";
        waterpolo_goalstat = @"Goal Stat";
        
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)waterpolo_dictionary {
    if ((self = [super init]) && (waterpolo_dictionary.count > 0)) {
        [self parseDictionary:waterpolo_dictionary];
        return self;
    } else {
        return nil;
    }
}

- (void)parseDictionary:(NSDictionary *)waterpolo_dictionary {
    athlete_id = [waterpolo_dictionary objectForKey:@"athlete_id"];
    water_polo_game_id = [waterpolo_dictionary objectForKey:@"water_polo_game_id"];
    visitor_roster_id = [waterpolo_dictionary objectForKey:@"visitor_roster_id"];
    waterpolo_stat_id = [waterpolo_dictionary objectForKey:@"waterpolo_stat_id"];
    
    player_saves = [waterpolo_dictionary objectForKey:@"player_saves"];
    
    scoring_stats = [[NSMutableArray alloc] init];
    NSArray *scoringArray = [waterpolo_dictionary objectForKey:@"waterpolo_scorings"];
    
    for (int i = 0; i < scoringArray.count; i++) {
        NSDictionary *stats = [scoringArray objectAtIndex:i];
        WaterPoloScoring *scoring = [[WaterPoloScoring alloc] initWithDictionary:stats];
        [scoring_stats addObject:scoring];
    }
    
    goalstats = [[NSMutableArray alloc] init];
    NSArray *goalstatsArray = [waterpolo_dictionary objectForKey:@"waterpolo_goalstats"];
    
    for (int i = 0; i < goalstatsArray.count; i++) {
        NSDictionary *stats = [goalstatsArray objectAtIndex:i];
        WaterPoloGoalstat *goalstat = [[WaterPoloGoalstat alloc] initWithDictionary:stats];
        [goalstats addObject:goalstat];
    }
    
    player_stats = [[NSMutableArray alloc] init];
    NSArray *playerstatsArray = [waterpolo_dictionary objectForKey:@"waterpolo_playerstats"];
    
    for (int i = 0; i < playerstatsArray.count; i++) {
        NSDictionary *stats = [playerstatsArray objectAtIndex:i];
        WaterPoloPlayerstat *stat = [[WaterPoloPlayerstat alloc] initWithDictionary:stats];
        [player_stats addObject:stat];
    }
    
    penalty_stats = [[NSMutableArray alloc] init];
    NSArray *penaltystatsArray = [waterpolo_dictionary objectForKey:@"waterpolo_penalties"];
    
    for (int i = 0; i < penaltystatsArray.count; i++) {
        NSDictionary *stats = [penaltystatsArray objectAtIndex:i];
        WaterPoloPenalty *stat = [[WaterPoloPenalty alloc] initWithDictionary:stats];
        [penalty_stats addObject:stat];
    }
    
    waterpolo_scoring = @"Scoring";
    waterpolo_penalty = @"Penalty";
    waterpolo_player_stat = @"Player Stat";
    waterpolo_goalstat = @"Goal Stat";
}

- (WaterPoloPlayerstat *)findPlayerStat:(NSNumber *)period {
    WaterPoloPlayerstat *entry = [[WaterPoloPlayerstat alloc] init];
    
    for (int i = 0; i < [player_stats count]; i++) {
        if ([[[player_stats objectAtIndex:i] period] isEqual:period]) {
            entry = [player_stats objectAtIndex:i];
        }
    }
    
    if (entry.waterpolo_playerstat_id.length == 0) {
        entry.waterpolo_stat_id = waterpolo_stat_id;
        entry.athlete_id = athlete_id;
    }
    
    return entry;
}

- (WaterPoloGoalstat *)findGoalStat:(NSNumber *)period {
    WaterPoloGoalstat *entry = [[WaterPoloGoalstat alloc] init];
    
    for (int i = 0; i < [goalstats count]; i++) {
        if ([[[goalstats objectAtIndex:i] period] isEqual:period]) {
            entry = [goalstats objectAtIndex:i];
        }
    }
    
    if (entry.waterpolo_goalstat_id.length == 0) {
        entry.waterpolo_stat_id = waterpolo_stat_id;
        entry.athlete_id = athlete_id;
    }
    
    return entry;
}

- (WaterPoloPenalty *)findPenaltyStat:(NSNumber *)period {
    WaterPoloPenalty *entry = [[WaterPoloPenalty alloc] init];
    
    for (int i = 0; i < [penalty_stats count]; i++) {
        if ([[[penalty_stats objectAtIndex:i] period] isEqual:period]) {
            entry = [penalty_stats objectAtIndex:i];
        }
    }
    
    if (entry.waterpolo_penalty_id.length == 0) {
        entry.waterpolo_stat_id = waterpolo_stat_id;
        entry.athlete_id = athlete_id;
    }
    
    return entry;
}

- (WaterPoloScoring *)findScoringStat:(NSNumber *)period {
    WaterPoloScoring *entry = [[WaterPoloScoring alloc] init];
    
    for (int i = 0; i < [scoring_stats count]; i++) {
        if ([[[scoring_stats objectAtIndex:i] period] isEqual:period]) {
            entry = [scoring_stats objectAtIndex:i];
        }
    }
    
    if (entry.waterpolo_scoring_id.length == 0) {
        entry.waterpolo_stat_id = waterpolo_stat_id;
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
    
    for (int i = 0; i < scoring_stats.count; i++) {
        if ([[scoring_stats objectAtIndex:i] assist].length > 0)
            assists += 1;
    }
    
    return [NSNumber numberWithInt:assists];
}

- (NSNumber *)getTotalSteals {
    int steals = 0;
    
    for (int i = 0; i < player_stats.count; i++) {
        steals += [[[player_stats objectAtIndex:i] steals] intValue];
    }
    
    return [NSNumber numberWithInt:steals];
}

- (NSNumber *)getTotalPoints {
    int points = 0;
    
    for (int i = 0; i < scoring_stats.count; i++) {
        points += 1;
    }
    
    for (int i = 0; i < currentSettings.roster.count; i++) {
//        WaterPoloStat *stat = [
    }
    
    return [NSNumber numberWithInt:points];
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
        urlstring = [NSString stringWithFormat:@"%@/sports/%@/athletes/%@/waterpolo_stats",
                     [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"], currentSettings.sport.id, athlete_id];
    else {
        VisitingTeam *visitors = [currentSettings findVisitingTeam:[currentSettings findGame:gameid].water_polo_game.visiting_team_id];
        
        urlstring = [NSString stringWithFormat:@"%@/sports/%@/visiting_teams/%@/visitor_roster/%@/waterpolo_stats",
                     [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"], currentSettings.sport.id, visitors.visiting_team_id, visitor_roster_id];
    }
    
    [dictionary setValue:water_polo_game_id forKey:@"water_polo_game_id"];
    
    if (waterpolo_stat_id)
        urlstring = [urlstring stringByAppendingFormat:@"/%@.json?auth_token=%@", waterpolo_stat_id, currentSettings.user.authtoken];
    else
        urlstring = [urlstring stringByAppendingFormat:@".json?auth_token=%@", currentSettings.user.authtoken];
    
    NSURL *url = [NSURL URLWithString:urlstring];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    if (waterpolo_stat_id) {
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

- (void)saveScoreStat:(NSString *)gameid Score:(WaterPoloScoring *)stat {
    NSMutableDictionary *dictionary = [stat getDictionary];
    [dictionary setValue:@"scorestat" forKey:@"scorestat"];
    [self saveStat:gameid Dictionary:dictionary];
}

- (void)savePlayerStat:(NSString *)gameid PlayerStat:(WaterPoloPlayerstat *)stat {
    NSMutableDictionary *dictionary = [stat getDictionary];
    [dictionary setValue:@"playerstat" forKey:@"playerstat"];
    [self saveStat:gameid Dictionary:dictionary];
}

- (void)saveGoalStat:(NSString *)gameid GoalStat:(WaterPoloScoring *)stat {
    NSMutableDictionary *dictionary = [stat getDictionary];
    [dictionary setValue:@"goalstat" forKey:@"goalstat"];
    [self saveStat:gameid Dictionary:dictionary];
}

- (void)savePenaltyStat:(NSString *)gameid PenaltyStat:(WaterPoloPlayerstat *)stat {
    NSMutableDictionary *dictionary = [stat getDictionary];
    [dictionary setValue:@"penaltystat" forKey:@"penaltystat"];
    [self saveStat:gameid Dictionary:dictionary];
}

- (void)deleteScoreStat:(NSString *)gameid Score:(WaterPoloScoring *)stat {
    [self deleteStat:gameid Stat:@"waterpolo_scoring" Id:stat.waterpolo_scoring_id Period:stat.period];
}

- (void)deletePlayerStat:(NSString *)gameid PlayerStat:(WaterPoloPlayerstat *)stat {
    [self deleteStat:gameid Stat:@"waterpolo_playerstat" Id:stat.waterpolo_playerstat_id Period:stat.period];
}

- (void)deletePenaltyStat:(NSString *)gameid PenaltyStat:(WaterPoloPenalty *)stat {
    [self deleteStat:gameid Stat:@"waterpolo_penalty" Id:stat.waterpolo_penalty_id Period:stat.period];
}

- (void)deleteGoalStat:(NSString *)gameid GoalStat:(WaterPoloGoalstat *)stat {
    [self deleteStat:gameid Stat:@"waterpolo_goalstat" Id:stat.waterpolo_goalstat_id Period:stat.period];
}

- (void)deleteStat:(NSString *)gameid Stat:(NSString *)stattype Id:(NSString *)statid Period:(NSNumber *)period {
    gameidentifier = gameid;
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *urlstring;
    
    if (athlete_id)
        urlstring = [NSString stringWithFormat:@"%@/sports/%@/athletes/%@/waterpolo_stats/%@.json?auth_token=%@",
                     [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"], currentSettings.sport.id, athlete_id, waterpolo_stat_id,
                     currentSettings.user.authtoken];
    else {
        VisitingTeam *visitors = [currentSettings findVisitingTeam:[currentSettings findGame:gameid].water_polo_game.visiting_team_id];
        
        urlstring = [NSString stringWithFormat:@"%@/sports/%@/visiting_teams/%@/visitor_roster/%@/waterpolo_stats/%@.json?auth_token=%@",
                     [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"], currentSettings.sport.id, visitors.visiting_team_id, visitor_roster_id,
                     waterpolo_stat_id, currentSettings.user.authtoken];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WaterpoloStatNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSError *jsonSerializationError = nil;
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:&jsonSerializationError];
    NSLog(@"%@", serverData);
    
    if (responseStatusCode == 200) {
        if (waterpolo_stat_id)
            [self parseDictionary:serverData];
        else
            [[[EazesportzRetrievePlayers alloc] init] getAthleteSynchronous:currentSettings.sport.id Team:currentSettings.team.teamid Athlete:athlete_id];
        
        [[[EazesportzGetGame alloc] init] getGameSynchronous:currentSettings.sport Team:currentSettings.team Game:gameidentifier User:currentSettings.user];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WaterpoloStatNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WaterpoloStatNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Save Error", @"Result", nil]];
    }
}

@end
