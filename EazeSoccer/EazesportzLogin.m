//
//  EazesportzLogin.m
//  EazeSportz
//
//  Created by Gil on 1/10/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzLogin.h"
#import "EazesportzAppDelegate.h"
#import "sportzServerInit.h"
#import "KeychainWrapper.h"
#import "sportzConstants.h"

@implementation EazesportzLogin {
    int responseStatusCode;
    NSMutableArray *serverData;
    NSMutableData *theData;
    
    NSURLRequest *originalRequest;
    
    NSString *email, *password;
    BOOL userinfo;
}

- (void)Login:(NSString *)loginemail Password:(NSString *)loginpassword {
    
    password = loginpassword;
    email = loginemail;
    userinfo = NO;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *sport = [mainBundle objectForInfoDictionaryKey:@"sportzteams"];
    sportzServerInit *serverInit = [sportzServerInit alloc];
    NSURL *url = [NSURL URLWithString:[serverInit getLoginRequest]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSDictionary *userDict = [[NSDictionary alloc] initWithObjectsAndKeys:email, @"email",password, @"password", sport, @"sport", nil];
    
    NSError *jsonSerializationError = nil;
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:userDict, @"user", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    originalRequest = request;
    [[NSURLConnection alloc] initWithRequest:request  delegate:self];
}

- (void)Login:(NSString *)loginemail Password:(NSString *)loginpassword Site:(NSString *)site {
    password = loginpassword;
    email = loginemail;
    userinfo = NO;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    sportzServerInit *serverInit = [sportzServerInit alloc];
    NSURL *url = [NSURL URLWithString:[serverInit getLoginRequest]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSDictionary *userDict = [[NSDictionary alloc] initWithObjectsAndKeys:email, @"email",password, @"password", site, @"site", nil];
    
    NSError *jsonSerializationError = nil;
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:userDict, @"user", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    originalRequest = request;
    [[NSURLConnection alloc] initWithRequest:request  delegate:self];
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
    
    NSDictionary *token = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    
    if ((responseStatusCode == 200) && (!userinfo)) {
        NSUInteger passHash = [password hash];
        
        if ([password length] > 0) {
            if ([KeychainWrapper createKeychainValue:password forIdentifier:PIN_SAVED]) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PIN_SAVED];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"** password saved successfully to Keychain!!");
            }
        }
        
        NSDictionary *userdata = [token objectForKey:@"user"];
        NSLog(@"%@", userdata);
        
        if([userdata count] > 0) {
            currentSettings.user.email = [userdata objectForKey:@"email"];
            
            if ([KeychainWrapper createKeychainValue:currentSettings.user.email forIdentifier:GOMOBIEMAIL]) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:GOMOBIEMAIL];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"** email saved successfully to Keychain!!");
            }
            
            currentSettings.user.authtoken = [token objectForKey:@"authentication_token"];
            
            userinfo = YES;
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSURL *url = [NSURL URLWithString:[sportzServerInit getUser:[userdata objectForKey:@"_id"] Token:currentSettings.user.authtoken]];
            originalRequest = [NSMutableURLRequest requestWithURL:url];
            [[NSURLConnection alloc] initWithRequest:originalRequest delegate:self];
        } else {
            [KeychainWrapper deleteItemFromKeychainWithIdentifier:PIN_SAVED];
            [KeychainWrapper deleteItemFromKeychainWithIdentifier:GOMOBIEMAIL];
            currentSettings.user.email = @"";
            currentSettings.user.authtoken = @"";
            currentSettings.user.username = @"";
            currentSettings.user.userid = @"";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginNotification" object:nil
                                                              userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:
                                                          @"Please activate your account using the email sent when you registered", @"Result",nil]];
        }
    } else if ((responseStatusCode == 200) && (userinfo)) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *userdata = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
        currentSettings.user.email = [userdata objectForKey:@"email"];
        currentSettings.user.admin = [NSNumber numberWithInteger:[[userdata objectForKey:@"admin"] integerValue]];
        currentSettings.user.userid = [userdata objectForKey:@"id"];
        currentSettings.user.username = [userdata objectForKey:@"name"];
        currentSettings.user.avatarprocessing = [[userdata objectForKey:@"avatarprocessing"] boolValue];
        
        if ((NSNull *)[userdata objectForKey:@"avatarthumburl"] != [NSNull null])
            currentSettings.user.userthumb = [userdata objectForKey:@"avatarthumburl"];
        else
            currentSettings.user.userthumb = @"";
        
        if ((NSNull *)[userdata objectForKey:@"avatartinyurl"] != [NSNull null])
            currentSettings.user.tiny = [userdata objectForKey:@"avatartinyurl"];
        else
            currentSettings.user.tiny = @"";
        
        currentSettings.user.isactive = [NSNumber numberWithInteger:[[userdata objectForKey:@"is_active"] integerValue]];
        currentSettings.user.bio_alert = [NSNumber numberWithInteger:[[userdata objectForKey:@"bio_alert"] integerValue]];
        currentSettings.user.blog_alert = [NSNumber numberWithInteger:[[userdata objectForKey:@"blog_alert"] integerValue]];
        currentSettings.user.media_alert = [NSNumber numberWithInteger:[[userdata objectForKey:@"media_alert"] integerValue]];
        currentSettings.user.stat_alert = [NSNumber numberWithInteger:[[userdata objectForKey:@"stat_alert"] integerValue]];
        currentSettings.user.score_alert = [NSNumber numberWithInteger:[[userdata objectForKey:@"score_alert"] integerValue]];
        currentSettings.user.teammanagerid = [userdata objectForKey:@"teamid"];
        currentSettings.user.awssecretkey = [userdata objectForKey:@"awskey"];
        currentSettings.user.awskeyid = [userdata objectForKey:@"awskeyid"];
        currentSettings.user.tier = [userdata objectForKey:@"tier"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginNotification" object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Success", @"Result", nil]];
    } else {
        if (!userinfo) {
            if (responseStatusCode == 401) {
                [KeychainWrapper deleteItemFromKeychainWithIdentifier:GOMOBIEMAIL];
                [KeychainWrapper deleteItemFromKeychainWithIdentifier:PIN_SAVED];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginNotification" object:nil
                                                userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Invalid Login", @"Result", nil]];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginNotification" object:nil
                                                userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"Error Retrieving User", @"Result" , nil]];
        }
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
