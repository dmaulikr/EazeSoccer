//
//  LacrossPlayerStat.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/22/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "LacrossPlayerStat.h"

@implementation LacrossPlayerStat

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

@synthesize httperror;

- (id)init {
    if (self = [super init]) {
        
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)lacross_player_stat_dictionary {
    shot = [lacross_player_stat_dictionary objectForKey:@"shot"];
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
                                        @"/sports/", sport.id, @"/teams/", team.teamid, @"/gameschedules/", game.id, @"/lacrosse_score_entry.json?auth_token=",
                                        user.authtoken]];
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:face_off_won, @"face_off_won", face_off_lost, @"face_off_lost",
                                face_off_violation, @"face_off_violation", period, @"period", ground_ball, @"ground_ball", interception, @"interception",
                                turnover, @"turnover", caused_turnover, @"caused_turnover", steals, @"steals", nil];
    
    if (lacross_player_stat_id.length > 0) {
        [dictionary setValue:lacross_player_stat_id forKeyPath:@"lacross_player_stat_id"];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:dictionary, @"gameschedule", nil];
    
    NSError *jsonSerializationError = nil;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (lacrosstat_id.length > 0) {
        [request setHTTPMethod:@"PUT"];
    } else {
        [request setHTTPMethod:@"POST"];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
    
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
    NSDictionary *items = [serverData objectForKey:@"lacrosse_scoring"];
    
    if ([httpResponse statusCode] == 200) {
        
        if (lacrosstat_id.length == 0) {
            lacrosstat_id = [items objectForKey:@"_id"];
        }
    } else {
        httperror = [items objectForKey:@"error"];
    }
}

@end
