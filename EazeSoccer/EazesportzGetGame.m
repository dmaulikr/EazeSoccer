//
//  EazesportzGetGame.m
//  EazeSportz
//
//  Created by Gil on 1/24/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzAppDelegate.h"
#import "sportzServerInit.h"
#import "EazesportzGetGame.h"

@implementation EazesportzGetGame {
    int responseStatusCode;
    NSDictionary *serverData;
    NSMutableData *theData;
    
    NSURLRequest *originalRequest;
}

@synthesize game;

- (void)getGame:(NSString *)sportid Team:(NSString *)teamid Game:(NSString *)gameid Token:(NSString *)authtoken {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *urlstring = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                    @"/sports/", sportid, @"/teams/", teamid, @"/gameschedules/", gameid, @".json"];
    
    if (authtoken.length > 0)
        urlstring = [urlstring stringByAppendingFormat:@"%@%@", @"?auth_token=", currentSettings.user.authtoken];
    
    NSURL *url = [NSURL URLWithString:urlstring];
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GameDataNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result", nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    
    if (responseStatusCode == 200) {
        game = [[GameSchedule alloc] initWithDictionary:serverData];
    
        int index = 0;
        
        for (int i = 0; i < currentSettings.gameList.count; i++) {
            if ([[[currentSettings.gameList objectAtIndex:i] id] isEqualToString:game.id]) {
                index = i;
                break;
            }
        }
        
        [currentSettings.gameList replaceObjectAtIndex:index withObject:game];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GameDataNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GameDataNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error retrieving game data!", @"Result", nil]];
    }
}

- (GameSchedule *)getGameSynchronous:(Sport *)sport Team:(Team *)team Game:(NSString *)gameid User:(User *)user {
    GameSchedule *thegame = nil;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",
                                       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                       @"/sports/", sport.id, @"/teams/", team.teamid, @"/gameschedules/", gameid, @".json?auth_token=", user.authtoken]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError *error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary *thedata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    
    if ([httpResponse statusCode] == 200) {
        thegame = [[GameSchedule alloc] initWithDictionary:thedata];
        int index = 0;
        
        for (int i = 0; i < currentSettings.gameList.count; i++) {
            if ([[[currentSettings.gameList objectAtIndex:i] id] isEqualToString:thegame.id]) {
                index = i;
                break;
            }
        }
        
        [currentSettings.gameList replaceObjectAtIndex:index withObject:thegame];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error retrieving game" delegate:self cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
    
    return thegame;
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
