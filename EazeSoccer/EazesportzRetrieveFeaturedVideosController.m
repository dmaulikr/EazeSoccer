//
//  EazesportzRetrieveFeaturedVideosController.m
//  EazeSportz
//
//  Created by Gil on 1/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzRetrieveFeaturedVideosController.h"
#import "EazesportzAppDelegate.h"

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
    
    if (token.length > 0)
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

- (void)addFeaturedVideo:(Video *)video {
    BOOL found = NO;
    int cnt;
    
    for (cnt = 0; cnt < featuredvideos.count; cnt++) {
        if ([video.videoid isEqualToString:[[featuredvideos objectAtIndex:cnt] videoid]]) {
            found = YES;
            break;
        }
    }
    
    if (!found)
        [featuredvideos addObject:video];
    else
        [featuredvideos replaceObjectAtIndex:cnt withObject:video];
}

- (void)removeFeaturedVideo:(Video *)video {
    [featuredvideos removeObject:video];
}

- (void)saveFeaturedVideos {
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    NSURL *aurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", [mainBundle objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/videoclips/updatefeaturedvideos.json?team_id=",
                                        currentSettings.team.teamid, @"&auth_token=", currentSettings.user.authtoken]];
    
    NSMutableArray *thevideos = [[NSMutableArray alloc] init];
    for (int i = 0; i < featuredvideos.count; i++) {
        [thevideos addObject:[[featuredvideos objectAtIndex:i] videoid]];
    }
    
    NSMutableDictionary *featuredphotolist = [[NSMutableDictionary alloc] initWithObjectsAndKeys:thevideos, @"video_ids", nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
    
    NSError *jsonSerializationError = nil;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:featuredphotolist options:0 error:&jsonSerializationError];
    
    if (!jsonSerializationError) {
        NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Serialized JSON: %@", serJson);
    } else {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonData];
    
    //Capturing server response
    NSURLResponse* response;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&jsonSerializationError];
    NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:&jsonSerializationError];
    NSLog(@"%@", serverData);
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([httpResponse statusCode] == 200) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Featured video list updated!"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error updating featured video list"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (BOOL)isFeaturedVideo:(Video *)video {
    BOOL found = NO;
    
    for (int i = 0; i < featuredvideos.count; i++) {
        if ([[[featuredvideos objectAtIndex:i] videoid] isEqualToString:video.videoid]) {
            found = YES;
            break;
        }
    }
    
    return found;
}

@end
