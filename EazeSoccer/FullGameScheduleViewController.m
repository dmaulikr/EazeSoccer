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
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.addGameButton, self.standingsButton, self.teamButton, nil];
    
    self.navigationController.toolbarHidden = YES;
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
        else
            [self performSegueWithIdentifier:@"GameStatsSegue" sender:self];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade" message:@"Upgrade for Stats!"
                                                       delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
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
    } else if ([segue.identifier isEqualToString:@"GameStatsSegue"]) {
        LiveStatsViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"FootballStatsSegue"]) {
        EazesportzFootballStatsViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
    }
}
@end
