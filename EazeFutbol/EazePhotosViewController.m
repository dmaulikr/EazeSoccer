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

@interface EazePhotosViewController () <UIAlertViewDelegate>

@end

@implementation EazePhotosViewController {
    PlayerSelectionViewController *playerSelectController;
    EazeGameSelectionViewController *gameSelectController;
    EazeUsersSelectViewController *usersSelectController;
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
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.searchButton, nil];
    
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
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
    
    [super viewWillAppear:animated];
}

- (IBAction)searchButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search" message:@"Select Photo Search Criteria"
                                        delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Player", @"Game", @"User", @"All", nil];
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
            destController.photo = photo;
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
        } else {
            destController.photo = nil;
        }
    } else if ([segue.identifier isEqualToString:@"UserSelectSegue"]) {
        usersSelectController = segue.destinationViewController;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Player"]) {
        self.game = nil;
        self.user = nil;
        gameSelectController = nil;
        [self performSegueWithIdentifier:@"PlayerSelectSegue" sender:self];
    } else if ([title isEqualToString:@"Game"]) {
        self.player = nil;
        self.user = nil;
        playerSelectController = nil;
        [self performSegueWithIdentifier:@"GameSelectSegue" sender:self];
    } else if ([title isEqualToString:@"User"]) {
        self.player = nil;
        self.game = nil;
        [self performSegueWithIdentifier:@"UserSelectSegue" sender:self];
    } else if ([title isEqualToString:@"All"]) {
        self.game = nil;
        self.user = nil;
        self.player = nil;
        NSURL *url = [NSURL URLWithString:[sportzServerInit getTeamPhotos:currentSettings.team.teamid Token:currentSettings.user.authtoken]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.activityIndicator startAnimating];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

@end
