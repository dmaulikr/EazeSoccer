
//
//  sportzteamsNewsFeedInfoViewController.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/7/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "EazeNewsFeedInfoViewController.h"
#import "EazesportzAppDelegate.h"
#import "Athlete.h"
#import "Coach.h"
#import "PlayerInfoViewController.h"
#import "CoachesInfoViewController.h"
#import "EazesportzSoccerGameSummaryViewController.h"
#import "EazeBasketballGameSummaryViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface EazeNewsFeedInfoViewController ()

@end

@implementation EazeNewsFeedInfoViewController

@synthesize newsitem;

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
    _newsTextView.layer.cornerRadius = 4;
    _titleLabel.layer.cornerRadius = 4;
    _newsTextView.editable = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (newsitem.athlete.length > 0) {
        _athleteButton.enabled = YES;
        [_athleteButton setTitle:[[currentSettings findAthlete:newsitem.athlete] logname] forState:UIControlStateNormal];
    } else {
        _athleteButton.enabled = NO;
        _athleteButton.hidden = YES;
    }
    
    if (newsitem.coach.length > 0) {
        _coachButton.enabled = YES;
        [_coachButton setTitle:[[currentSettings findCoach:newsitem.coach] fullname] forState:UIControlStateNormal];
    } else {
        _coachButton.enabled = NO;
        _coachButton.hidden = YES;
    }
    
    if (newsitem.game.length > 0) {
        _gameButton.enabled = YES;
        [_gameButton setTitle:[NSString stringWithFormat:@"%@%@", @"vs ", [[currentSettings findGame:newsitem.game] opponent]]
                     forState:UIControlStateNormal];
    } else {
        _gameButton.enabled = NO;
        _gameButton.hidden = YES;
    }
    
    // Add image
    
    if (newsitem.athlete.length > 0) {
        _imageView.image = [[currentSettings findAthlete:newsitem.athlete] getImage:@"thumb"];
    } else if (newsitem.coach.length > 0) {
        _imageView.image = [[currentSettings findCoach:newsitem.coach] getImage:@"thumb"];
    } else if (newsitem.team.length > 0) {
        _imageView.image = [[currentSettings findTeam:newsitem.team] getImage:@"thumb"];
    } else {
        _imageView.image = [currentSettings.sport getImage:@"thumb"];
    }
    
    [_newsTextView setText:newsitem.news];
    [_titleLabel setText:newsitem.title];
}

- (IBAction)athleteButtonClicked:(id)sender {
}

- (IBAction)coachButtonClicked:(id)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayerInfoSegue"]) {
        PlayerInfoViewController *destController = segue.destinationViewController;
        destController.player = [currentSettings findAthlete:newsitem.athlete];
    } else if ([segue.identifier isEqualToString:@"CoachInfoSegue"]) {
        CoachesInfoViewController *destController = segue.destinationViewController;
        destController.coach = [currentSettings findCoach:newsitem.coach];
    } else if ([ segue.identifier isEqualToString:@"SoccerGameInfoSegue"]) {
        EazesportzSoccerGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings findGame:newsitem.game];
    } else if ([segue.identifier isEqualToString:@"BasketballGameInfoSegue"]) {
        EazeBasketballGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings findGame:newsitem.game];
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    _bannerView.hidden = NO;
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    _bannerView.hidden = YES;
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
