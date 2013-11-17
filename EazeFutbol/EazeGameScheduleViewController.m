//
//  EazesportzSoccerGameScheduleViewController.m
//  EazeSportz
//
//  Created by Gil on 11/12/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazeGameScheduleViewController.h"
#import "EazesportzSoccerGameSummaryViewController.h"
#import "EazeBasketballGameSummaryViewController.h"
#import "EazesportzAppDelegate.h"

@interface EazeGameScheduleViewController ()

@end

@implementation EazeGameScheduleViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.gamesTableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"GameSummarySegue"]) {
        EazesportzSoccerGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"BasketballGameSummarySegue"]) {
        EazeBasketballGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
    }
}

@end
