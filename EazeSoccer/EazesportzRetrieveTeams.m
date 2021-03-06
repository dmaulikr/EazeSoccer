//
//  EazesportzRetrieveTeams.m
//  EazeSportz
//
//  Created by Gil on 1/10/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzRetrieveTeams.h"
#import "EazesportzAppDelegate.h"
#import "sportzServerInit.h"

@implementation EazesportzRetrieveTeams {
    int responseStatusCode;
    NSMutableArray *serverData;
    NSMutableData *theData;
    
    NSURLRequest *originalRequest;
}

@synthesize teams;

- (void)retrieveTeams:(NSString *)sportid Token:(NSString *)authtoken {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url;
    
    if (authtoken.length > 0)
        url = [NSURL URLWithString:[sportzServerInit getTeams:sportid Token:authtoken]];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                    @"/sports/", currentSettings.sport.id, @"/teams.json"]];
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TeamListChangedNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    NSLog(@"%@", serverData);
    
    if (responseStatusCode == 200) {
        teams =[[NSMutableArray alloc] init];
        for (int i = 0; i < [serverData count]; i++) {
            [teams addObject:[[Team alloc] initWithDictionary:[serverData objectAtIndex:i]]];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TeamListChangedNotification" object:nil
                                              userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TeamListChangedNotification" object:nil
                    userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error Retreving Teams", @"Result", nil]];
    }
}

- (NSMutableArray *)retrieveTeamsSynchronous:(NSString *)sportid Token:(NSString *)authtoken {
    NSURL *url;
    
    if (currentSettings.user.authtoken)
        url = [NSURL URLWithString:[sportzServerInit getTeams:sportid Token:currentSettings.user.authtoken]];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                    @"/sports/", sportid, @"/teams.json"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError *jsonSerializationError;
    NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&jsonSerializationError];
    long statusCode = [(NSHTTPURLResponse*)response statusCode];
    serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    
    if (statusCode == 200) {
        teams =[[NSMutableArray alloc] init];
        for (int i = 0; i < [serverData count]; i++) {
            [teams addObject:[[Team alloc] initWithDictionary:[serverData objectAtIndex:i]]];
        }
        
        return teams;
    } else {
        return nil;
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
