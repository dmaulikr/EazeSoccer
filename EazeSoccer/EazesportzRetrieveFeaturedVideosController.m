//
//  EazesportzRetrieveFeaturedVideosController.m
//  EazeSportz
//
//  Created by Gil on 1/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzRetrieveFeaturedVideosController.h"
#import "EazesportzAppDelegate.h"
#import "Video.h"

@implementation EazesportzRetrieveFeaturedVideosController {
    int responseStatusCode;
    NSMutableArray *serverData;
    NSMutableData *theData;
    
    NSURLRequest *originalRequest;
}

@synthesize featuredvideos;

- (void)retrieveFeaturedVideos:(NSString *)sportid Token:(NSString *)token {
    featuredvideos = [[NSMutableArray alloc] init];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url;
    
    if (token)
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                    @"/sports/", currentSettings.sport.id, @"/videoclips/showfeaturedvideos.json?team_id=",
                                    currentSettings.team.teamid, @"&auth_token=", currentSettings.user.authtoken]];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                    @"/sports/", currentSettings.sport.id, @"/videoclips/showfeaturedvideos.json?team_id=",
                                    currentSettings.team.teamid]];
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FeaturedVideosChangedNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result" , nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    if (responseStatusCode == 200) {
        featuredvideos = [[NSMutableArray alloc] init];
        for (int i = 0; i < serverData.count; i++) {
            [featuredvideos addObject:[[Video alloc] initWithDirectory:[serverData objectAtIndex:i]]];
        }
        
        currentSettings.featuredVideos = featuredvideos;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FeaturedVideosChangedNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FeaturedVideosChangedNotification" object:nil
                                                        userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error Retrieving Featured Videos", @"Result" , nil]];
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
