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

@synthesize home_1stperiod_timeouts;
@synthesize home_2ndperiod_timeouts;
@synthesize visitor_1stperiod_timeouts;
@synthesize visitor_2ndperiod_timeouts;

@synthesize gameschedule_id;
@synthesize lacross_game_id;

@synthesize visiting_team_id;

- (id)initWithDictionary:(NSDictionary *)lacross_game_dictionary {
    if ((self = [super init]) && (lacross_game_dictionary.count > 0)) {
        NSDictionary *dictionary;
        
        gameschedule_id = [lacross_game_dictionary objectForKey:@"gameschedule_id"];
        lacross_game_id = [lacross_game_dictionary objectForKey:@"lacross_game_id"];
        
        clears = [lacross_game_dictionary objectForKey:@"clears"];
        failedclears = [lacross_game_dictionary objectForKey:@"failedclears"];
        visitor_clears = [lacross_game_dictionary objectForKey:@"visitor_clears"];
        visitor_badclears = [lacross_game_dictionary objectForKey:@"visitor_badclears"];
        
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
        
        return self;
    } else {
        return nil;
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

@end
