//
//  EazesportzAppDelegate.m
//  EazeSportz
//
//  Created by Gil on 1/23/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzAppDelegate.h"
#import "sportzConstants.h"
#import "sportzServerInit.h"
#import "KeychainWrapper.h"
#import "EazesportzRetrieveGames.h"
#import "EazesportzRetrievePlayers.h"
#import "EazesportzRetrieveSport.h"
#import "EazesportzLogin.h"
#import "EazesportzRetrieveSport.h"
#import "EazesportzRetrieveAlerts.h"
#import "EazesportzRetrieveCoaches.h"
#import "EazesportzRetrieveSponsors.h"
#import "EazesportzRetrieveTeams.h"
#import "EazesportzRetrieveFeaturedPhotos.h"
#import "EazesportzRetrieveFeaturedVideosController.h"

#import <AWSRuntime/AmazonErrorHandler.h>

@implementation EazesportzAppDelegate {
    EazesportzRetrieveTeams *getTeams;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    currentSettings = [[sportzCurrentSettings alloc] init];

    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
//    NSString *fileName = [NSString stringWithFormat:@"%@/currentsport.txt", documentsDirectory];
//    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"currentsport.txt"];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    UIImageView *myGraphic;
    
    if (content) {
        if ([content isEqualToString:@"Football"]) {
            myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Footballbkg-640x1136.png"]];
        } else if ([content isEqualToString:@"Basketball"]) {
            myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gymfloor-640x1136.png"]];
        } else if ([content isEqualToString:@"Soccer"]) {
            myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"soccer-640x1136"]];
        }
    } else {
        myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Footballbkg-640x1136.png"]];
        currentSettings.changesite = YES;
    }
    
    [self.window.rootViewController.view addSubview: myGraphic];
    [self.window.rootViewController.view sendSubviewToBack: myGraphic];
    
    [AmazonErrorHandler shouldNotThrowExceptions];
    currentSettings.rootwindow = self.window;
    
    if ([KeychainWrapper searchKeychainCopyMatchingIdentifier:GOMOBIEMAIL] != nil) {  // Use keychain email and password
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginResult:) name:@"LoginNotification" object:nil];
//        [[[EazesportzLogin alloc] init] Login:[KeychainWrapper keychainStringFromMatchingIdentifier:GOMOBIEMAIL]
//                                     Password:[KeychainWrapper keychainStringFromMatchingIdentifier:PIN_SAVED]];
        if ([[[EazesportzLogin alloc] init] LoginSynchronous: [KeychainWrapper keychainStringFromMatchingIdentifier:GOMOBIEMAIL]
                                                    Password:[KeychainWrapper keychainStringFromMatchingIdentifier:PIN_SAVED]]) {
            if (![currentSettings initS3Bucket]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Storage Access Issue. Please restart app!"
                                                               delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
            } else {
                [self getSport];
            }
        }
    } else if (content) {
        [self getSport];
    }
    
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
    if (currentSettings.user.authtoken) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginResult:) name:@"LoginNotification" object:nil];
        
        [[[EazesportzLogin alloc] init] Login:[KeychainWrapper keychainStringFromMatchingIdentifier:GOMOBIEMAIL]
                                     Password:[KeychainWrapper keychainStringFromMatchingIdentifier:PIN_SAVED]];
    } else if ((currentSettings.sport.id.length > 0) && (currentSettings.team.teamid)) {
        [self getAllSportData];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)loginResult:(NSNotification *)notification {
    NSDictionary *result = [notification userInfo];
    
    if (![[result valueForKey:@"Result"] isEqualToString:@"Success"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[result valueForKey:@"Result"]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        if (![currentSettings initS3Bucket]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Storage Access Issue. Please restart app!"
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
        [self getAllSportData];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getAllSportData {
    if ((currentSettings.sport.id.length > 0) && (currentSettings.team.teamid.length > 0)) {
        [[[EazesportzRetrieveGames alloc] init] retrieveGames:currentSettings.sport.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken];
        [[[EazesportzRetrievePlayers alloc] init] retrievePlayers:currentSettings.sport.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken];
        [[[EazesportzRetrieveCoaches alloc] init] retrieveCoaches:currentSettings.sport.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken];
        [[[EazesportzRetrieveSponsors alloc] init] retrieveSponsors:currentSettings.sport.id Token:currentSettings.user.authtoken];
        [[[EazesportzRetrieveFeaturedPhotos alloc] init] retrieveFeaturedPhotos:currentSettings.sport.id Token:currentSettings.user.authtoken];
        [[[EazesportzRetrieveFeaturedVideosController alloc] init] retrieveFeaturedVideos:currentSettings.sport.id Token:currentSettings.user.authtoken];
        
        if (currentSettings.user.authtoken.length > 0)
            [[[EazesportzRetrieveAlerts alloc] init] retrieveAlerts:currentSettings.sport.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken];
    }
    
}

- (void)getSport {
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *sitefilename = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/currentsite.txt", documentsDirectory] encoding:NSUTF8StringEncoding error:NULL];
    
    if (sitefilename != nil) {
        [[[EazesportzRetrieveSport alloc] init] retrieveSportSynchronous:sitefilename Token:currentSettings.user.authtoken];
        getTeams = [[EazesportzRetrieveTeams alloc] init];
        if ([getTeams retrieveTeamsSynchronous:currentSettings.sport.id Token:currentSettings.user.authtoken]) {
            currentSettings.teams = getTeams.teams;
            
            if (currentSettings.teams.count == 1)
                currentSettings.team = [currentSettings.teams objectAtIndex:0];
            
            [self getAllSportData];
        }
    } else {
        currentSettings.changesite = YES;
    }
}


@end
