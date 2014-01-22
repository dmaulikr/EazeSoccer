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
#import "EazesportzRetrieveGames.h"
#import "EazesportzRetrievePlayers.h"
#import "EazesportzRetrieveSport.h"
#import "EazesportzLogin.h"
#import "EazesportzRetrieveSport.h"

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
            myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Footballbkg.png"]];
    }
    
    [self.window.rootViewController.view addSubview: myGraphic];
    [self.window.rootViewController.view sendSubviewToBack: myGraphic];
    currentSettings = [[sportzCurrentSettings alloc] init];
    [AmazonErrorHandler shouldNotThrowExceptions];
    currentSettings.sitechanged = YES;
    
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
    if (([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"]) || (currentSettings.user.authtoken)) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginResult:) name:@"LoginNotification" object:nil];

        [[[EazesportzLogin alloc] init] Login:[KeychainWrapper keychainStringFromMatchingIdentifier:GOMOBIEMAIL]
                                      Password:[KeychainWrapper keychainStringFromMatchingIdentifier:PIN_SAVED]];
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
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotSport:) name:@"SportChangedNotification" object:nil];
    
//    [[[EazesportzRetrieveSport alloc] init] retrieveSport:currentSettings.user.authtoken];
    NSDictionary *result = [notification userInfo];
    if (![[result valueForKey:@"Result"] isEqualToString:@"Success"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[result valueForKey:@"Result"]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    NSUInteger orientations = UIInterfaceOrientationMaskAllButUpsideDown;
    
    if(self.window.rootViewController){
        UIViewController *presentedViewController = [[(UINavigationController *)self.window.rootViewController viewControllers] lastObject];
        orientations = [presentedViewController supportedInterfaceOrientations];
    }
    
    return orientations;
}
 */

@end
