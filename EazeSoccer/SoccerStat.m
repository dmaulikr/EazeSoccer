//
//  SoccerStat.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "SoccerStat.h"

#import "EazesportzAppDelegate.h"
#import "EazesportzGetGame.h"
#import "EazesportzRetrievePlayers.h"

@implementation SoccerStat {
    long responseStatusCode;
    NSMutableData *theData;
    NSString *gameidentifier;
}

@synthesize scoring_stats;
@synthesize goalstats;
@synthesize penalty_stats;
@synthesize player_stats;

@synthesize soccer_stat_id;
@synthesize soccer_game_id;
@synthesize athlete_id;
@synthesize visitor_roster_id;

@synthesize player_shots;
@synthesize player_cornerkicks;
@synthesize player_steals;
@synthesize player_fouls;
@synthesize player_assists;
@synthesize player_penalties;
@synthesize player_goals_allowed;
@synthesize player_minutes_played;

@synthesize soccer_scoring;
@synthesize soccer_player_stat;
@synthesize soccer_goalstat;
@synthesize soccer_penalty;

- (id)init {
    if (self = [super init]) {
        scoring_stats = [[NSMutableArray alloc] init];
        goalstats = [[NSMutableArray alloc] init];
        penalty_stats = [[NSMutableArray alloc] init];
        player_stats = [[NSMutableArray alloc] init];
        
        soccer_scoring = @"Scoring";
        soccer_penalty = @"Penalty";
        soccer_player_stat = @"Player Stat";
        soccer_goalstat = @"Goal Stat";
        
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)soccer_dictionary {
    if ((self = [super init]) && (soccer_dictionary.count > 0)) {
        [self parseDictionary:soccer_dictionary];
        return self;
    } else {
        return nil;
    }
}

- (void)parseDictionary:(NSDictionary *)soccer_dictionary {
    athlete_id = [soccer_dictionary objectForKey:@"athlete_id"];
    soccer_game_id = [soccer_dictionary objectForKey:@"soccer_game_id"];
    visitor_roster_id = [soccer_dictionary objectForKey:@"visitor_roster_id"];
    soccer_stat_id = [soccer_dictionary objectForKey:@"soccer_stat_id"];
    
    scoring_stats = [[NSMutableArray alloc] init];
    NSArray *scoringArray = [soccer_dictionary objectForKey:@"soccer_scorings"];
    
    for (int i = 0; i < scoringArray.count; i++) {
        NSDictionary *stats = [scoringArray objectAtIndex:i];
        SoccerScoring *scoring = [[SoccerScoring alloc] initWithDictionary:stats];
        [scoring_stats addObject:scoring];
    }
    
    goalstats = [[NSMutableArray alloc] init];
    NSArray *goalstatsArray = [soccer_dictionary objectForKey:@"soccer_goalstats"];
    
    for (int i = 0; i < goalstatsArray.count; i++) {
        NSDictionary *stats = [goalstatsArray objectAtIndex:i];
        SoccerGoalstat *goalstat = [[SoccerGoalstat alloc] initWithDictionary:stats];
        [goalstats addObject:goalstat];
    }
    
    player_stats = [[NSMutableArray alloc] init];
    NSArray *playerstatsArray = [soccer_dictionary objectForKey:@"soccer_playerstats"];
    
    for (int i = 0; i < playerstatsArray.count; i++) {
        NSDictionary *stats = [playerstatsArray objectAtIndex:i];
        SoccerPlayerStat *stat = [[SoccerPlayerStat alloc] initWithDictionary:stats];
        [player_stats addObject:stat];
    }
    
    penalty_stats = [[NSMutableArray alloc] init];
    NSArray *penaltystatsArray = [soccer_dictionary objectForKey:@"soccer_penalties"];
    
    for (int i = 0; i < penaltystatsArray.count; i++) {
        NSDictionary *stats = [penaltystatsArray objectAtIndex:i];
        SoccerPenalty *stat = [[SoccerPenalty alloc] initWithDictionary:stats];
        [penalty_stats addObject:stat];
    }
    
    soccer_scoring = @"Scoring";
    soccer_penalty = @"Penalty";
    soccer_player_stat = @"Player Stat";
    soccer_goalstat = @"Goal Stat";
}

- (SoccerPlayerStat *)findPlayerStat:(NSNumber *)period {
    SoccerPlayerStat *entry;
    
    for (int i = 0; i < [player_stats count]; i++) {
        if ([[[player_stats objectAtIndex:i] period] isEqual:period]) {
            entry = [player_stats objectAtIndex:i];
        }
    }
    return entry;
}

- (SoccerGoalstat *)findGoalStat:(NSNumber *)period {
    SoccerGoalstat *entry;
    
    for (int i = 0; i < [goalstats count]; i++) {
        if ([[[goalstats objectAtIndex:i] period] isEqual:period]) {
            entry = [goalstats objectAtIndex:i];
        }
    }
    return entry;
}

- (SoccerPenalty *)findPenaltyStat:(NSNumber *)period {
    SoccerPenalty *entry;
    
    for (int i = 0; i < [penalty_stats count]; i++) {
        if ([[[penalty_stats objectAtIndex:i] period] isEqual:period]) {
            entry = [penalty_stats objectAtIndex:i];
        }
    }
    return entry;
}

- (SoccerScoring *)findScoringStat:(NSNumber *)period {
    SoccerScoring *entry;
    
    for (int i = 0; i < [scoring_stats count]; i++) {
        if ([[[scoring_stats objectAtIndex:i] period] isEqual:period]) {
            entry = [scoring_stats objectAtIndex:i];
        }
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

- (NSNumber *)getTotalCornerKicks {
    int cornerkicks = 0;
    
    for (int i = 0; i < player_stats.count; i++) {
        cornerkicks += [[[player_stats objectAtIndex:i] cornerkicks] intValue];
    }
    
    return [NSNumber numberWithInt:cornerkicks];
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
        urlstring = [NSString stringWithFormat:@"%@/sports/%@/athletes/%@/soccer_stats",
                     [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"], currentSettings.sport.id, athlete_id];
    else {
        VisitingTeam *visitors = [currentSettings findVisitingTeam:[currentSettings findGame:gameid].soccer_game.visiting_team_id];
        
        urlstring = [NSString stringWithFormat:@"%@/sports/%@/visiting_teams/%@/visitor_roster/%@/soccer_stats",
                     [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"], currentSettings.sport.id, visitors.visiting_team_id, visitor_roster_id];
    }
    
    [dictionary setValue:soccer_game_id forKey:@"soccer_game_id"];
    
    if (soccer_stat_id)
        urlstring = [urlstring stringByAppendingFormat:@"/%@.json?auth_token=%@", soccer_stat_id, currentSettings.user.authtoken];
    else
        urlstring = [urlstring stringByAppendingFormat:@".json?auth_token=%@", currentSettings.user.authtoken];
    
    NSURL *url = [NSURL URLWithString:urlstring];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    if (soccer_stat_id) {
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

- (void)saveScoreStat:(NSString *)gameid Score:(SoccerScoring *)stat {
    NSMutableDictionary *dictionary = [stat getDictionary];
    [dictionary setValue:@"scorestat" forKey:@"scorestat"];
    [self saveStat:gameid Dictionary:dictionary];
}

- (void)savePlayerStat:(NSString *)gameid PlayerStat:(SoccerPlayerStat *)stat {
    NSMutableDictionary *dictionary = [stat getDictionary];
    [dictionary setValue:@"playerstat" forKey:@"playerstat"];
    [self saveStat:gameid Dictionary:dictionary];
}

- (void)saveGoalStat:(NSString *)gameid GoalStat:(SoccerScoring *)stat {
    NSMutableDictionary *dictionary = [stat getDictionary];
    [dictionary setValue:@"goalstat" forKey:@"goalstat"];
    [self saveStat:gameid Dictionary:dictionary];
}

- (void)savePenaltyStat:(NSString *)gameid PenaltyStat:(SoccerPlayerStat *)stat {
    NSMutableDictionary *dictionary = [stat getDictionary];
    [dictionary setValue:@"penatlystat" forKey:@"panaltystat"];
    [self saveStat:gameid Dictionary:dictionary];
}

- (void)deleteScoreStat:(NSString *)gameid Score:(SoccerScoring *)stat {
    [self deleteStat:gameid Stat:@"soccer_scoring" Id:stat.soccer_scoring_id Period:stat.period];
}

- (void)deletePlayerStat:(NSString *)gameid PlayerStat:(SoccerPlayerStat *)stat {
    [self deleteStat:gameid Stat:@"soccer_playerstat" Id:stat.soccer_playerstat_id Period:stat.period];
}

- (void)deletePenaltyStat:(NSString *)gameid PenaltyStat:(SoccerPenalty *)stat {
    [self deleteStat:gameid Stat:@"soccer_penalty" Id:stat.soccer_penalty_id Period:stat.period];
}

- (void)deleteGoalStat:(NSString *)gameid GoalStat:(SoccerGoalstat *)stat {
    [self deleteStat:gameid Stat:@"soccer_goalstat" Id:stat.soccer_goalstat_id Period:stat.period];
}

- (void)deleteStat:(NSString *)gameid Stat:(NSString *)stattype Id:(NSString *)statid Period:(NSNumber *)period {
    gameidentifier = gameid;
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *urlstring;
    
    if (athlete_id)
        urlstring = [NSString stringWithFormat:@"%@/sports/%@/athletes/%@/soccer_stats/%@.json?auth_token=%@",
                     [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"], currentSettings.sport.id, athlete_id, soccer_stat_id,
                     currentSettings.user.authtoken];
    else {
        VisitingTeam *visitors = [currentSettings findVisitingTeam:[currentSettings findGame:gameid].soccer_game.visiting_team_id];
        
        urlstring = [NSString stringWithFormat:@"%@/sports/%@/visiting_teams/%@/visitor_roster/%@/soccer_stats/%@.json?auth_token=%@",
                     [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"], currentSettings.sport.id, visitors.visiting_team_id, visitor_roster_id,
                     soccer_stat_id, currentSettings.user.authtoken];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SoccerStatNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSError *jsonSerializationError = nil;
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:&jsonSerializationError];
    NSLog(@"%@", serverData);
    
    if (responseStatusCode == 200) {
        if (soccer_stat_id)
            [self parseDictionary:serverData];
        else
            [[[EazesportzRetrievePlayers alloc] init] getAthleteSynchronous:currentSettings.sport.id Team:currentSettings.team.teamid Athlete:athlete_id];
        
        [[[EazesportzGetGame alloc] init] getGameSynchronous:currentSettings.sport Team:currentSettings.team Game:gameidentifier User:currentSettings.user];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SoccerStatNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SoccerStatNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Save Error", @"Result", nil]];
    }
}

@end
