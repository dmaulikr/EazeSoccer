//
//  EazessportzRetrieveDefenseGameStats.m
//  EazeSportz
//
//  Created by Gil on 1/19/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzRetrieveFootballDefenseGameStats.h"
#import "EazesportzAppDelegate.h"

@implementation EazesportzRetrieveFootballDefenseGameStats {
    int responseStatusCode;
    NSDictionary *serverData;
    NSMutableData *theData;
    
    NSURLRequest *originalRequest;
}

@synthesize defense;
@synthesize totals;

- (void)retrieveFootballDefenseStats:(NSString *)sportid Team:(NSString *)teamid Game:(NSString *)gameid {
    defense = [[NSMutableArray alloc] init];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                       @"/sports/", currentSettings.sport.id, @"/teams/", currentSettings.team.teamid, @"/gameschedules/", gameid,
                                       @"/defensegamestats.json"]];
    
    originalRequest = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc] initWithRequest:originalRequest delegate:self];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DefenseGameStatsNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result" , nil]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    
    if (responseStatusCode == 200) {
        defense = [[NSMutableArray alloc] init];
        
        NSLog(@"%@", serverData);
        NSArray *keyArray =  [serverData allKeys];
        int count = [keyArray count];
        
        for (int i=0; i < count; i++) {
            if ([[keyArray objectAtIndex:i] isEqualToString:@"defensivetotals"]) {
                totals = [[FootballDefenseStats alloc] initWithDictionary:[serverData objectForKey:@"defensivetotals"]];
            } else {
                [defense addObject:[[FootballDefenseStats alloc] initWithDictionary:[serverData objectForKey:[ keyArray objectAtIndex:i]]]];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DefenseGameStatsNotification" object:nil                                                              userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DefenseGameStatsNotification" object:nil
                                        userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error Retrieving Defensive Game Stats", @"Result" , nil]];
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    if (redirectResponse) {
        NSMutableURLRequest *newrequest = [originalRequest mutableCopy];
        [newrequest setURL:[request URL]];
        return  newrequest;
    } else {
        return request;
    }
}

@end
