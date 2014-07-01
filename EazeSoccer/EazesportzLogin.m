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
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error"
                            message:@"Error Logging in - Check your email. Did you confirm your account? Make sure you are connected to the internet."
                            delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
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
            currentSettings.user = [[User alloc] init];
            currentSettings.user.email = [userdata objectForKey:@"email"];
            
            if ([KeychainWrapper createKeychainValue:email forIdentifier:GOMOBIEMAIL]) {
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
        currentSettings.user = [[User alloc] initWithDictionary:userdata];
        
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

- (User *)LoginSynchronous:(NSString *)loginemail Password:(NSString *)loginpassword {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *sport = [mainBundle objectForInfoDictionaryKey:@"sportzteams"];
    sportzServerInit *serverInit = [sportzServerInit alloc];
    NSURL *url = [NSURL URLWithString:[serverInit getLoginRequest]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSDictionary *userDict = [[NSDictionary alloc] initWithObjectsAndKeys:loginemail, @"email",loginpassword, @"password", sport, @"sport", nil];
    
    NSError *jsonSerializationError = nil;
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:userDict, @"user", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    //Capturing server response
    NSURLResponse* response;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&jsonSerializationError];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSLog(@"response = %d", [httpResponse statusCode]);
    
    if ([httpResponse statusCode] == 200) {
        NSMutableDictionary *logindata = [NSJSONSerialization JSONObjectWithData:result options:0 error:&jsonSerializationError];
        NSLog(@"%@", logindata);
        
        if ([password length] > 0) {
            if ([KeychainWrapper createKeychainValue:password forIdentifier:PIN_SAVED]) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PIN_SAVED];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"** password saved successfully to Keychain!!");
            }
        }
        
        NSDictionary *userdata = [logindata objectForKey:@"user"];
        NSLog(@"%@", userdata);
        
        if([userdata count] > 0) {
            currentSettings.user.email = [userdata objectForKey:@"email"];
            
            if ([KeychainWrapper createKeychainValue:currentSettings.user.email forIdentifier:GOMOBIEMAIL]) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:GOMOBIEMAIL];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"** email saved successfully to Keychain!!");
            }
            
            currentSettings.user.authtoken = [logindata objectForKey:@"authentication_token"];
            url = [NSURL URLWithString:[sportzServerInit getUser:[userdata objectForKey:@"_id"] Token:currentSettings.user.authtoken]];
            request = [NSMutableURLRequest requestWithURL:url];
            result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&jsonSerializationError];
            long statusCode = [(NSHTTPURLResponse*)response statusCode];
            userdata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
            
            if (statusCode == 200) {
                NSDictionary *userdata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
                currentSettings.user = [[User alloc] initWithDictionary:userdata];
                return currentSettings.user;
            } else {
                UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to login. Are we connected to a network?"
                                                                   delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
                [errorView show];
                return nil;;
            }
        } else {
            [KeychainWrapper deleteItemFromKeychainWithIdentifier:PIN_SAVED];
            [KeychainWrapper deleteItemFromKeychainWithIdentifier:GOMOBIEMAIL];
            currentSettings.user.email = @"";
            currentSettings.user.authtoken = @"";
            currentSettings.user.username = @"";
            currentSettings.user.userid = @"";
            UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please activate your account using the email sent when you registered"
                                                               delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            [errorView show];
            return nil;
        }
    } else {
        return nil;;
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

- (User *)getUserSynchronous:(NSString *)userid {
    NSURL *url = [NSURL URLWithString:[sportzServerInit getUser:userid Token:currentSettings.user.authtoken]];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse *response;
    NSError *jsonSerializationError = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&jsonSerializationError];
    long statusCode = [(NSHTTPURLResponse*)response statusCode];
    
    if (statusCode == 200) {
        NSDictionary *userdata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        return [[User alloc] initWithDictionary:userdata];
    } else {
        return nil;;
    }
}

@end
