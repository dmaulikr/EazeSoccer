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
#import "EazesportzRetrieveTeams.h"
#import "EazesportzRetrieveFeaturedPhotos.h"
#import "EazesportzRetrieveFeaturedVideosController.h"
#import "EazesportzSendNotificationData.h"
#import "EazesportzRetrieveVisitingTeams.h"
#import "EazesportzInApAdDetailViewController.h"

#import <AWSRuntime/AmazonErrorHandler.h>
#import <CoreLocation/CoreLocation.h>
#import <StoreKit/StoreKit.h>
#import "Reachability.h"


@interface EazesportzAppDelegate (private) <CLLocationManagerDelegate>

-(void)reachabilityChanged:(NSNotification*)note;

// @property (nonatomic, strong) EazesportzInApAdDetailViewController *purchaseController;

@end

@implementation EazesportzAppDelegate {
    EazesportzRetrieveTeams *getTeams;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    
//    EazesportzInApAdDetailViewController *paymentController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //Clear keychain on first run in case of reinstallation
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"FirstRun"]) {
        // Delete values from keychain here
        [KeychainWrapper deleteItemFromKeychainWithIdentifier:PIN_SAVED];
        [KeychainWrapper deleteItemFromKeychainWithIdentifier:GOMOBIEMAIL];
        
        NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
        [standardDefaults setValue:@"1strun" forKey:@"FirstRun"];
        [standardDefaults setValue:[NSNumber numberWithBool:NO] forKey:@"MediaAlerts"];
        [standardDefaults setValue:[NSNumber numberWithBool:YES] forKey:@"ScoreAlerts"];
        [standardDefaults setValue:[NSNumber numberWithBool:NO] forKey:@"BioAlerts"];
        [standardDefaults setValue:[NSNumber numberWithBool:NO] forKey:@"BlogAlerts"];
        [standardDefaults setValue:[NSNumber numberWithBool:YES] forKey:@"TeamAlerts"];
        [standardDefaults synchronize];
    }

    currentSettings = [[sportzCurrentSettings alloc] init];

    UIImageView *myGraphic;
    
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"])
        myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Footballbkg.png"]];
    else
        myGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Footballbkg-640x1136.png"]];

    [self.window.rootViewController.view addSubview: myGraphic];
    [self.window.rootViewController.view sendSubviewToBack: myGraphic];
    
    [AmazonErrorHandler shouldNotThrowExceptions];
    currentSettings.rootwindow = self.window;

    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
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
            } else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"currentsport"]) {
                [self getSport];
            } else
                currentSettings.firstuse = YES;
            
            // set up location manager
            locationManager = [[CLLocationManager alloc] init];
            [locationManager setDelegate:self];
            [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            [locationManager startUpdatingLocation];

            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
                    (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
            
            NSSetUncaughtExceptionHandler(&onUncaughtException);

        //    paymentController = [[EazesportzInApAdDetailViewController alloc] init];
            [[SKPaymentQueue defaultQueue] addTransactionObserver:currentSettings.purchaseController];
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"You need network connecitity to use GameTracker!" delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        });
    };
    
    [reach startNotifier];
    
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation * newLocation = [locations lastObject];
    // post notification that a new location has been found
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewLocationNotification" object:self
                                                      userInfo:[NSDictionary dictionaryWithObject:newLocation forKey:@"newLocationResult"]];
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
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:currentSettings.purchaseController];
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
        [[currentSettings visitingteams] retrieveVisitingTeams:currentSettings.sport User:currentSettings.user];
        [currentSettings.inventorylist retrieveSportadinv:currentSettings.sport User:currentSettings.user];
        [currentSettings.sponsors retrieveSponsors:currentSettings.sport.id Token:currentSettings.user.authtoken];
        [[[EazesportzRetrieveGames alloc] init] retrieveGames:currentSettings.sport.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken];
        [[[EazesportzRetrievePlayers alloc] init] retrievePlayers:currentSettings.sport.id Team:currentSettings.team.teamid
                                                            Token:currentSettings.user.authtoken];
        [currentSettings.coaches retrieveCoaches:currentSettings.sport.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken];
        [[currentSettings teamPhotos] retrieveFeaturedPhotos:currentSettings.sport.id Token:currentSettings.user.authtoken];
        [[currentSettings teamVideos] retrieveFeaturedVideos:currentSettings.sport.id Token:currentSettings.user.authtoken];
    }
    
}

- (void)getSport {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"currentsite"]) {
        [[[EazesportzRetrieveSport alloc] init] retrieveSportSynchronous:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentsite"]
                                                                   Token:currentSettings.user.authtoken];
        
        if (currentSettings.sport.id.length > 0) {
            getTeams = [[EazesportzRetrieveTeams alloc] init];
            if ([getTeams retrieveTeamsSynchronous:currentSettings.sport.id Token:currentSettings.user.authtoken]) {
                currentSettings.teams = getTeams.teams;
                
                if (currentSettings.teams.count == 1)
                    currentSettings.team = [currentSettings.teams objectAtIndex:0];
                
                [self getAllSportData];
            }
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentsite"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentsport"];
            currentSettings.changesite = YES;
        }
    } else {
        currentSettings.changesite = YES;
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"Launched with URL: %@", url.absoluteString);
    
    NSDictionary *userDict = [self urlPathToDictionary:url.absoluteString];
    
    //Do something with the information in userDict
    
    if (userDict.count > 0) {
        NSString *email = [userDict objectForKey:@"email"];
        NSString *admin = [userDict objectForKey:@"admin"];
        currentSettings.newuser = [[User alloc] init];
        currentSettings.newuser.email = email;
        
        if (admin.length > 0) {
            currentSettings.newuser.admin = YES;
        } else {
            currentSettings.newuser.admin = NO;
        }
        
        currentSettings.firstuse = NO;
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

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setObject:deviceToken forKey:@"deviceToken" ];
    [standardDefaults synchronize];
    
    if (currentSettings.team.teamid.length > 0) {
        [[[EazesportzSendNotificationData alloc] init] sendNotificationData:currentSettings.sport Team:currentSettings.team Athlete:nil
                                                                       User:currentSettings.user];
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

void onUncaughtException(NSException* exception)
{
    NSLog(@"uncaught exception: %@", exception.description);
}

@end
