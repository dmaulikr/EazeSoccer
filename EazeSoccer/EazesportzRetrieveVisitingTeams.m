//
//  EazesportzRetrieveVisitingTeams.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/24/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzRetrieveVisitingTeams.h"

@implementation EazesportzRetrieveVisitingTeams {
    long responseStatusCode;
    NSMutableArray *serverData;
    NSMutableData *theData;
}

@synthesize visitingTeams;

- (void)retrieveVisitingTeams:(Sport *)sport User:(User *)user {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                    @"/sports/", sport.id, @"/visiting_teams.json"]];
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VisitingTeamListChangedNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    
    if (responseStatusCode == 200) {
        visitingTeams =[[NSMutableArray alloc] init];
        
        for (int i = 0; i < [serverData count]; i++) {
            [visitingTeams addObject:[[VisitingTeam alloc] initWithDictionary:[serverData objectAtIndex:i]]];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VisitingTeamListChangedNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VisitingTeamListChangedNotification" object:nil
                                                userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error Retreving Visiting Teams", @"Result", nil]];
    }
}

- (VisitingTeam *)findVisitingTeam:(NSString *)visiting_team_id {
    VisitingTeam *team = nil;
    
    for (int i = 0; i < visitingTeams.count; i++) {
        if ([[[visitingTeams objectAtIndex:i] visiting_team_id] isEqualToString:visiting_team_id]) {
            team = [visitingTeams objectAtIndex:i];
            break;
        }
    }
    
    return team;
}

@end
