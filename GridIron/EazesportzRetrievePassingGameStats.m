//
//  EazesportzRetrievePassingGameStats.m
//  EazeSportz
//
//  Created by Gil on 1/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzRetrievePassingGameStats.h"
#import "EazesportzAppDelegate.h"

@implementation EazesportzRetrievePassingGameStats {
    int responseStatusCode;
    NSDictionary *serverData;
    NSMutableData *theData;
    
    NSURLRequest *originalRequest;
}

@synthesize passing;
@synthesize totals;

- (void)retrieveFootballPassingStats:(NSString *)sportid Team:(NSString *)teamid Game:(NSString *)gameid {
    passing = [[NSMutableArray alloc] init];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                       @"/sports/", currentSettings.sport.id, @"/teams/", currentSettings.team.teamid, @"/gameschedules/", gameid,
                                       @"/passinggamestats.json"]];
    
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
    
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The download cound not complete - please make sure you're connected to either 3G or WI-FI" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    
    if (responseStatusCode == 200) {
        passing = [[NSMutableArray alloc] init];
        
        NSLog(@"%@", serverData);
        NSArray *keyArray =  [serverData allKeys];
        int count = [keyArray count];
        
        for (int i=0; i < count; i++) {
            if ([[keyArray objectAtIndex:i] isEqualToString:@"passingtotals"]) {
                totals = [[FootballPassingStat alloc] initWithDictionary:[serverData objectForKey:@"passingtotals"]];
            } else {
                [passing addObject:[[FootballPassingStat alloc] initWithDictionary:[serverData objectForKey:[ keyArray objectAtIndex:i]]]];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PassingGameStatsNotification" object:nil                                                              userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PassingGameStatsNotification" object:nil
                                            userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error Retrieving Passing Stats", @"Result" , nil]];
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
