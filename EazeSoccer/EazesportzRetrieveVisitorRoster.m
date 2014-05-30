//
//  EazesportzRetrieveVisitorRoster.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/26/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzRetrieveVisitorRoster.h"

@implementation EazesportzRetrieveVisitorRoster {
    long responseStatusCode;
    NSMutableArray *serverData;
    NSMutableData *theData;
}

@synthesize visitorRoster;

- (void)retrieveVisitorRoster:(Sport *)sport VisitingTeam:(VisitingTeam *)visitingTeam User:(User *)user {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", sport.id, @"/visiting_teams/", visitingTeam.visiting_team_id, @"/visitor_rosters.json"]];
    
    [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    responseStatusCode = [httpResponse statusCode];
    theData = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [theData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VisitorRosterListChangedNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    
    if (responseStatusCode == 200) {
        visitorRoster =[[NSMutableArray alloc] init];
        
        for (int i = 0; i < [serverData count]; i++) {
            [visitorRoster addObject:[[VisitorRoster alloc] initWithDictionary:[serverData objectAtIndex:i]]];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VisitorRosterListChangedNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VisitorRosterListChangedNotification" object:nil
                                                userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error Retreving Visitor Roster", @"Result", nil]];
    }
}

@end
