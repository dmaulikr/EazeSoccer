//
//  LacrossScoring.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/22/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "LacrossScoring.h"

#import "EazesportzAppDelegate.h"

@implementation LacrossScoring {
    int responseStatusCode;
    NSMutableData *theData;
}

@synthesize scorecodes;

@synthesize gametime;
@synthesize scorecode;
@synthesize assist;
@synthesize period;

@synthesize lacross_scoring_id;
@synthesize lacrosstat_id;
@synthesize athlete_id;
@synthesize visitor_roster_id;

@synthesize httperror;

- (id)init {
    if (self = [super init]) {
        assist = @"";
        gametime = @"00:00";
        scorecode = @"";
        scorecodes = [[NSDictionary alloc] initWithObjectsAndKeys:@"Broken clear resulted in goal", @"B", @"Cutter scored after receiving feed", @"C",
                                                                @"Dodging goal", @"D", @"Fast break goal", @"F", @"Outside shot scored", @"O",
                                                                @"Extra man play scored", @"X", nil];
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)lacross_scoring_dictionary {
    if (self = [super init]) {
        scorecodes = [[NSDictionary alloc] initWithObjectsAndKeys:@"Broken clear resulted in goal", @"B", @"Cutter scored after receiving feed", @"C",
                      @"Dodging goal", @"D", @"Fast break goal", @"F", @"Outside shot scored", @"O", @"Extra man play scored", @"X", nil];

        gametime = [lacross_scoring_dictionary objectForKey:@"gametime"];
        scorecode = [lacross_scoring_dictionary objectForKey:@"scorecode"];
        assist = [lacross_scoring_dictionary objectForKey:@"assist"];
        period = [lacross_scoring_dictionary objectForKey:@"period"];
        
        lacross_scoring_id = [lacross_scoring_dictionary objectForKey:@"lacross_scoring_id"];
        lacrosstat_id = [lacross_scoring_dictionary objectForKey:@"lacrosstat_id"];
        athlete_id = [lacross_scoring_dictionary objectForKey:@"athlete_id"];
        visitor_roster_id = [lacross_scoring_dictionary objectForKey:@"visitor_roster_id"];
        
        return  self;
    } else
        return nil;
}

- (void)save:(Sport *)sport Team:(Team *)team Gameschedule:(GameSchedule *)game User:(User *)user {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *aurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@",[mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                     @"/sports/", sport.id, @"/teams/", team.teamid, @"/gameschedules/", game.id, @"/lacrosse_score_entry.json?auth_token=",
                                     user.authtoken, @"&player=", athlete_id]];
    
    NSArray *timearray = [gametime componentsSeparatedByString:@":"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:timearray[0], @"minutes", timearray[1], @"seconds",
                                                                    scorecode, @"scorecode", period, @"period", assist, @"assist", nil];
    
    if (lacross_scoring_id.length > 0) {
        [dictionary setValue:lacross_scoring_id forKeyPath:@"lacross_scoring_id"];
    }
    
    if (athlete_id.length > 0) {
        [dictionary setValue:@"Home" forKey:@"home"];
    } else {
        [dictionary setValue:@"Visitor" forKey:@"home"];
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

- (BOOL)isExtraManScore {
    if ([scorecodes objectForKey:@"X"])
        return YES;
    else
        return NO;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LacrosseScoringStatNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSError *jsonSerializationError = nil;
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:&jsonSerializationError];
    NSDictionary *items = [serverData objectForKey:@"lacross_scoring"];
    
    if (responseStatusCode == 200) {
        if (lacross_scoring_id.length == 0) {
            lacross_scoring_id = [items objectForKey:@"_id"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LacrosseScoringStatNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LacrosseScoringStatNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Save Error", @"Result", nil]];
    }
}

- (NSString *)getScoreLog {
    NSString *score = [NSString stringWithFormat:@"%@ - %@: %@", [period stringValue], gametime, [[currentSettings findAthlete:athlete_id] numberLogname]];
                       
    if (assist.length > 0)
        score = [score stringByAppendingString:[NSString stringWithFormat:@", Assist: %@", [[currentSettings findAthlete:assist] numberLogname]]];
    
    return score;
}

@end
