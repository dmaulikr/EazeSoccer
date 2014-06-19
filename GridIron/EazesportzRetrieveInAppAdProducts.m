//
//  EazesportzRetrieveInAppAdProducts.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/12/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzRetrieveInAppAdProducts.h"
#import "EazesportzAppDelegate.h"
#import "InAppProducts.h"

@implementation EazesportzRetrieveInAppAdProducts

{
    int responseStatusCode;
    NSMutableArray *serverData;
    NSMutableData *theData;
}

@synthesize products;

- (void)retrieveProducts {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/admins/%@/ios_client_ads.json?auth_token=%@",
                 [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SecureSportzServerUrl"], currentSettings.user.adminsid,
                  currentSettings.user.authtoken]];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InAppProductsChangedNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error ", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    
    if (responseStatusCode == 200) {
        products = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [serverData count]; i++ ) {
            [products addObject:[[InAppProducts alloc] initWithDictionary:[serverData objectAtIndex:i]]];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InAppProductsChangedNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InAppProductsChangedNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error retrieving ad products", @"Result", nil]];
    }
}

@end
