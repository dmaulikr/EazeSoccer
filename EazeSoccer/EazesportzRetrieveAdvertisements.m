//
//  EazesportzRetieveAdvertisements.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/13/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzRetrieveAdvertisements.h"
#import "Sponsor.h"

@implementation EazesportzRetrieveAdvertisements {
    long responseStatusCode;
    NSMutableArray *serverData;
    NSMutableData *theData;
}

@synthesize advertisements;

- (void)retrieveUserAds:(Sport *)sport UserId:(NSString *)userid {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                @"/sports/", sport.id, @"/sponsors.json?user=", userid]];
    
    [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AdvertisementListChangedNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    
    if (responseStatusCode == 200) {
        advertisements = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < serverData.count; i++) {
            [advertisements addObject:[[Sponsor alloc] initWithDirectory:[serverData objectAtIndex:i]]];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AdvertisementListChangedNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AdvertisementListChangedNotification" object:nil
                                            userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error Retreving Ads", @"Result", nil]];
    }
}

@end
