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


- (void)retrieveSport:(NSString *)authtoken {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url = [NSURL URLWithString:[sportzServerInit getSport:authtoken]];
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
    
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The download cound not complete - please make sure you're connected to either 3G or WI-FI" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSDictionary *sportdata = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    
    if (responseStatusCode == 200) {
        currentSettings.sport = [[Sport alloc] initWithDictionary:sportdata];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SportChangedNotification" object:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving Sport"
                             message:[NSString stringWithFormat:@"%d", responseStatusCode] delegate:nil cancelButtonTitle:@"Ok"
                             otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
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
