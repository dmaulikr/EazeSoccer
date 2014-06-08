//
//  EazesportzRetrieveNews.m
//  EazeSportz
//
//  Created by Gil on 3/10/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzRetrieveNews.h"
#import "Newsfeed.h"

@implementation EazesportzRetrieveNews {
    long responseStatusCode;
    NSMutableArray *serverData;
    NSMutableData *theData;
    
    NSURLRequest *originalRequest;
}

@synthesize news;

- (void)retrieveNews:(Sport *)sport Team:(Team *)team User:(User *)user {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *stringurl = [NSString stringWithFormat:@"%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                    @"/sports/", sport.id, @"/newsfeeds.json?team_id=", team.teamid];
    
    if ([user loggedIn]) {
        stringurl = [stringurl stringByAppendingFormat:@"&auth_token=%@", user.authtoken];
    }

    [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:
                                              [NSURL URLWithString:[stringurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] delegate:self];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewsListChangedNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error retrieving news", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    if (responseStatusCode == 200) {
        news =[[NSMutableArray alloc] init];
        for (int i = 0; i < [serverData count]; i++) {
            [news addObject:[[Newsfeed alloc] initWithDirectory:[serverData objectAtIndex:i]]];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewsListChangedNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewsListChangedNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error Retreving news", @"Result", nil]];
    }
}

- (NSMutableArray *)retrieveNewsSynchronous:(Sport *)sport Team:(Team *)team User:(User *)user {
    NSString *stringurl = [NSString stringWithFormat:@"%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                           @"/sports/", sport.id, @"/newsfeeds.json?team_id=", team.teamid];
    
    if (user.authtoken.length > 0) {
        stringurl = [stringurl stringByAppendingFormat:@"&auth_token=%@", user.authtoken];
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:stringurl]];
    NSURLResponse* response;
    NSError *jsonSerializationError;
    NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&jsonSerializationError];
    long statusCode = [(NSHTTPURLResponse*)response statusCode];
    serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    
    if (statusCode == 200) {
        news =[[NSMutableArray alloc] init];
        for (int i = 0; i < [serverData count]; i++) {
            [news addObject:[[Newsfeed alloc] initWithDirectory:[serverData objectAtIndex:i]]];
        }
        
        return news;
    } else {
        return nil;
    }
}

@end
