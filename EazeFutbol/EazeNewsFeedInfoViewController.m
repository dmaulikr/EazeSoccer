
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
#import "EazeFootballGameSummaryViewController.h"

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
//    self.view.backgroundColor = [UIColor clearColor];
    _newsTextView.layer.cornerRadius = 6;
    _titleLabel.layer.cornerRadius = 6;
    _coachButton.layer.cornerRadius = 6;
    _athleteButton.layer.cornerRadius = 6;
    _gameButton.layer.cornerRadius = 6;
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
        [_gameButton setTitle:[[currentSettings findGame:newsitem.game ] vsOpponent] forState:UIControlStateNormal];
    } else {
        _gameButton.enabled = NO;
        _gameButton.hidden = YES;
    }
    
    if (newsitem.external_url.length > 0) {
        _readArticleButton.hidden = NO;
        _readArticleButton.enabled = YES;
        [_readArticleButton setTitle:newsitem.external_url forState:UIControlStateNormal];
    } else {
        _readArticleButton.hidden = YES;
        _readArticleButton.enabled = NO;
    }
    
    // Add image
    
    if ((newsitem.tinyurl.length > 0) || (newsitem.thumburl.length > 0)) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:newsitem.thumburl]];
            
            //this will set the image when loading is finished
            dispatch_async(dispatch_get_main_queue(), ^{
                _imageView.image = [UIImage imageWithData:image];
            });
        });
    } else if (newsitem.athlete.length > 0) {
        _imageView.image = [currentSettings normalizedImage:[[currentSettings findAthlete:newsitem.athlete] getImage:@"thumb"] scaledToSize:125];
    } else if (newsitem.coach.length > 0) {
        _imageView.image = [currentSettings normalizedImage:[[currentSettings findCoach:newsitem.coach] getImage:@"thumb"] scaledToSize:125];
    } else if (newsitem.team.length > 0) {
        _imageView.image = [currentSettings normalizedImage:[[currentSettings findTeam:newsitem.team] getImage:@"thumb"] scaledToSize:125];
    } else {
        _imageView.image = [currentSettings normalizedImage:[currentSettings.sport getImage:@"thumb"] scaledToSize:125];
    }
    
    [_newsTextView setText:newsitem.news];
    [_titleLabel setText:newsitem.title];
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
    } else if ([segue.identifier isEqualToString:@"FootballGameInfoSegue"]) {
        EazeFootballGameSummaryViewController *destController = segue.destinationViewController;
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

- (IBAction)gameButtonClicked:(id)sender {
    if ([currentSettings.sport.name isEqualToString:@"Football"]) {
        [self performSegueWithIdentifier:@"FootballGameInfoSegue" sender:self];
    } else if ([currentSettings.sport.name isEqualToString:@"Basketball"]) {
        [self performSegueWithIdentifier:@"BasketballGameInfoSegue" sender:self];
    } else if ([currentSettings.sport.name isEqualToString:@"Soccer"]) {
        [self performSegueWithIdentifier:@"SoccerGameInfoSegue" sender:self];
    }
}

- (IBAction)readArticleButtonClicked:(id)sender {
}
@end
