//
//  LacrossGoalstat.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/22/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "LacrossGoalstat.h"

@implementation LacrossGoalstat {
    int responseStatusCode;
    NSMutableData *theData;
}

@synthesize saves;
@synthesize goals_allowed;
@synthesize minutesplayed;
@synthesize period;

@synthesize lacrosstat_id;
@synthesize lacross_goalstat_id;
@synthesize athlete_id;
@synthesize visitor_roster_id;

@synthesize dirty;

- (id)init {
    if (self = [super init]) {
        goals_allowed = [NSNumber numberWithInt:0];
        minutesplayed = [NSNumber numberWithInt:0];
        period = [NSNumber numberWithInt:0];
        saves = [NSNumber numberWithInt:0];
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)lacross_goalstat_dictionary {
    if (self = [super init]) {
        saves = [lacross_goalstat_dictionary objectForKey:@"saves"];
        goals_allowed = [lacross_goalstat_dictionary objectForKey:@"goals_allowed"];
        minutesplayed = [lacross_goalstat_dictionary objectForKey:@"minutesplayed"];
        period = [lacross_goalstat_dictionary objectForKey:@"period"];
        
        lacross_goalstat_id = [lacross_goalstat_dictionary objectForKey:@"lacross_goalstat_id"];
        lacrosstat_id = [lacross_goalstat_dictionary objectForKey:@"lacrosstat_id"];
        athlete_id = [lacross_goalstat_dictionary objectForKey:@"athlete_id"];
        visitor_roster_id = [lacross_goalstat_dictionary objectForKey:@"visitor_roster_id"];
        
        return self;
    } else
        return nil;
}

- (void)save:(Sport *)sport Team:(Team *)team Game:(GameSchedule *)game User:(User *)user {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *aurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",[mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", sport.id, @"/teams/", team.teamid, @"/gameschedules/", game.id,
                                        @"/lacrosse_goalstats.json?auth_token=", user.authtoken]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:goals_allowed, @"goals_allowed",
                                       saves, @"saves", minutesplayed, @"minutesplayed", [period stringValue], @"period", nil];
    
    if (lacross_goalstat_id.length > 0) {
        [dictionary setValue:lacross_goalstat_id forKeyPath:@"lacross_goalstat_id"];
    }
    
    if (athlete_id.length > 0) {
        [dictionary setValue:@"Home" forKey:@"home"];
        [dictionary setValue:athlete_id forKey:@"player"];
    } else {
        [dictionary setValue:@"Visitor" forKey:@"home"];
        [dictionary setValue:visitor_roster_id forKey:@"player"];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LacrosseGoalieStatNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSError *jsonSerializationError = nil;
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:&jsonSerializationError];
    NSLog(@"%@", serverData);
    NSDictionary *items = [serverData objectForKey:@"lacross_player_stat"];
    
    if (responseStatusCode == 200) {
        if (lacross_goalstat_id.length == 0) {
            lacross_goalstat_id = [items objectForKey:@"_id"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LacrosseGoalieStatNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LacrosseGoalieStatNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Save Error", @"Result", nil]];
    }
}

@end
