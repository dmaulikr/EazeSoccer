//
//  LacrossGame.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "LacrossGame.h"
#import "EazesportzAppDelegate.h"

@implementation LacrossGame

@synthesize clears;
@synthesize failedclears;
@synthesize visitor_clears;
@synthesize visitor_badclears;

@synthesize extraman_fail;
@synthesize visitor_extraman_fail;

@synthesize free_position_sog;

@synthesize homepenaltybox;
@synthesize visitorpenaltybox;

@synthesize home_penaltyone_number;
@synthesize home_penaltyone_minutes;
@synthesize home_penaltyone_seconds;
@synthesize home_penaltytwo_number;
@synthesize home_penaltytwo_minutes;
@synthesize home_penaltytwo_seconds;
@synthesize visitor_penaltyone_number;
@synthesize visitor_penaltyone_minutes;
@synthesize visitor_penaltyone_seconds;
@synthesize visitor_penaltytwo_number;
@synthesize visitor_penaltytwo_minutes;
@synthesize visitor_penaltytwo_seconds;

@synthesize home_1stperiod_timeouts;
@synthesize home_2ndperiod_timeouts;
@synthesize visitor_1stperiod_timeouts;
@synthesize visitor_2ndperiod_timeouts;

@synthesize visitor_score_period1;
@synthesize visitor_score_period2;
@synthesize visitor_score_period3;
@synthesize visitor_score_period4;
@synthesize visitor_score_periodOT1;

@synthesize gameschedule_id;
@synthesize lacross_game_id;

@synthesize visiting_team_id;

- (id)initWithDictionary:(NSDictionary *)lacross_game_dictionary {
    if ((self = [super init]) && (lacross_game_dictionary.count > 0)) {
        NSDictionary *dictionary;
        
        gameschedule_id = [lacross_game_dictionary objectForKey:@"gameschedule_id"];
        lacross_game_id = [lacross_game_dictionary objectForKey:@"lacross_game_id"];
        
        dictionary = [lacross_game_dictionary objectForKey:@"clears"];
        clears = [dictionary mutableCopy];
        dictionary = [lacross_game_dictionary objectForKey:@"failedclears"];
        failedclears = [dictionary mutableCopy];
        dictionary = [lacross_game_dictionary objectForKey:@"visitor_clears"];
        visitor_clears = [dictionary mutableCopy];
        dictionary = [lacross_game_dictionary objectForKey:@"visitor_failedclears"];
        visitor_badclears = [dictionary mutableCopy];
        
        dictionary = [lacross_game_dictionary objectForKey:@"extraman_fail"];
        extraman_fail = [dictionary mutableCopy];
        dictionary = [lacross_game_dictionary objectForKey:@"visitor_extraman_fail"];
        visitor_extraman_fail = [dictionary mutableCopy];
        
        free_position_sog = [lacross_game_dictionary objectForKey:@"free_position_sog"];
        
        homepenaltybox = [lacross_game_dictionary objectForKey:@"homepenaltybox"];
        visitorpenaltybox = [lacross_game_dictionary objectForKey:@"visitorpenaltybox"];
        
        dictionary = [lacross_game_dictionary objectForKey:@"home_1stperiod_timeouts"];
        home_1stperiod_timeouts = [dictionary mutableCopy];
        dictionary = [lacross_game_dictionary objectForKey:@"home_2ndperiod_timeouts"];
        home_2ndperiod_timeouts = [dictionary mutableCopy];
        dictionary = [lacross_game_dictionary objectForKey:@"visitor_1stperiod_timeouts"];
        visitor_1stperiod_timeouts = [dictionary mutableCopy];
        dictionary = [lacross_game_dictionary objectForKey:@"visitor_2ndperiod_timeouts"];
        visitor_2ndperiod_timeouts = [dictionary mutableCopy];
        
        visiting_team_id = [lacross_game_dictionary objectForKey:@"visiting_team_id"];
        
        home_penaltyone_number = [lacross_game_dictionary objectForKey:@"home_penaltyone_number"];
        home_penaltyone_minutes = [lacross_game_dictionary objectForKey:@"home_penaltyone_minutes"];
        home_penaltyone_seconds = [lacross_game_dictionary objectForKey:@"home_penaltyone_seconds"];
        home_penaltytwo_number = [lacross_game_dictionary objectForKey:@"home_penaltytwo_number"];
        home_penaltytwo_minutes = [lacross_game_dictionary objectForKey:@"home_penaltytwo_minutes"];
        home_penaltytwo_seconds = [lacross_game_dictionary objectForKey:@"home_penaltytwo_seconds"];
        visitor_penaltyone_number = [lacross_game_dictionary objectForKey:@"visitor_penaltyone_number"];
        visitor_penaltyone_minutes = [lacross_game_dictionary objectForKey:@"visitor_penaltyone_minutes"];
        visitor_penaltyone_seconds = [lacross_game_dictionary objectForKey:@"visitor_penaltyone_seconds"];
        visitor_penaltytwo_number = [lacross_game_dictionary objectForKey:@"visitor_penaltytwo_number"];
        visitor_penaltytwo_minutes = [lacross_game_dictionary objectForKey:@"visitor_penaltytwo_minutes"];
        visitor_penaltytwo_seconds = [lacross_game_dictionary objectForKey:@"visitor_penaltytwo_seconds"];
        
        visitor_score_period1 = [lacross_game_dictionary objectForKey:@"visitor_score_period1"];
        visitor_score_period2 = [lacross_game_dictionary objectForKey:@"visitor_score_period2"];
        visitor_score_period3 = [lacross_game_dictionary objectForKey:@"visitor_score_period3"];
        visitor_score_period4 = [lacross_game_dictionary objectForKey:@"visitor_score_period4"];
        visitor_score_periodOT1 = [lacross_game_dictionary objectForKey:@"visitor_score_periodOT1"];
                                   
        
        return self;
    } else {
        return nil;
    }
}

