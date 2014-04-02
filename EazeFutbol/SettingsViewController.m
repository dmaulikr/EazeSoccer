//
//  ChangeTeamViewController.m
//  Basketball Console
//
//  Created by Gilbert Zaldivar on 9/16/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "SettingsViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzServerInit.h"
#import "sportzConstants.h"
#import "KeychainWrapper.h"
#import "EazeLoginViewController.h"
#import "ProgramInfoViewController.h"
#import "EazesportzRetrieveSport.h"
#import "EazesportzRetrieveTeams.h"

#import <QuartzCore/QuartzCore.h>

@interface SettingsViewController () <UIAlertViewDelegate>

@end

@implementation SettingsViewController {
    BOOL newsite;
    EazesportzRetrieveTeams *getTeams;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    _teamNameLabel.layer.cornerRadius = 4;
    _usernameLabel.layer.cornerRadius = 4;
    _settingsView.layer.cornerRadius = 6;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated {
    if (currentSettings.sport.id.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Please select a site before continuing"
                                                       delegate:self cancelButtonTitle:@"Select Site" otherButtonTitles:nil, nil];
        
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        [super viewWillAppear:animated];
        
        if(currentSettings.team.teamid.length > 0)
            _teamNameLabel.text = currentSettings.team.team_name;
        else
            _teamNameLabel.text = @"Select Team";
        
        if (currentSettings.user.userid.length > 0) {
            [_logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
            _usernameLabel.text = currentSettings.user.email;
        } else {
            [_logoutButton setTitle:@"Login" forState:UIControlStateNormal];
            _usernameLabel.text = @"No User Logged in!";
        }
        
        if ((currentSettings.user.admin) && (currentSettings.user.adminsite.length > 0)) {
            _addSiteLabel.text = @"Manage My Site";
            [_addSiteButton setTitle:@"My Site" forState:UIControlStateNormal];
        } else if ((currentSettings.user.admin) && (currentSettings.user.adminsite.length == 0)) {
            _addSiteLabel.text = @"My Site Info";
            [_addSiteButton setTitle:@"My Site" forState:UIControlStateNormal];
        } else if (!currentSettings.isSiteOwner) {
            _addSiteLabel.text = @"Create New Site";
            [_addSiteButton setTitle:@"New Site" forState:UIControlStateNormal];
        }
    }
    
    _contactLabel.text = currentSettings.sport.sitename;
}

- (IBAction)logoutButtonClicked:(id)sender {
    if (currentSettings.user.userid.length > 0) {
        NSURL *url = [NSURL URLWithString:[sportzServerInit logout:currentSettings.user.authtoken]];
        NSURLResponse* response;
        NSError *error = nil;
        NSMutableDictionary *jsonDict =  [[NSMutableDictionary alloc] init];
        NSError *jsonSerializationError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
        
        if (!jsonSerializationError) {
            NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"Serialized JSON: %@", serJson);
        } else {
            NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
        }
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:jsonData];
        [request setHTTPMethod:@"DELETE"];
        NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        NSLog(@"%@", serverData);
        
        if ([httpResponse statusCode] == 200) {
            [KeychainWrapper deleteItemFromKeychainWithIdentifier:PIN_SAVED];
            [KeychainWrapper deleteItemFromKeychainWithIdentifier:GOMOBIEMAIL];
            currentSettings.user = nil;
            UITabBarController *tabBarController = self.tabBarController;
          
            for (UIViewController *viewController in tabBarController.viewControllers)
            {
                if ([viewController isKindOfClass:[UINavigationController class]])
                    [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
            }
            
            UIView * fromView = tabBarController.selectedViewController.view;
            UIView * toView = [[tabBarController.viewControllers objectAtIndex:0] view];
            
            // Transition using a page curl.
            [UIView transitionFromView:fromView
                                toView:toView
                              duration:0.5
                               options:(4 > tabBarController.selectedIndex ? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown)
                            completion:^(BOOL finished) {
                                if (finished) {
                                    tabBarController.selectedIndex = 0;
                                }
                            }];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Login Credentials"
                                                            message:[NSString stringWithFormat:@"%d", [httpResponse statusCode]]
                                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
}

- (IBAction)changeTeamButtonClicked:(id)sender {
    if (currentSettings.teams.count > 1) {
        currentSettings.sitechanged = YES;
        
        UITabBarController *tabBarController = self.tabBarController;

        for (UIViewController *viewController in tabBarController.viewControllers) {
            if ([viewController isKindOfClass:[UINavigationController class]])
                [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
        }

        UIView * fromView = tabBarController.selectedViewController.view;
        UIView * toView = [[tabBarController.viewControllers objectAtIndex:0] view];
         
        // Transition using a page curl.
        [UIView transitionFromView:fromView
        toView:toView
        duration:0.5
        options:(4 > tabBarController.selectedIndex ? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown)
        completion:^(BOOL finished) {
            if (finished) {
                tabBarController.selectedIndex = 0;
            }
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                        message:[NSString stringWithFormat:@"%@%@", @"There is only one team. No other team has ben entered for ",
                                                                 currentSettings.sport.sitename] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (IBAction)profileButtonClicked:(id)sender {
    if (currentSettings.user.userid.length > 0) {
        [self performSegueWithIdentifier:@"UserProfileSegue" sender:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"You must be logged in to manage a profile"
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Login"]) {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    } else if ([title isEqualToString:@"Select Site"]) {
        self.tabBarController.selectedIndex = 0;
    }
}

- (IBAction)siteButtonClicked:(id)sender {
    currentSettings.changesite = YES;
    UITabBarController *tabBarController = self.tabBarController;
    
    for (UIViewController *viewController in tabBarController.viewControllers) {
        if ([viewController isKindOfClass:[UINavigationController class]])
            [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
    }
    
    self.tabBarController.selectedIndex = 0;
}

- (IBAction)addSiteButtonClicked:(id)sender {
    if (currentSettings.user.adminsite.length > 0) {
        [[[EazesportzRetrieveSport alloc] init] retrieveSportSynchronous:currentSettings.user.adminsite Token:currentSettings.user.authtoken];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        //make a file name to write the data to using the documents directory:
        NSString *fileName = [NSString stringWithFormat:@"%@/currentsite.txt", documentsDirectory];
        NSString *sportFile = [NSString stringWithFormat:@"%@/currentsport.txt", documentsDirectory];
        //create content - four lines of text
        NSString *content = currentSettings.sport.id;
        //save content to the documents directory
        [content writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
        [currentSettings.sport.name writeToFile:sportFile atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
        getTeams = [[EazesportzRetrieveTeams alloc] init];
        
        if ([getTeams retrieveTeamsSynchronous:currentSettings.sport.id Token:currentSettings.user.authtoken]) {
            currentSettings.teams = getTeams.teams;
            
            if (currentSettings.teams.count == 1)
                currentSettings.team = [currentSettings.teams objectAtIndex:0];
            else
                currentSettings.team = nil;
            
            UITabBarController *tabBarController = self.tabBarController;
            
            for (UIViewController *viewController in tabBarController.viewControllers) {
                if ([viewController isKindOfClass:[UINavigationController class]])
                    [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
            }
            
            UIView * fromView = tabBarController.selectedViewController.view;
            UIView * toView = [[tabBarController.viewControllers objectAtIndex:0] view];
            
            // Transition using a page curl.
            [UIView transitionFromView:fromView toView:toView duration:0.5
                        options:(4 > tabBarController.selectedIndex ? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown)
                            completion:^(BOOL finished) {
                                if (finished) {
                                    tabBarController.selectedIndex = 0;
                                }
                            }];
        }
    } else if ((currentSettings.user.userid.length > 0) && (currentSettings.user.admin) && (currentSettings.user.adminsite.length == 0)) {
        [self performSegueWithIdentifier:@"EditSiteSegue" sender:self];
    } else {
        newsite = YES;
        [self performSegueWithIdentifier:@"NewSiteSegue" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditSiteSegue"]) {
        ProgramInfoViewController *destController = segue.destinationViewController;
        destController.sportid = currentSettings.user.adminsite;
    } else if (([segue.identifier isEqualToString:@"LoginSegue"]) && (newsite)) {
        EazeLoginViewController *destController = segue.destinationViewController;
        destController.registeradmin = YES;
    }
}

@end
