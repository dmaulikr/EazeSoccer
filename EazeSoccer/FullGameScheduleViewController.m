//
//  FullGameScheduleViewController.m
//  EazeSportz
//
//  Created by Gil on 11/7/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "FullGameScheduleViewController.h"
#import "EazesportzAppDelegate.h"
#import "EditGameViewController.h"
#import "LiveStatsViewController.h"
#import "EazesportzFootballStatsViewController.h"
#import "EazesportzRetrieveGames.h"
#import "EazeSoccerPlayerStatsViewController.h"
#import "BasketballStatsViewController.h"


@interface FullGameScheduleViewController () <UIAlertViewDelegate>

@end

@implementation FullGameScheduleViewController {
    NSIndexPath *deleteIndexPath;
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
    
    if (currentSettings.teams.count == 1)
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.addGameButton, self.standingsButton, nil];
    else
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.addGameButton, self.refreshButton, self.standingsButton, self.teamButton, nil];
    
    self.navigationController.toolbarHidden = YES;
}

- (void)viewWAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        deleteIndexPath = [self.gamesTableView indexPathForSelectedRow];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You are about delete the game. All data will be lost!"
                                                       delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:@"Cancel", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([currentSettings.sport isPackageEnabled]) {
        NSBundle *mainBundle = [NSBundle mainBundle];

        if ([[mainBundle objectForInfoDictionaryKey:@"sportzteams"] isEqualToString:@"Football"])
            [self performSegueWithIdentifier:@"FootballStatsSegue" sender:self];
        else if ([currentSettings.sport.name isEqualToString:@"Soccer"])
            [self performSegueWithIdentifier:@"SoccerGameStatsSegue" sender:self];
        else if ([currentSettings.sport.name isEqualToString:@"Basketball"])
            [self performSegueWithIdentifier:@"BasketballGameStatsSegue" sender:self];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade Required"
                                            message:[NSString stringWithFormat:@"%@%@", @"Stat support not available for ", currentSettings.team.team_name]
                                            delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Info", @"Edit Game", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"]) {
        [[currentSettings.gameList objectAtIndex:deleteIndexPath.row] deleteGame];
    } else if ([title isEqualToString:@"Info"]) {
        [self performSegueWithIdentifier:@"UpgradeInfoSegue" sender:self];
    } else if ([title isEqualToString:@"Dismiss"]) {
        self.tabBarController.selectedIndex = 0;
    } else if ([title isEqualToString:@"Info"]) {
        [self performSegueWithIdentifier:@"UpgradeInfoSegue" sender:self];
    } else if ([title isEqualToString:@"Edit Game"]) {
        [self performSegueWithIdentifier:@"EditGameSegue" sender:self];
    }
}

- (IBAction)teamButtonClicked:(id)sender {
    currentSettings.team = nil;
    [self viewDidAppear:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.gamesTableView indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"NewGameSegue"]) {
        EditGameViewController *destController = segue.destinationViewController;
        destController.game = nil;
    } else if ([segue.identifier isEqualToString:@"SoccerGameStatsSegue"]) {
        EazeSoccerPlayerStatsViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"FootballStatsSegue"]) {
        EazesportzFootballStatsViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"EditGameSegue"]) {
        EditGameViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"BasketballGameStatsSegue"]) {
        BasketballStatsViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
    }
}
- (IBAction)refreshButtonClicked:(id)sender {
    
    if ((currentSettings.sport.id.length > 0) && (currentSettings.team.teamid.length > 0))
        [[[EazesportzRetrieveGames alloc] init] retrieveGames:currentSettings.sport.id Team:currentSettings.team.teamid
                                                        Token:currentSettings.user.authtoken];
}

@end
