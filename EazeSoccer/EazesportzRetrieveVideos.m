//
//  EazesportzRetrieveVideos.m
//  EazeSportz
//
//  Created by Gil on 3/16/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzRetrieveVideos.h"
#import "Video.h"

@implementation EazesportzRetrieveVideos
{
    int responseStatusCode;
    NSMutableArray *serverData;
    NSMutableData *theData;
    
    NSURLRequest *originalRequest;
}

@synthesize videos;

@synthesize lacross_scoring_id;
@synthesize gamelog;

- (void)retrieveVideos:(Sport *)sport Team:(Team *)team Athlete:(Athlete *)athlete Game:(GameSchedule *)game SearchUser:(User *)searchuser
                        User:(User *)user {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *stringurl;
    
    if ([user loggedIn])
        stringurl = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                    @"/sports/", sport.id, @"/videoclips.json?team_id=", team.teamid, @"&auth_token=", user.authtoken];
    else
        stringurl = [NSString stringWithFormat:@"%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                    @"/sports/", sport.id, @"/videoclips/showfeaturedvideos.json?team_id=", team.teamid];
    
    if (athlete) {
        stringurl = [stringurl stringByAppendingFormat:@"&athlete_id=%@", athlete.athleteid];
    }
    
    if (game) {
        stringurl = [stringurl stringByAppendingFormat:@"&gameschedule_id=%@", game.id];
    }
    
    if (searchuser) {
        stringurl = [stringurl stringByAppendingFormat:@"&user_id=%@", user.userid];
    }
    
    if (gamelog) {
        stringurl = [stringurl stringByAppendingFormat:@"&gamelog_id=%@", gamelog.gamelogid];
    }
    
    if (lacross_scoring_id.length > 0) {
        stringurl = [stringurl stringByAppendingString:[NSString stringWithFormat:@"&lacross_scoring_id=%@", lacross_scoring_id]];
    }
    
    originalRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:stringurl]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VideosChangedNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result" , nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    if (responseStatusCode == 200) {
        videos = [[NSMutableArray alloc] init];
        for (int i = 0; i < serverData.count; i++) {
            [videos addObject:[[Video alloc] initWithDirectory:[serverData objectAtIndex:i]]];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VideosChangedNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VideosChangedNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error Retrieving Videos", @"Result" , nil]];
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

- (Video *)getVideoSynchronous:(Sport *)sport Team:(Team *)team VideoId:(NSString *)videoid User:(User *)user {
    NSURL *url;
    
    if (user)
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                    @"/sports/", sport.id, @"/videoclips/", videoid, @".json?auth_token=", user.authtoken]];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                    @"/sports/", sport.id, @"/videoclips/", videoid, @".json"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError *jsonSerializationError;
    NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&jsonSerializationError];
    long statusCode = [(NSHTTPURLResponse*)response statusCode];
    NSDictionary *videodata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    
    if (statusCode == 200) {
        return [[Video alloc] initWithDirectory:videodata];
    } else {
        return nil;
    }
}

@end
