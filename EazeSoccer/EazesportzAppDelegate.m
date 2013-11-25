//
//  EazesportzAppDelegate.m
//  EazeSoccer
//
//  Created by Gil on 10/29/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzAppDelegate.h"
#import "sportzConstants.h"
#import "sportzServerInit.h"
#import "KeychainWrapper.h"

#import <AWSRuntime/AmazonErrorHandler.h>

@implementation EazesportzAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UIImageView *myGraphic;
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    if ([[mainBundle objectForInfoDictionaryKey:@"sportzteams"] isEqualToString:@"Soccer"]) {
        if ([[mainBundle objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"])
            myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"soccer-background.png"]];
        else
            myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"soccer.jpg"]];
    } else if ([[mainBundle objectForInfoDictionaryKey:@"sportzteams"] isEqualToString:@"Basketball"]) {
        if ([[mainBundle objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"])
            myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gymfloor-iPhone-Background.png"]];
        else
            myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gymfloor.png"]];
    } else if ([[mainBundle objectForInfoDictionaryKey:@"sportzteams"] isEqualToString:@"Football"]) {
        if ([[mainBundle objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"])
            ;
        else
            myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Footballbkg1.jpg"]];
    }
    
    [self.window.rootViewController.view addSubview: myGraphic];
    [self.window.rootViewController.view sendSubviewToBack: myGraphic];
    currentSettings = [[sportzCurrentSettings alloc] init];
    [AmazonErrorHandler shouldNotThrowExceptions];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (currentSettings.user.email.length > 0) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *sport = [mainBundle objectForInfoDictionaryKey:@"sportzteams"];
        sportzServerInit *serverInit = [sportzServerInit alloc];
        NSURL *url = [NSURL URLWithString:[serverInit getLoginRequest]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSDictionary *userDict = [[NSDictionary alloc] initWithObjectsAndKeys:[KeychainWrapper keychainStringFromMatchingIdentifier:GOMOBIEMAIL], @"email", [KeychainWrapper keychainStringFromMatchingIdentifier:PIN_SAVED], @"password", sport, @"sport", nil];
        
        NSError *jsonSerializationError = nil;
        NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:userDict, @"user", nil];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
        
        if (!jsonSerializationError) {
            NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"Serialized JSON: %@", serJson);
        } else {
            NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
        }
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:jsonData];
        NSURLResponse* response;
        NSError *error = nil;
        NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
        int responseStatusCode = [(NSHTTPURLResponse*)response statusCode];
        
        if (responseStatusCode == 200) {
            NSDictionary *token = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
            NSDictionary *userdata = [token objectForKey:@"user"];
            if([userdata count] > 0) {
                currentSettings.user.email = [userdata objectForKey:@"email"];
                if ([KeychainWrapper createKeychainValue:currentSettings.user.email forIdentifier:GOMOBIEMAIL]) {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:GOMOBIEMAIL];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSLog(@"** email saved successfully to Keychain!!");
                }
                
                currentSettings.user.authtoken = [token objectForKey:@"authentication_token"];
                
                NSURL *url = [NSURL URLWithString:[sportzServerInit getUser:[userdata objectForKey:@"_id"]
                                                                          Token:currentSettings.user.authtoken]];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                NSURLResponse* response;
                NSError *error = nil;
                NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
                responseStatusCode = [(NSHTTPURLResponse*)response statusCode];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                userdata = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
                
                currentSettings.user.email = [userdata objectForKey:@"email"];
                currentSettings.user.admin = [NSNumber numberWithInteger:[[userdata objectForKey:@"admin"] integerValue]];
                currentSettings.user.userid = [userdata objectForKey:@"id"];
                currentSettings.user.username = [userdata objectForKey:@"name"];
                
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
                
                NSString *sportid;
                
                if ((NSNull *)[userdata objectForKey:@"default_site"] != [NSNull null])
                    sportid = [userdata objectForKey:@"default_site"];
                else
                    sportid = @"";
                
                if (![currentSettings.sport.id isEqualToString:sportid]) {
                    currentSettings.sport.id = sportid;
                    [currentSettings retrieveSport];
                }
                
                if (currentSettings.team.team_name.length > 0) {
                    [currentSettings retrieveCoaches];
                    [currentSettings retrieveGameList];
                    [currentSettings retrievePlayers];
                }
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No User Data"
                                                                message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                               delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Retrieving User Data"
                                                            message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
