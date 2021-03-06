//
//  EazesportzRetrieveStandings.m
//  EazeSportz
//
//  Created by Gil on 1/10/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzRetrieveStandings.h"
#import "sportzServerInit.h"
#import "EazesportzAppDelegate.h"

@implementation EazesportzRetrieveStandings {
    int responseStatusCode;
    NSMutableArray *serverData;
    NSMutableData *theData;
    
    NSURLRequest *originalRequest;
}

@synthesize standings;

- (void)retrieveStandings:(NSString *)sportid Token:(NSString *)authtoken {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url = [NSURL URLWithString:[sportzServerInit getStandings:currentSettings.user.authtoken]];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StandingsListChangedNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result" , nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    if (responseStatusCode == 200) {
        standings = [[NSMutableArray alloc] init];
        for (int i = 0; i < serverData.count; i++) {
            [standings addObject:[[Standings alloc] initWithDirectory:[serverData objectAtIndex:i]]];
        }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"StandingsListChangedNotification" object:nil
                                                            userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StandingsListChangedNotification" object:nil
                                            userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error Retrieving Standings", @"Result" , nil]];
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
