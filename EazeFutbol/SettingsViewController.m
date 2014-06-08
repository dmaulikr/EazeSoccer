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
    }
    [_settingsTableView reloadData];
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
            [currentSettings.user logout];
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
}

- (IBAction)addSiteButtonClicked:(id)sender {
    if ((currentSettings.user.admin) && ([currentSettings.user.adminsite isEqualToString:currentSettings.sport.id])) {
        [self performSegueWithIdentifier:@"EditSiteSegue" sender:self];
    } else if (currentSettings.user.adminsite.length > 0) {
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
    } else if ((currentSettings.user.admin) && (currentSettings.user.adminsite.length == 0)) {
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([currentSettings isSiteOwner])
        return 10;
    else if (currentSettings.user.userid.length > 0)
        return 8;
    else
        return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingsTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.tag = indexPath.row;
    
    switch (indexPath.row) {
            
        case 0:
            cell.backgroundColor = [UIColor whiteColor];
            if (currentSettings.team.teamid.length > 0) {
                
                if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"])
                    cell.imageView.image = [currentSettings.team getImage:@"tiny"];
                else
                    cell.imageView.image = [currentSettings.team getImage:@"thumb"];
                
                cell.detailTextLabel.text = currentSettings.sport.sitename;
                cell.textLabel.text = @"Contacts";
            } else {
                cell.imageView.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"icon-76.png"], 1)];
                cell.textLabel.text = @"Welcome!";
                cell.detailTextLabel.text = @"Contact us!";
            }
            break;
            
        case 1:
            cell.backgroundColor = [UIColor whiteColor];
            
            if (currentSettings.user.userid.length > 0) {
                
                if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) {
                    if (currentSettings.user.tinyimage == nil) {
                        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                        //this will start the image loading in bg
                        dispatch_async(concurrentQueue, ^{
                            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:currentSettings.user.tiny]];
                            
                            //this will set the image when loading is finished
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (cell.tag == indexPath.row) {
                                    cell.imageView.image = [UIImage imageWithData:image];
                                    [cell setNeedsLayout];
                                }
                            });
                        });
                    } else
                        cell.imageView.image = currentSettings.user.tinyimage;
                } else {
                    if (currentSettings.user.thumbimage == nil) {
                        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                        //this will start the image loading in bg
                        dispatch_async(concurrentQueue, ^{
                            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:currentSettings.user.userthumb]];
                            
                            //this will set the image when loading is finished
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (cell.tag == indexPath.row) {
                                    cell.imageView.image = [UIImage imageWithData:image];
                                    [cell setNeedsLayout];
                                }
                            });
                        });
                    } else
                        cell.imageView.image = currentSettings.user.thumbimage;
                }
                
                cell.textLabel.text = @"My Profile";
                cell.detailTextLabel.text = currentSettings.user.username;
            } else {
                cell.imageView.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"icon-76.png"], 1)];
                cell.textLabel.text = @"My Profile";
                cell.detailTextLabel.text = @"Login to manage your profile!";
            }
            break;
            
        case 2:
            cell.backgroundColor = [UIColor whiteColor];
            if (currentSettings.team.teamid.length > 0) {
                
                if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"])
                    cell.imageView.image = [currentSettings.team getImage:@"tiny"];
                else
                    cell.imageView.image = [currentSettings.team getImage:@"thumb"];
                
                cell.textLabel.text = currentSettings.team.team_name;
                cell.detailTextLabel.text = @"Change Team";
            } else  {
                cell.imageView.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"icon-76.png"], 1)];
                cell.textLabel.text = @"Change Team";
                cell.detailTextLabel.text = @"Select Program or Player first.";
            }
            break;
            
        case 3:
            cell.backgroundColor = [UIColor whiteColor];
            
            if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) {
                if (currentSettings.sport.id.length > 0)
                    cell.imageView.image = [currentSettings.sport getImage:@"tiny"];
                else
                    cell.imageView.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"icon-76.png"], 1)];
            } else {
                if (currentSettings.sport.id.length > 0)
                    cell.imageView.image = [currentSettings.sport getImage:@"thumb"];
                else
                    cell.imageView.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"icon-76.png"], 1)];
            }
            
            cell.textLabel.text = @"Change Sport";
            cell.detailTextLabel.text = @"Find a Program or Player";
            break;
            
        case 4:
            cell.backgroundColor = [UIColor whiteColor];
            if (currentSettings.user.userid.length > 0) {
                
                if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) {
                    if (currentSettings.user.tinyimage == nil) {
                        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                        //this will start the image loading in bg
                        dispatch_async(concurrentQueue, ^{
                            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:currentSettings.user.tiny]];
                            
                            //this will set the image when loading is finished
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (cell.tag == indexPath.row) {
                                    cell.imageView.image = [UIImage imageWithData:image];
                                    [cell setNeedsLayout];
                                }
                            });
                        });
                    } else
                        cell.imageView.image = currentSettings.user.tinyimage;
                } else {
                    if (currentSettings.user.thumbimage == nil) {
                        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                        //this will start the image loading in bg
                        dispatch_async(concurrentQueue, ^{
                            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:currentSettings.user.userthumb]];
                            
                            //this will set the image when loading is finished
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (cell.tag == indexPath.row) {
                                    cell.imageView.image = [UIImage imageWithData:image];
                                    [cell setNeedsLayout];
                                }
                            });
                        });
                    } else
                        cell.imageView.image = currentSettings.user.thumbimage;
                }
                
                cell.textLabel.text = currentSettings.user.email;
                cell.detailTextLabel.text = @"Logout";
            } else {
                cell.imageView.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"icon-76.png"], 1)];
                cell.textLabel.text = @"Login!";
                cell.detailTextLabel.text = @"";
            }
            break;
            
        case 5:
            cell.backgroundColor = [UIColor whiteColor];
            
            if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"])
                cell.imageView.image = [currentSettings.sport getImage:@"tiny"];
            else
                cell.imageView.image = [currentSettings.sport getImage:@"thumb"];
            
            cell.textLabel.text = @"Sponsors";
            
            if ((currentSettings.user.admin) && ([currentSettings.user.adminsite isEqualToString:currentSettings.sport.id]))
                cell.detailTextLabel.text = @"Our sponsors ....";
            else
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Sponsors", currentSettings.team.mascot];
            break;
            
        case 6:
            cell.backgroundColor = [UIColor whiteColor];
            
            if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"])
                cell.imageView.image = [currentSettings.sport getImage:@"tiny"];
            else
                cell.imageView.image = [currentSettings.sport getImage:@"thumb"];
            
            cell.textLabel.text = @"Notification Settings";
            cell.detailTextLabel.text = @"Change alert notificaiton settings ....";
            break;
            
        case 7:
            cell.backgroundColor = [UIColor whiteColor];
            cell.imageView.image = nil;
            if (currentSettings.user.admin) {
                cell.textLabel.text = @"Manage My Site";
                if (currentSettings.user.adminsite.length > 0)
                    cell.detailTextLabel.text = @"Update my site information";
                else
                    cell.detailTextLabel.text = @"Finish create my new site!";
            } else if (currentSettings.user.userid.length > 0) {
                cell.textLabel.text = @"Create a site";
                cell.detailTextLabel.text = @"Promote a program or player ...";
            }
            break;
            
        case 8:
            cell.backgroundColor = [UIColor whiteColor];
            cell.imageView.image = nil;
            cell.textLabel.text = @"Learn more";
            cell.detailTextLabel.text = @"Packages and info";
            break;
            
        default:
            cell.backgroundColor = [UIColor whiteColor];
            
            if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"])
                cell.imageView.image = [currentSettings.sport getImage:@"tiny"];
            else
                cell.imageView.image = [currentSettings.sport getImage:@"thumb"];
            
            cell.textLabel.text = @"Manage Visiting Teams";
            cell.detailTextLabel.text = @"Manage your opponents ....";
            break;
            
   }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
            
        case 0:
            [self performSegueWithIdentifier:@"ContactSegue" sender:self];
            break;
            
        case 1:
            [self profileButtonClicked:self];
            break;
            
        case 2:
            if (currentSettings.team.teamid.length > 0)
                [self changeTeamButtonClicked:self];
            break;
            
        case 3:
            [self siteButtonClicked:self];
            break;
            
        case 4:
            [self logoutButtonClicked:self];
            break;
            
        case 5:
            if (currentSettings.team.teamid.length > 0) {
                [self performSegueWithIdentifier:@"SponsorSegue" sender:self];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"No team selected. No sponsors to display" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
            
            break;
            
        case 6:
            if (currentSettings.team.teamid.length > 0) {
                [self performSegueWithIdentifier:@"NotificationSettingsSegue" sender:self];
            }
            
            break;
            
        case 7:
            [self addSiteButtonClicked:self];
            break;
            
        case 8:
            [self performSegueWithIdentifier:@"PackageSegue" sender:self];
            break;
            
        default:
            [self performSegueWithIdentifier:@"VisitingTeamsSegue" sender:self];
            break;
    }
}

@end
