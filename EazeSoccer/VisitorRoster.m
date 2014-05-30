//
//  VisitorRoster.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/23/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "VisitorRoster.h"
#import "EazesportzAppDelegate.h"

@implementation VisitorRoster {
    long responseStatusCode;
    NSMutableArray *serverData;
    NSMutableData *theData;
    
    NSMutableArray *lacross_stats;
    
    BOOL deleteRoster;
}

@synthesize number;
@synthesize lastname;
@synthesize firstname;
@synthesize position;
@synthesize numberlogname;
@synthesize logname;

@synthesize lacrosstat_id;
@synthesize visitor_roster_id;
@synthesize visiting_team_id;

- (id)initWithDictionary:(NSDictionary *)visitorRosterDictionary {
    if (self = [super init]) {
        number = [visitorRosterDictionary objectForKey:@"number"];
        lastname = [visitorRosterDictionary objectForKey:@"lastname"];
        firstname = [visitorRosterDictionary objectForKey:@"firstname"];
        position = [visitorRosterDictionary objectForKey:@"position"];
        numberlogname = [visitorRosterDictionary objectForKey:@"numberlogname"];
        logname = [visitorRosterDictionary objectForKey:@"logname"];
        
        lacrosstat_id = [visitorRosterDictionary objectForKey:@"lacrosstat_id"];
        
        if ([visitorRosterDictionary objectForKey:@"id"])
            visitor_roster_id = [visitorRosterDictionary objectForKey:@"id"];
        else
            visitor_roster_id = [visitorRosterDictionary objectForKey:@"_id"];
        
        visiting_team_id = [visitorRosterDictionary objectForKey:@"visiting_team_id"];
        
        if ([currentSettings.sport.name isEqualToString:@"Lacrosse"]) {
            lacross_stats = [[NSMutableArray alloc] init];
            
            NSDictionary *stats = [visitorRosterDictionary objectForKey:@"lacrosstat"];
            [lacross_stats addObject:[[Lacrosstat alloc] initWithDictionary:stats]];
        }
        
        return self;
    } else
        return nil;
}

- (void)save:(Sport *)sport User:(User *)user {
    NSURL * aurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",
                                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                     @"/sports/", sport.id, @"/visiting_teams/", visiting_team_id, @"/visitor_rosters/", visitor_roster_id,
                                     @".json?auth_token=", user.authtoken]];
    
    NSMutableDictionary *rosterDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:number, @"number", lastname, @"lastname", firstname,
                                     @"firstname", position,  @"position", nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:rosterDict, @"visitor_roster", nil];
    
    NSError *jsonSerializationError = nil;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (visitor_roster_id.length > 0) {
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
    
    if (jsonSerializationError) {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    if (self.visitor_roster_id != nil)
        [request setHTTPMethod:@"PUT"];
    else
        [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:jsonData];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[NSURLConnection alloc] initWithRequest:request  delegate:self];
}

- (void)deleteVisitorRoster:(Sport *)sport User:(User *)user {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                       @"/sports/", sport.id, @"/visiting_teams/", visiting_team_id, @"/visitor_rosters/", visitor_roster_id,
                                       @".json?auth_token=", user.authtoken]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSError *error = nil;
    NSDictionary *jsonDict = [[NSDictionary alloc] init];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&error];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"DELETE"];
    [request setHTTPBody:jsonData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    deleteRoster = YES;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VisitorRosterDeletedNotification" object:nil
                        userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error.", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSDictionary *serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    if (responseStatusCode == 200) {
        if (deleteRoster) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VisitorRosterDeletedNotification" object:nil
                                                              userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
            [self initDelete];
        } else {
            NSDictionary *items = [serverData objectForKey:@"visiting_team"];
            self.visiting_team_id = [items objectForKey:@"_id"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VisitorRosterSavedNotification" object:nil
                                                              userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
        }
        
    } else {
        if (deleteRoster)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VisitorRosterDeletedNotification" object:nil
                                                              userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error", @"Result", nil]];
        else
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VisitorRosterSavedNotification" object:nil
                                                              userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error", @"Result", nil]];
    }
}

- (id)initDelete {
    self = nil;
    return self;
}

- (Lacrosstat *)findLacrossStat:(GameSchedule *)game {
    Lacrosstat *stat;
    
    for (int i = 0; i < lacross_stats.count; i++) {
        if ([[[lacross_stats objectAtIndex:i] lacross_game_id] isEqualToString:game.id]) {
            stat = [lacross_stats objectAtIndex:i];
            break;
        }
    }
    
    return stat;
}

@end
