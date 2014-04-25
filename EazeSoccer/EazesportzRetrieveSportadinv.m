//
//  EazesportzRetrieveSportadinv.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/24/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzRetrieveSportadinv.h"

@implementation EazesportzRetrieveSportadinv {
    long responseStatusCode;
    NSMutableArray *serverData;
    NSMutableData *theData;
}

@synthesize inventorylist;

- (void)retrieveSportadinv:(Sport *)sport User:(User *)user {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url;
    
    if (user.authtoken)
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                    @"/sports/", sport.id, @"/sportadinvs.json?auth_token=", user.authtoken]];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"], @"/sports/",
                                    sport.id, @"/sportadinvs.json"]];
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SportadinvListChangedNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    
    if (responseStatusCode == 200) {
        inventorylist = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < serverData.count; i++) {
            Sportadinv *adinv = [[Sportadinv alloc] initWithDirectory:[serverData objectAtIndex:i]];
            [inventorylist addObject:adinv];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SportadinvListChangedNotification" object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SportadinvListChangedNotification" object:nil
                                                    userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error Retreving Ad Inventory", @"Result", nil]];
    }
}

@end
