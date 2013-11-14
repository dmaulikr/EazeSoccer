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

@interface EazeBlogViewController ()

@end

@implementation EazeBlogViewController {
    EazeUsersSelectViewController *usersSelectController;
    EazeGameSelectionViewController *gameSelectController;
    EazePlayerSelectViewController *playerSelectController;
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
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.searchButton, self.refreshButton, self.addBlogEntryButton, nil];
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayerSelectSegue"]) {
        playerSelectController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"GameSelectSegue"]) {
        gameSelectController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"BlogEntrySegue"]) {
    } else if ([segue.identifier isEqualToString:@"UserSelectSegue"]) {
        usersSelectController = segue.destinationViewController;
    }
}

@end
