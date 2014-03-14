//
//  EazesportzRetrieveEvents.m
//  Eazesportz Broadcast Console
//
//  Created by Gilbert Zaldivar on 2/26/14.
//  Copyright (c) 2014 Gilbert Zaldivar. All rights reserved.
//

#import "EazesportzRetrieveEvents.h"
#import "Event.h"

@implementation EazesportzRetrieveEvents {
    long responseStatusCode;
    NSMutableArray *serverData;
    NSMutableData *theData;
    
    NSURLRequest *originalRequest;
    Sport *thesport;
}

@synthesize startdate;
@synthesize enddate;
@synthesize searchName;
@synthesize game;

@synthesize eventlist;
@synthesize videoEventList;

- (void)retrieveEvents:(Sport *)sport Team:(Team *)team Token:(User *)user {
    thesport = sport;
    NSString *stringurl;
    
    if (team) {
        stringurl = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", sport.id, @"/events.json?team_id=", team.teamid, @"&auth_token=", user.authtoken];
    } else {
        stringurl = [NSString stringWithFormat:@"%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                    @"/sports/", sport.id, @"/events.json?auth_token=", user.authtoken];
    }
    
    if ((startdate) && (enddate)) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        stringurl = [stringurl stringByAppendingFormat:@"&startdate=%@&enddate=%@", [dateFormatter stringFromDate:startdate],
                     [dateFormatter stringFromDate:enddate]];
    } else if (searchName.length > 0) {
        stringurl = [stringurl stringByAppendingFormat:@"&name=%@", searchName];
    } else if (game) {
        stringurl = [stringurl stringByAppendingFormat:@"&gameschedule_id=%@", game.id];
    }
    
    NSURL *url = [NSURL URLWithString:stringurl];
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EventListChangedNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    
    if (responseStatusCode == 200) {
        eventlist = [[NSMutableArray alloc] init];
        videoEventList = [[NSMutableArray alloc] init];
        NSLog(@"%@", serverData);
        
        for (int i = 0; i < [serverData count]; i++ ) {
            Event *anevent = [[Event alloc] initWithDictionary:[serverData objectAtIndex:i] Sport:thesport];
            [eventlist addObject:anevent];
            
            if ([anevent.videoevent intValue] > 0)
                [videoEventList addObject:anevent];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EventListChangedNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EventListChangedNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error", @"Result", nil]];
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