- (BOOL)save {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *aurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",[mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/teams/", currentSettings.team.teamid, @"/gameschedules/",
                                        [[currentSettings findGame:gameschedule_id] id], @"/update_lacrosse_game_summary.json?auth_token=",
                                        currentSettings.user.authtoken]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [home_penaltyone_number stringValue], @"homeonenumber",
                                       [home_penaltyone_minutes stringValue], @"homeoneminutes",
                                       [home_penaltyone_seconds stringValue], @"homeoneseconds",
                                       [home_penaltytwo_number stringValue], @"hometwonumber",
                                       [home_penaltytwo_minutes stringValue], @"hometwominutes",
                                       [home_penaltytwo_seconds stringValue], @"hometwoseconds",
                                       [visitor_penaltyone_number stringValue], @"visitoronenumber",
                                       [visitor_penaltyone_minutes stringValue], @"visitoroneminutes",
                                       [visitor_penaltyone_seconds stringValue], @"visitoroneseconds",
                                       [visitor_penaltytwo_number stringValue], @"visitortwonumber",
                                       [visitor_penaltytwo_minutes stringValue], @"visitortwominutes",
                                       [visitor_penaltytwo_seconds stringValue], @"visitortwoseconds",
                                       [visitor_score_period1 stringValue], @"visitor_score_period1",
                                       [visitor_score_period2 stringValue], @"visitor_score_period2",
                                       [visitor_score_period3 stringValue], @"visitor_score_period3",
                                       [visitor_score_period4 stringValue], @"visitor_score_period4",
                                       [visitor_score_periodOT1 stringValue], @"visitor_score_periodOT1",
                                       nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
    //    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:dictionary, @"gameschedule", nil];
    
    NSError *jsonSerializationError = nil;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    
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
    NSDictionary *items = [serverData objectForKey:@"lacross_game"];
    
    if ([httpResponse statusCode] == 200) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)saveHomeTimeouts {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *aurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",[mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/teams/", currentSettings.team.teamid, @"/gameschedules/",
                                        [[currentSettings findGame:gameschedule_id] id], @"/lacrosstimeout.json?auth_token=",
                                        currentSettings.user.authtoken]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Home", @"home", nil];
    
    for (int i = 1; i < 4; i++) {
        NSString *thetimeout = home_1stperiod_timeouts[i-1];
        
        if (thetimeout.length > 1) {
            NSArray *timeout = [home_1stperiod_timeouts[i-1] componentsSeparatedByString:@":"];
            [dictionary setValue:timeout[0] forKey:[NSString stringWithFormat:@"firsttimeout_minutes%d", i]];
            [dictionary setValue:timeout[1] forKey:[NSString stringWithFormat:@"firsttimeout_seconds%d", i]];
        } else {
            [dictionary setValue:@"" forKey:[NSString stringWithFormat:@"firsttimeout_minutes%d", i]];
            [dictionary setValue:@"" forKey:[NSString stringWithFormat:@"firsttimeout_seconds%d", i]];
        }
    }
    
    for (int i = 1; i < 4; i++) {
        NSString *thetimeout = home_1stperiod_timeouts[i-1];
        
        if (thetimeout.length > 1) {
            NSArray *timeout = [home_2ndperiod_timeouts[i-1] componentsSeparatedByString:@":"];
            [dictionary setValue:timeout[0] forKey:[NSString stringWithFormat:@"secondtimeout_minutes%d", i]];
            [dictionary setValue:timeout[1] forKey:[NSString stringWithFormat:@"secondtimeout_seconds%d", i]];
        } else {
            [dictionary setValue:@"" forKey:[NSString stringWithFormat:@"secondtimeout_minutes%d", i]];
            [dictionary setValue:@"" forKey:[NSString stringWithFormat:@"secondtimeout_seconds%d", i]];
        }
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
    //    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:dictionary, @"gameschedule", nil];
    
    NSError *jsonSerializationError = nil;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    
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
    NSDictionary *items = [serverData objectForKey:@"lacross_game"];
    
    if ([httpResponse statusCode] == 200) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)saveVisitorTimeouts {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *aurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",[mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/teams/", currentSettings.team.teamid, @"/gameschedules/",
                                        [[currentSettings findGame:gameschedule_id] id], @"/lacrosstimeout.json?auth_token=",
                                        currentSettings.user.authtoken]];

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Visitor", @"home", nil];
    
    for (int i = 1; i < 4; i++) {
        NSString *thetimeout = home_1stperiod_timeouts[i-1];
        
        if (thetimeout.length > 0) {
            NSArray *timeout = [home_1stperiod_timeouts[i-1] componentsSeparatedByString:@":"];
            [dictionary setValue:timeout[0] forKey:[NSString stringWithFormat:@"firsttimeout_minutes%d", i]];
            [dictionary setValue:timeout[1] forKey:[NSString stringWithFormat:@"firsttimeout_seconds%d", i]];
        } else {
            [dictionary setValue:@"" forKey:[NSString stringWithFormat:@"firsttimeout_minutes%d", i]];
            [dictionary setValue:@"" forKey:[NSString stringWithFormat:@"firsttimeout_seconds%d", i]];
        }
    }
    
    for (int i = 1; i < 4; i++) {
        NSString *thetimeout = home_1stperiod_timeouts[i-1];
        
        if (thetimeout.length > 0) {
            NSArray *timeout = [home_2ndperiod_timeouts[i-1] componentsSeparatedByString:@":"];
            [dictionary setValue:timeout[0] forKey:[NSString stringWithFormat:@"secondtimeout_minutes%d", i]];
            [dictionary setValue:timeout[1] forKey:[NSString stringWithFormat:@"secondtimeout_seconds%d", i]];
        } else {
            [dictionary setValue:@"" forKey:[NSString stringWithFormat:@"secondtimeout_minutes%d", i]];
            [dictionary setValue:@"" forKey:[NSString stringWithFormat:@"secondtimeout_seconds%d", i]];
        }
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
    //    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:dictionary, @"gameschedule", nil];
    
    NSError *jsonSerializationError = nil;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    
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
    NSDictionary *items = [serverData objectForKey:@"lacross_game"];
    
    if ([httpResponse statusCode] == 200) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)saveExtraManFails:(NSString *)home {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *aurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",[mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/teams/", currentSettings.team.teamid, @"/gameschedules/",
                                        [[currentSettings findGame:gameschedule_id] id], @"/lacrosse_extra_man.json?auth_token=",
                                        currentSettings.user.authtoken]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:home, @"home", nil];
    
    if ([home isEqualToString:@"Home"]) {
        [dictionary setValue:[extraman_fail[0] stringValue] forKey:@"xman1"];
        [dictionary setValue:[extraman_fail[1] stringValue] forKey:@"xman2"];
        [dictionary setValue:[extraman_fail[2] stringValue] forKey:@"xman3"];
        [dictionary setValue:[extraman_fail[3] stringValue] forKey:@"xman4"];
        [dictionary setValue:[extraman_fail[4] stringValue] forKey:@"xman5"];
    } else {
        [dictionary setValue:[visitor_extraman_fail[0] stringValue] forKey:@"xman1"];
        [dictionary setValue:[visitor_extraman_fail[1] stringValue] forKey:@"xman2"];
        [dictionary setValue:[visitor_extraman_fail[2] stringValue] forKey:@"xman3"];
        [dictionary setValue:[visitor_extraman_fail[3] stringValue] forKey:@"xman4"];
        [dictionary setValue:[visitor_extraman_fail[4] stringValue] forKey:@"xman5"];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
    //    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:dictionary, @"gameschedule", nil];
    
    NSError *jsonSerializationError = nil;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    
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
    NSDictionary *items = [serverData objectForKey:@"lacross_game"];
    
    if ([httpResponse statusCode] == 200) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)saveClears:(NSString *)home {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *aurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",[mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/teams/", currentSettings.team.teamid, @"/gameschedules/",
                                        [[currentSettings findGame:gameschedule_id] id], @"/lacrosse_clears.json?auth_token=",
                                        currentSettings.user.authtoken]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:home, @"home", nil];
    
    if ([home isEqualToString:@"Home"]) {
        for (int i = 0; i < 5; i++) {
            [dictionary setValue:[[clears objectAtIndex:i] stringValue] forKey:[NSString stringWithFormat:@"clear%d", i + 1]];
        }
        for (int i = 0; i < 5; i++) {
            [dictionary setValue:[[failedclears objectAtIndex:i] stringValue] forKey:[NSString stringWithFormat:@"failedclear%d", i + 1]];
        }
    } else {
        for (int i = 0; i < 5; i++) {
            [dictionary setValue:[[visitor_clears objectAtIndex:i] stringValue] forKey:[NSString stringWithFormat:@"clear%d", i + 1]];
        }
        for (int i = 0; i < 5; i++) {
            [dictionary setValue:[[visitor_badclears objectAtIndex:i] stringValue] forKey:[NSString stringWithFormat:@"failedclear%d", i + 1]];
        }
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
    //    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:dictionary, @"gameschedule", nil];
    
    NSError *jsonSerializationError = nil;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    
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
    NSDictionary *items = [serverData objectForKey:@"lacross_game"];
    
    if ([httpResponse statusCode] == 200) {
        return YES;
    } else {
        return NO;
    }
}

