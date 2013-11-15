//
//  EazeBlogViewController.m
//  EazeSportz
//
//  Created by Gil on 11/14/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazeBlogViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazePlayerSelectViewController.h"
#import "EazeGameSelectionViewController.h"
#import "EazeUsersSelectViewController.h"
#import "EazeCoachSelectionViewController.h"
#import "EazeBlogDetailViewController.h"

@interface EazeBlogViewController () <UIAlertViewDelegate>

@end

@implementation EazeBlogViewController {
    EazeUsersSelectViewController *usersSelectController;
    EazeGameSelectionViewController *gameSelectController;
    EazePlayerSelectViewController *playerSelectController;
    EazeCoachSelectionViewController *coachSelectController;
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
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.addBlogEntryButton, self.refreshButton, self.searchButton, nil];
    
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
    } else if (coachSelectController) {
        if (coachSelectController.coach)
            self.coach = coachSelectController.coach;
    }
    
    [super viewWillAppear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayerSelectSegue"]) {
        playerSelectController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"GameSelectSegue"]) {
        gameSelectController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"BlogEntrySegue"]) {
        NSIndexPath *indexPath = [self.blogTableView indexPathForSelectedRow];
        EazeBlogDetailViewController *destController = segue.destinationViewController;
        destController.blog = [self.blogfeed objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"UserSelectSegue"]) {
        usersSelectController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"CoachSelectSegue"]) {
        coachSelectController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"NewBlogSegue"] ) {
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Player"]) {
        self.game = nil;
        self.coach = nil;
        self.user = nil;
        gameSelectController = nil;
        [self performSegueWithIdentifier:@"PlayerSelectSegue" sender:self];
    } else if ([title isEqualToString:@"Game"]) {
        self.player = nil;
        self.coach = nil;
        self.user = nil;
        playerSelectController = nil;
        [self performSegueWithIdentifier:@"GameSelectSegue" sender:self];
    } else if ([title isEqualToString:@"User"]) {
        self.player = nil;
        self.game = nil;
        self.coach = nil;
        [self performSegueWithIdentifier:@"UserSelectSegue" sender:self];
    } else if ([title isEqualToString:@"Coach"]) {
        self.player = nil;
        self.game = nil;
        self.user = nil;
        [self performSegueWithIdentifier:@"CoachSelectSegue" sender:self];
    } else if ([title isEqualToString:@"All"]) {
        self.team = currentSettings.team;
        self.player = nil;
        self.game = nil;
        self.coach = nil;
        self.user = nil;
        [self getBlogs:nil];
    }
}

- (IBAction)searchButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search" message:@"Enter Blog Search Criteria"
                         delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Player", @"Game", @"User", @"Coach", @"All", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

@end
