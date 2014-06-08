//
//  LacrossPlayerStat.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/22/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "LacrossPlayerStat.h"

@implementation LacrossPlayerStat {
    int responseStatusCode;
    NSMutableData *theData;
}

@synthesize shot;

@synthesize face_off_won;
@synthesize face_off_lost;
@synthesize face_off_violation;

@synthesize ground_ball;
@synthesize interception;

@synthesize turnover;
@synthesize caused_turnover;

@synthesize steals;
@synthesize period;

@synthesize lacross_player_stat_id;
@synthesize lacrosstat_id;
@synthesize athlete_id;
@synthesize visitor_roster_id;

@synthesize dirty;

@synthesize httperror;

- (id)init {
    if (self = [super init]) {
        shot = [[NSMutableArray alloc] init];
        face_off_won = [NSNumber numberWithInt:0];
        face_off_lost = [NSNumber numberWithInt:0];
        face_off_violation = [NSNumber numberWithInt:0];
        ground_ball = [NSNumber numberWithInt:0];
        interception = [NSNumber numberWithInt:0];
        turnover = [NSNumber numberWithInt:0];
        caused_turnover = [NSNumber numberWithInt:0];
        steals = [NSNumber numberWithInt:0];
        period = [NSNumber numberWithInt:0];
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)lacross_player_stat_dictionary {
    NSDictionary *dictionary;
    dictionary = [lacross_player_stat_dictionary objectForKey:@"shot"];
    shot = [dictionary mutableCopy];
    face_off_won = [lacross_player_stat_dictionary objectForKey:@"face_off_won"];
    face_off_lost = [lacross_player_stat_dictionary objectForKey:@"face_off_lost"];
    face_off_violation = [lacross_player_stat_dictionary objectForKey:@"face_off_lost"];
    ground_ball = [lacross_player_stat_dictionary objectForKey:@"ground_ball"];
    interception = [lacross_player_stat_dictionary objectForKey:@"interception"];
    turnover = [lacross_player_stat_dictionary objectForKey:@"turnover"];
    caused_turnover = [lacross_player_stat_dictionary objectForKey:@"caused_turnover"];
    steals = [lacross_player_stat_dictionary objectForKey:@"steals"];
    period = [lacross_player_stat_dictionary objectForKey:@"period"];
    
    lacross_player_stat_id = [lacross_player_stat_dictionary objectForKey:@"lacross_player_stat_id"];
    lacrosstat_id = [lacross_player_stat_dictionary objectForKey:@"lacrosstat_id"];
    athlete_id = [lacross_player_stat_dictionary objectForKey:@"athlete_id"];
    visitor_roster_id = [lacross_player_stat_dictionary objectForKey:@"visitor_roster_id"];
    
    if (self = [super init]) {
        return self;
    } else
        return nil;
}

- (void)save:(Sport *)sport Team:(Team *)team Game:(GameSchedule *)game User:(User *)user {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *aurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",[mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", sport.id, @"/teams/", team.teamid, @"/gameschedules/", game.id,
                                        @"/lacrosse_player_stats.json?auth_token=", user.authtoken]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:face_off_won, @"face_off_won", face_off_lost, @"face_off_lost",
                                face_off_violation, @"face_off_violation", period, @"period", ground_ball, @"groundball", interception, @"interception",
                                turnover, @"turnover", caused_turnover, @"caused_turnover", steals, @"steals", lacrosstat_id, @"lacrosstat_id", nil];
    
    if (lacross_player_stat_id.length > 0) {
        [dictionary setValue:lacross_player_stat_id forKeyPath:@"lacross_player_stat_id"];
    }
    
    if (athlete_id.length > 0) {
        [dictionary setValue:@"Home" forKey:@"home"];
        [dictionary setValue:athlete_id forKey:@"player"];
    } else {
        [dictionary setValue:@"Visitor" forKey:@"home"];
        [dictionary setValue:visitor_roster_id forKey:@"player"];
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
    [[NSURLConnection alloc] initWithRequest:request  delegate:self];
}

- (void)saveShot:(Sport *)sport Team:(Team *)team Game:(GameSchedule *)game User:(User *)user Shot:(NSString *)theshot {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *aurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",[mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", sport.id, @"/teams/", team.teamid, @"/gameschedules/", game.id,
                                        @"/lacrosse_add_shot.json?auth_token=", user.authtoken]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:theshot, @"addshot", lacrosstat_id, @"lacrosstat_id",
                                                                                        period, @"period", nil];
    
    if (lacross_player_stat_id.length > 0) {
        [dictionary setValue:lacross_player_stat_id forKeyPath:@"lacross_player_stat_id"];
    }
    
    if (athlete_id.length > 0) {
        [dictionary setValue:@"Home" forKey:@"home"];
        [dictionary setValue:athlete_id forKey:@"player"];
    } else {
        [dictionary setValue:@"Visitor" forKey:@"home"];
        [dictionary setValue:visitor_roster_id forKey:@"player"];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LacrossePlayerStatNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSError *jsonSerializationError = nil;
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:&jsonSerializationError];
    NSLog(@"%@", serverData);
    NSDictionary *items = [serverData objectForKey:@"lacross_player_stat"];
    
    if (responseStatusCode == 200) {
        if (lacross_player_stat_id.length == 0) {
            lacross_player_stat_id = [items objectForKey:@"_id"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LacrossePlayerStatNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LacrossePlayerStatNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Save Error", @"Result", nil]];
    }
}

- (void)deleteshot:(Sport *)sport Team:(Team *)team Game:(GameSchedule *)game User:(User *)user Shot:(NSString *)theshot {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *aurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",[mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", sport.id, @"/teams/", team.teamid, @"/gameschedules/", game.id,
                                        @"/delete_lacrosse_player_shot.json?auth_token=", user.authtoken]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:theshot, @"shot", lacrosstat_id, @"lacrosstat_id",
                                                                                           period, @"period", nil];
    
    if (lacross_player_stat_id.length > 0) {
        [dictionary setValue:lacross_player_stat_id forKeyPath:@"lacross_player_stat_id"];
    }
    
    if (athlete_id.length > 0) {
        [dictionary setValue:@"Home" forKey:@"home"];
        [dictionary setValue:athlete_id forKey:@"player"];
    } else {
        [dictionary setValue:@"Visitor" forKey:@"home"];
        [dictionary setValue:visitor_roster_id forKey:@"player"];
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
    [[NSURLConnection alloc] initWithRequest:request  delegate:self];
}

@end
