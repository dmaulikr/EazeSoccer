//
//  EazesportzScheduleViewController.m
//  EazeSportz
//
//  Created by Gil on 1/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzScheduleViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazeFootballGameSummaryViewController.h"
#import "EazeBasketballGameSummaryViewController.h"
#import "EazesportzSoccerGameSummaryViewController.h"
#import "EditGameViewController.h"
#import "EazesportzDisplayAdBannerViewController.h"

@interface EazesportzScheduleViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzScheduleViewController {
    BOOL editgame, addgame;
    
    EazesportzDisplayAdBannerViewController *adBannerController;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    addgame = editgame = NO;
    
    if (currentSettings.sport.id.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Please select a sport before continuing"
                                                       delegate:self cancelButtonTitle:@"Select Site" otherButtonTitles:nil, nil];
        
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        [super viewWillAppear:animated];
        
        if ((currentSettings.isSiteOwner) && (currentSettings.gameList.count > 0))
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.addGameButton, self.editGameButton, self.standingsButton, nil];
        else if ((currentSettings.isSiteOwner) && (currentSettings.gameList.count == 0))
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.addGameButton, nil];
        else
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.standingsButton, nil];
        
        self.navigationController.toolbarHidden = YES;
        
        if (currentSettings.gameList.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"No Games Scheduled!" delegate:nil cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    
    if (currentSettings.sport.hideAds) {
        _bannerView.hidden = YES;
        _adBannerContainer.hidden = NO;
        [adBannerController viewWillAppear:YES];
    } else {
        _adBannerContainer.hidden = YES;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (![segue.identifier isEqualToString:@"NewGameSegue"]) {
        NSIndexPath *indexPath = [self.gamesTableView indexPathForSelectedRow];
        
        if ([segue.identifier isEqualToString:@"GameFootballSegue"]) {
            EazeFootballGameSummaryViewController *destController = segue.destinationViewController;
            destController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
        } else if ([segue.identifier isEqualToString:@"GameBasketballSegue"]) {
            EazeBasketballGameSummaryViewController *destCotroller = segue.destinationViewController;
            destCotroller.game = [currentSettings.gameList objectAtIndex:indexPath.row];
        } else if ([segue.identifier isEqualToString:@"GameSoccerSegue"]) {
            EazesportzSoccerGameSummaryViewController *destController = segue.destinationViewController;
            destController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
        } else if ([segue.identifier isEqualToString:@"EditGameSegue"]) {
            EditGameViewController *destController = segue.destinationViewController;
            destController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
        } else if ([segue.identifier isEqualToString:@"AdBannerSegue"]) {
            adBannerController = segue.destinationViewController;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((editgame) || (addgame)) {
        [self performSegueWithIdentifier:@"EditGameSegue" sender:self];
    } else {
        if ([currentSettings.sport.name isEqualToString:@"Football"]) {
            [self performSegueWithIdentifier:@"GameFootballSegue" sender:self];
        } else if ([currentSettings.sport.name isEqualToString:@"Basketball"]) {
            [self performSegueWithIdentifier:@"GameBasketballSegue" sender:self];
        } else if ([currentSettings.sport.name isEqualToString:@"Soccer"]) {
            [self performSegueWithIdentifier:@"GameSoccerSegue" sender:self];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Select Site"]) {
        self.tabBarController.selectedIndex = 0;
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    _bannerView.hidden = NO;
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    _bannerView.hidden = YES;
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)editGameButtonClicked:(id)sender {
    if (editgame)
        editgame = NO;
    else
        editgame = YES;
}

@end
