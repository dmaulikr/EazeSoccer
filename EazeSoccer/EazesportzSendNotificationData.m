//
//  EazesportzSendNotificationData.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/12/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzSendNotificationData.h"
#import "Base64.h"

@implementation EazesportzSendNotificationData {
    int responseStatusCode;
    NSDictionary *serverData;
    NSMutableData *theData;
}


- (void)sendNotificationData:(Sport *)sport Team:(Team *)team Athlete:(Athlete *)player User:(User *)user {
    UIDevice *device = [UIDevice currentDevice];
    
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSData *devicedata = [standardDefaults objectForKey:@"deviceToken"];
    NSString *str = [[devicedata description] stringByReplacingOccurrencesOfString:@"<" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
    str = [str stringByReplacingOccurrencesOfString: @" " withString: @""];
//    NSString *str = [devicedata base64EncodedString];
    
    NSMutableDictionary *notificationDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:str, @"token",
                                                   device.model, @"model", device.name, @"name", device.systemName, @"systemname",
                                                   device.systemVersion, @"systemversion", team.teamid, @"team_id",
                                                   [NSString stringWithFormat:@"%d", [[standardDefaults objectForKey:@"ScoreAlerts"] boolValue]], @"scorealerts",
                                                   [NSString stringWithFormat:@"%d", [[standardDefaults objectForKey:@"MediaAlerts"] boolValue]], @"mediaalerts",
                                                   [NSString stringWithFormat:@"%d", [[standardDefaults objectForKey:@"BioAlerts"] boolValue]], @"athletealerts",
                                                   [NSString stringWithFormat:@"%d", [[standardDefaults objectForKey:@"BlogAlerts"] boolValue]], @"blogalerts",
                                                   [NSString stringWithFormat:@"%d", [[standardDefaults objectForKey:@"TeamAlerts"] boolValue]], @"teamalerts",
                                                   [[NSBundle mainBundle] bundleIdentifier], @"bundleidentifier", nil];
    
    NSString *urlstring = [NSString stringWithFormat:@"%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                       @"/sports/", sport.id, @"/updateApnNotification.json"];
    
    if ([user loggedIn]) {
        [notificationDictionary setValue:user.userid forKey:@"user_id"];
        urlstring = [urlstring stringByAppendingFormat:@"?auth_token=%@", user.authtoken];
    }
    
    if (player) {
        [notificationDictionary setValue:player.athleteid forKey:@"athlete_id"];
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlstring]];
    NSError *jsonSerializationError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:notificationDictionary options:0 error:&jsonSerializationError];
    
    if (jsonSerializationError) {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:jsonData];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AlertNotification" object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Network Error", @"Result" , nil]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    
    if (responseStatusCode == 200) {
        NSDictionary *result = [serverData objectForKey:@"notification"];
        NSLog(@"result= %@", result);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AlertNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        NSDictionary *result = [serverData objectForKey:@"error"];
        NSLog(@"result= %@", result);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AlertNotification" object:nil
                                                    userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:result, @"Result" , nil]];
    }
}

@end
