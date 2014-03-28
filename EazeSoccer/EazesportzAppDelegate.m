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
    
    if ([[mainBundle objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"]) {
        if ([[mainBundle objectForInfoDictionaryKey:@"sportzteams"] isEqualToString:@"Soccer"]) {
            myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"soccer.jpg"]];
        } else if ([[mainBundle objectForInfoDictionaryKey:@"sportzteams"] isEqualToString:@"Basketball"]) {
            myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gymfloor.png"]];
        } else if ([[mainBundle objectForInfoDictionaryKey:@"sportzteams"] isEqualToString:@"Football"]) {
            myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Footballbkg.png"]];
        }
    } else if ([currentSettings.sport.name isEqualToString:@"Football"]) {
        myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Footballbkg-640x1136.png"]];
    } else if ([currentSettings.sport.name isEqualToString:@"Basketball"]) {
            myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gymfloor-640x1136.png"]];
    } else if ([currentSettings.sport.name isEqualToString:@"Soccer"]) {
            myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"soccer-640x1136"]];
    }
    
    
    [self.window.rootViewController.view addSubview: myGraphic];
    [self.window.rootViewController.view sendSubviewToBack: myGraphic];
    currentSettings = [[sportzCurrentSettings alloc] init];
    [AmazonErrorHandler shouldNotThrowExceptions];
    currentSettings.sitechanged = YES;
    currentSettings.rootwindow = self.window;
    
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
    if (([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"]) && (currentSettings.user.authtoken)) {
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"Launched with URL: %@", url.absoluteString);
    
    NSDictionary *userDict = [self urlPathToDictionary:url.absoluteString];
    
    //Do something with the information in userDict
    
    if (userDict.count > 0) {
        
    }
    
    return YES;
}

/*
 -(NSDictionary *)urlPathToDictionary:(NSString *)path
 Takes a url in the form of: your_prefix://this_item/value1/that_item/value2/some_other_item/value3
 And turns it into a dictionary in the form of:
 {
 this_item: @"value1",
 that_item: @"value2",
 some_other_item: @"value3"
 }
 
 Handles everything properly if there is a trailing slash or not.
 Returns `nil` if there aren't the proper combinations of keys and pairs (must be an even number)
 
 NOTE: This example assumes you're using ARC. If not, you'll need to add your own autorelease statements.
 */

-(NSDictionary *)urlPathToDictionary:(NSString *)path {
    //Get the string everything after the :// of the URL.
    NSString *stringNoPrefix = [[path componentsSeparatedByString:@"://"] lastObject];
    //Get all the parts of the url
    NSMutableArray *parts = [[stringNoPrefix componentsSeparatedByString:@"/"] mutableCopy];
    //Make sure the last object isn't empty
    if([[parts lastObject] isEqualToString:@""])[parts removeLastObject];
    
    if([parts count] % 2 != 0)//Make sure that the array has an even number
        return nil;
    
    //We already know how many values there are, so don't make a mutable dictionary larger than it needs to be.
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:([parts count] / 2)];
    
    //Add all our parts to the dictionary
    for (int i=0; i<[parts count]; i+=2) {
        [dict setObject:[parts objectAtIndex:i+1] forKey:[parts objectAtIndex:i]];
    }
    
    //Return an NSDictionary, not an NSMutableDictionary
    return [NSDictionary dictionaryWithDictionary:dict];
}

@end