- (NSArray *)getLacrosseScores:(BOOL)home {
    NSMutableArray *gamescoreings = [[NSMutableArray alloc] init];
    GameSchedule *game = [currentSettings findGame:gameschedule_id];
    
    if (home) {
        for (int i = 0; i < currentSettings.roster.count; i++) {
            Lacrosstat *astat = [[currentSettings.roster objectAtIndex:i] findLacrosstat:game];
            
            if (astat.scoring_stats.count > 0) {
                for (int cnt = 0; cnt < astat.scoring_stats.count; cnt++) {
                    [gamescoreings addObject:[astat.scoring_stats objectAtIndex:cnt]];
                }
            }
        }
    } else if ((!home) && (visiting_team_id.length > 0)) {
        VisitingTeam *visitors = [currentSettings findVisitingTeam:game.lacross_game.visiting_team_id];
        
        for (int i = 0; i < visitors.visitor_roster.count; i++) {
            Lacrosstat *astat = [[visitors.visitor_roster objectAtIndex:i] findLacrossStat:game];
            
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

- (NSArray *)getLacrossePenalties:(BOOL)home {
    NSMutableArray *gamepenalties = [[NSMutableArray alloc] init];
    GameSchedule *game = [currentSettings findGame:gameschedule_id];
    
    if (home) {
        for (int i = 0; i < currentSettings.roster.count; i++) {
            Lacrosstat *astat = [[currentSettings.roster objectAtIndex:i] findLacrosstat:game];
            if (astat.penalty_stats.count > 0) {
                for (int cnt = 0; cnt < astat.penalty_stats.count; cnt++)
                    [gamepenalties addObject:[astat.penalty_stats objectAtIndex:cnt]];
            }
        }
    } else if ((!home) && (visiting_team_id.length > 0)) {
        VisitingTeam *visitors = [currentSettings findVisitingTeam:game.lacross_game.visiting_team_id];
        
        for (int i = 0; i < visitors.visitor_roster.count; i++) {
            Lacrosstat *astat = [[visitors.visitor_roster objectAtIndex:i] findLacrossStat:game];
            
            if (astat) {
                if (astat.penalty_stats.count > 0) {
                    for (int cnt = 0; cnt < astat.penalty_stats.count; cnt++)
                        [gamepenalties addObject:[astat.penalty_stats objectAtIndex:cnt]];
                }
            }
        }
    }
    
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"period" ascending:YES];
    NSSortDescriptor *secondDescriptor = [[NSSortDescriptor alloc] initWithKey:@"gametime" ascending:NO
                                                    selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *descriptors = [NSArray arrayWithObjects:firstDescriptor, secondDescriptor, nil];
    [gamepenalties sortedArrayUsingDescriptors:descriptors];
    
    return gamepenalties;
}

- (NSString *)findScoreLog:(NSString *)scorelogid {
    NSString *scorelog;
    GameSchedule *game = [currentSettings findGame:gameschedule_id];
    
    if ([currentSettings.sport.name isEqualToString:@"Lacrosse"]) {
        for (int i = 0; i < currentSettings.roster.count; i++) {
            Lacrosstat *lacrosstat = [[currentSettings.roster objectAtIndex:i] findLacrosstat:game];
            
            for (int cnt = 0; cnt < lacrosstat.scoring_stats.count; cnt++) {
                
                if ([[[lacrosstat.scoring_stats objectAtIndex:cnt] lacross_scoring_id] isEqualToString:scorelogid]) {
                    LacrossScoring *scorestat = [lacrosstat.scoring_stats objectAtIndex:cnt];
                    scorelog = [scorestat getScoreLog];
                    goto Done;
                }
                
            }
            
        }
    }
    
Done:
    return scorelog;
}

- (NSNumber *)computeVisitorTotal {
    return [NSNumber numberWithInt:([visitor_score_period1 intValue] + [visitor_score_period2 intValue] + [visitor_score_period3 intValue] +
                                    [visitor_score_period4 intValue] + [visitor_score_periodOT1 intValue])];
}

@end
