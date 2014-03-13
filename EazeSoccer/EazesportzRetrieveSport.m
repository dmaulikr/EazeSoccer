//
//  EazesportzRetrieveSport.m
//  EazeSportz
//
//  Created by Gil on 1/9/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzRetrieveSport.h"
#import "EazesportzAppDelegate.h"
#import "sportzServerInit.h"

@implementation EazesportzRetrieveSport {
    int responseStatusCode;
    NSMutableArray *serverData;
    NSMutableData *theData;
    
    NSURLRequest *originalRequest;
}

- (void)retrieveSport:(NSString *)sport Token:(NSString *)authtoken {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                       @"/sports/", sport, @".json?auth_token=", currentSettings.user.authtoken]];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SportChangedNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network error", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSDictionary *sportdata = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    
    if (responseStatusCode == 200) {
        currentSettings.sport = [[Sport alloc] initWithDictionary:sportdata];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SportChangedNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else if (responseStatusCode == 404) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SportChangedNotification" object:nil
                                                userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Not Found", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SportChangedNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Failure", @"Result", nil]];
    }
}

- (Sport *)retrieveSportSynchronous:(NSString *)sport Token:(NSString *)authtoken {
    NSURL *url;
    
    if (authtoken)
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                       @"/sports/", sport, @".json?auth_token=", currentSettings.user.authtoken]];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                    @"/sports/", sport, @".json"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError *jsonSerializationError;
    NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&jsonSerializationError];
    long statusCode = [(NSHTTPURLResponse*)response statusCode];
    NSDictionary *sportdata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    
    if (statusCode == 200) {
        currentSettings.sport = [[Sport alloc] initWithDictionary:sportdata];
        return currentSettings.sport;
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
