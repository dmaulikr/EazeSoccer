//
//  EazePhotosViewController.m
//  EazeSportz
//
//  Created by Gil on 11/13/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazePhotosViewController.h"
#import "EazesportzAppDelegate.h"
#import "PlayerSelectionViewController.h"
#import "sportzServerInit.h"
#import "EazeGameSelectionViewController.h"
#import "sportzteamsPhotoInfoViewController.h"
#import "EazeUsersSelectViewController.h"
#import "EazesportzGameLogViewController.h"

@interface EazePhotosViewController () <UIAlertViewDelegate>

@end

@implementation EazePhotosViewController {
    PlayerSelectionViewController *playerSelectController;
    EazeGameSelectionViewController *gameSelectController;
    EazeUsersSelectViewController *usersSelectController;
    EazesportzGameLogViewController *gamelogSelectController;
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
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.searchButton, self.videoButton, nil];
    
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    if (currentSettings.sport.id.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Please select a site before continuing"
                                                       delegate:nil cancelButtonTitle:@"Select Site" otherButtonTitles:nil, nil];
        
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
            if (playerSelectController) {
                if (playerSelectController.player)
                    self.player = playerSelectController.player;
            } else if (gameSelectController) {
                if (gameSelectController.thegame)
                    self.game = gameSelectController.thegame;
            } else if (usersSelectController) {
                if (usersSelectController.user)
                    self.user = usersSelectController.user;
            }
            
            if (gamelogSelectController) {
                if (gamelogSelectController.game) {
                    NSURL *url;
                    
                    if (currentSettings.user.authtoken)
                        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@",
                                                    [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                                    @"/sports/", currentSettings.sport.id, @"/photos.json?team_id=", currentSettings.team.teamid,
                                                    @"&gameschedule_id=", gameSelectController.thegame.id, @"&gamelog_id=",
                                                    gamelogSelectController.gamelog.gamelogid, @"&auth_token=", currentSettings.user.authtoken]];
                    else
                        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",
                                                    [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                                    @"/sports/", currentSettings.sport.id, @"/photos.json?team_id=", currentSettings.team.teamid,
                                                    @"&gameschedule_id=", gameSelectController.thegame.id, @"&gamelog_id=",
                                                    gamelogSelectController.gamelog.gamelogid]];
                    
                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
                    [self.activityIndicator startAnimating];
                    [[NSURLConnection alloc] initWithRequest:request delegate:self];
                }
            } else
                [super viewWillAppear:animated];
    }
}

- (void)displayUpgradeAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                    message:[NSString stringWithFormat:@"%@%@", @"No photos for ", currentSettings.team.team_name]
                                                   delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)searchButtonClicked:(id)sender {
    UIAlertView *alert;
    
    if ([currentSettings.sport.name isEqualToString:@"Football"]) {
         alert = [[UIAlertView alloc] initWithTitle:@"Search" message:@"Select Photo Search Criteria"
                                            delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Player", @"Game", @"Play", @"User", @"All", nil];
    } else {
        alert = [[UIAlertView alloc] initWithTitle:@"Search" message:@"Select Photo Search Criteria"
                                          delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Player", @"Game", @"User", @"All", nil];
    }
    
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayerSelectSegue"]) {
        playerSelectController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"GameSelectSegue"]) {
        gameSelectController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"PhotoInfoSegue"]) {
        sportzteamsPhotoInfoViewController *destController = segue.destinationViewController;
        if ([[self.collectionView indexPathsForSelectedItems] count] > 0) {
            NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
            Photo *photo = [self.photos objectAtIndex:indexPath.row];
            destController.photos = [[NSMutableArray alloc] init];
            destController.photos = self.photos;
            photo.athletes = [[NSMutableArray alloc] init];
            for (int cnt = 0; cnt < [currentSettings.roster count]; cnt++) {
                for (int i = 0; i < [photo.players count]; i++) {
                    if ([[photo.players objectAtIndex:i] isEqualToString:[[currentSettings.roster objectAtIndex:cnt] athleteid]]) {
                        [photo.athletes addObject:[currentSettings.roster objectAtIndex:cnt]];
                    }
                }
            }
            for (int cnt = 0; cnt < [currentSettings.gameList count]; cnt++) {
                if ([[[currentSettings.gameList objectAtIndex:cnt] id] isEqualToString:photo.schedule]) {
                    photo.game = [currentSettings.gameList objectAtIndex:cnt];
                }
            }
            destController.photoindex = indexPath.row;
        } else {
            destController.photo = nil;
        }
    } else if ([segue.identifier isEqualToString:@"UserSelectSegue"]) {
        usersSelectController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"GamePlaySelectSegue"]) {
        gamelogSelectController = segue.destinationViewController;
        gamelogSelectController.game = gameSelectController.thegame;
    }
}

- (void)getPhotos {
    [super getPhotos];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Player"]) {
        self.game = nil;
        self.user = nil;
        gameSelectController = nil;
        gamelogSelectController.game = nil;
        [self performSegueWithIdentifier:@"PlayerSelectSegue" sender:self];
    } else if ([title isEqualToString:@"Game"]) {
        self.player = nil;
        self.user = nil;
        playerSelectController = nil;
        gamelogSelectController = nil;
        [self performSegueWithIdentifier:@"GameSelectSegue" sender:self];
    } else if ([title isEqualToString:@"Play"]) {
        self.player = nil;
        self.user = nil;
        playerSelectController = nil;
        if (gameSelectController.thegame) {
            [self performSegueWithIdentifier:@"GamePlaySelectSegue" sender:self];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Game must be selected before searching by play"
                                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
        
    } else if ([title isEqualToString:@"User"]) {
        self.player = nil;
        self.game = nil;
        gamelogSelectController.game = nil;
        [self performSegueWithIdentifier:@"UserSelectSegue" sender:self];
    } else if ([title isEqualToString:@"All"]) {
        self.game = nil;
        self.user = nil;
        self.player = nil;
        gamelogSelectController.game = nil;
        
        NSURL *url;
        
        if (currentSettings.user.authtoken)
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/photos.json?team_id=", currentSettings.team.teamid, @"&auth_token=",
                                        currentSettings.user.authtoken]];
        else
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/photos.json?team_id=", currentSettings.team.teamid]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.activityIndicator startAnimating];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    } else if ([title isEqualToString:@"Dismiss"]) {
        self.tabBarController.selectedIndex = 0;
    } else if ([title isEqualToString:@"Select Site"]) {
        self.tabBarController.selectedIndex = 0;
    }
}

@end
