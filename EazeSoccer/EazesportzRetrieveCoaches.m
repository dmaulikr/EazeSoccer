//
//  EazesportzRetrieveCoaches.m
//  EazeSportz
//
//  Created by Gil on 1/9/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzRetrieveCoaches.h"
#import "EazesportzAppDelegate.h"
#import "sportzServerInit.h"

@implementation EazesportzRetrieveCoaches {
    int responseStatusCode;
    NSMutableArray *serverData;
    NSMutableData *theData;
    
    NSURLRequest *originalRequest;
}

@synthesize coaches;

- (id)init {
    if (self = [super init]) {
        coaches = [[NSMutableArray alloc] init];
        return self;
    } else
        return nil;
}

- (void)retrieveCoaches:(NSString *)sportid Team:(NSString *)teamid Token:(NSString *)authtoken {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url;
    
    if (authtoken.length > 0)
        url = [NSURL URLWithString:[sportzServerInit getCoachList:currentSettings.team.teamid Token:currentSettings.user.authtoken]];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                    @"/sports/", sportid, @"/coaches.json?team_id=", teamid]];
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CoachListChangedNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    if (responseStatusCode == 200) {
        if (coaches) {
            NSMutableArray *coachList = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < serverData.count; i++) {
                Coach *coach = [[Coach alloc] initWithDictionary:[serverData objectAtIndex:i]];
                [self replaceCoachImages:coach];
                [coachList addObject:coach];
            }
            
            [self cleanUpCoachImageList:coachList];
        } else {
            coaches = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < serverData.count; i++) {
                Coach *coach = [[Coach alloc] initWithDictionary:[serverData objectAtIndex:i]];
                [coach loadImages];
                [coaches addObject:coach];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CoachListChangedNotification" object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CoachListChangedNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error retrieving Coach data", @"Result", nil]];
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

- (void)replaceCoachImages:(Coach *)coach {
    BOOL found = NO;
    
    for (int i = 0; i < coaches.count; i++) {
        
        if (([[[coaches objectAtIndex:i] coachid] isEqualToString:coach.coachid]) &&
            ([[[coaches objectAtIndex:i] coachpic_updated_at] compare:coach.coachpic_updated_at] == NSOrderedSame)) {
            found = YES;
            break;
        }
    }
    
    if (!found) {
        [coach loadImages];
        [coaches addObject:coach];
    }
}

- (void)cleanUpCoachImageList:(NSMutableArray *)coachList {
    
    for (int i = 0; i < coaches.count; i++) {
        BOOL found = NO;
        
        for (int cnt = 0; cnt < coachList.count; cnt++) {
            if ([[[coaches objectAtIndex:cnt] coachid] isEqualToString:[[coaches objectAtIndex:i] coachid] ]) {
                found = YES;
                break;
            }
        }
        
        if (!found) {
            [coaches removeObjectAtIndex:i];
        }
    }
}

@end
