//
//  LacrossPenalty.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/22/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "LacrossPenalty.h"

@implementation LacrossPenalty {
    int responseStatusCode;
    NSMutableData *theData;
}

@synthesize infraction;
@synthesize type;
@synthesize gametime;
@synthesize period;

@synthesize lacrosstat_id;
@synthesize lacross_penalty_id;
@synthesize athlete_id;
@synthesize visitor_roster_id;

@synthesize httperror;

- (id)init {
    if (self = [super init]) {
        infraction = @"";
        type = @"";
        gametime = @"00:00";
        return self;
    } else
        return nil;
}

- (id)initWithDictionary:(NSDictionary *)lacross_penalty_dictionary {
    if (self = [super init]) {
        infraction = [lacross_penalty_dictionary objectForKey:@"infraction"];
        type = [lacross_penalty_dictionary objectForKey:@"type"];
        gametime = [lacross_penalty_dictionary objectForKey:@"gametime"];
        period = [lacross_penalty_dictionary objectForKey:@"period"];
        
        lacross_penalty_id = [lacross_penalty_dictionary objectForKey:@"lacross_penalty_id"];
        lacrosstat_id = [lacross_penalty_dictionary objectForKey:@"lacrosstat_id"];
        athlete_id = [lacross_penalty_dictionary objectForKey:@"athlete_id"];
        visitor_roster_id = [lacross_penalty_dictionary objectForKey:@"visitor_roster_id"];
        
        return self;
    } else
        return nil;
}

- (void)save:(Sport *)sport Team:(Team *)team Gameschedule:(GameSchedule *)game User:(User *)user {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *aurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@",[mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", sport.id, @"/teams/", team.teamid, @"/gameschedules/", game.id, @"/lacrosse_add_penalty.json?auth_token=", user.authtoken, @"&player=", athlete_id]];
    
    NSArray *timearray = [gametime componentsSeparatedByString:@":"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:timearray[0], @"minutes", timearray[1], @"seconds",
                                       type, @"type", period, @"period", nil];
    
    if ([type isEqualToString:@"T"])
        [dictionary setValue:infraction forKeyPath:@"technical"];
    else
        [dictionary setValue:infraction forKeyPath:@"personal"];
    
    if (lacross_penalty_id.length > 0) {
        [dictionary setValue:lacross_penalty_id forKeyPath:@"lacross_penalty_id"];
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

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    responseStatusCode = [httpResponse statusCode];
    theData = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [theData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LacrossePenaltyStatNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSError *jsonSerializationError = nil;
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:&jsonSerializationError];
    NSDictionary *items = [serverData objectForKey:@"lacross_penalty"];
    
    if (responseStatusCode == 200) {
        if (lacross_penalty_id.length == 0) {
            lacross_penalty_id = [items objectForKey:@"_id"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LacrossePenaltyStatNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LacrossePenaltyStatNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Save Error", @"Result", nil]];
    }
}

@end
