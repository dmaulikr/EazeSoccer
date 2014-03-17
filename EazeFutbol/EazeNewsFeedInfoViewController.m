
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
#import "sportzteamsMovieViewController.h"

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
    [[_imageButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _imageButton.enabled = NO;
    _athleteButton.enabled = NO;
    _coachButton.enabled = NO;
    _gameButton.enabled = NO;
    _athleteButton.hidden = YES;
    _coachButton.hidden = YES;
    _gameButton.hidden = YES;
    
    if (newsitem.videoclip_id.length > 0) {
        _imageButton.enabled = YES;
        [_imageButton setBackgroundImage:[currentSettings normalizedImage:newsitem.videoPoster scaledToSize:125] forState:UIControlStateNormal];
        _imageView.image = [currentSettings normalizedImage:newsitem.videoPoster scaledToSize:125];
    } else if ((newsitem.tinyurl.length > 0) || (newsitem.thumburl.length > 0)) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:newsitem.thumburl]];
            
            //this will set the image when loading is finished
            dispatch_async(dispatch_get_main_queue(), ^{
                [_imageButton setImage:[UIImage imageWithData:image] forState:UIControlStateNormal];
                _imageView.image = [UIImage imageWithData:image];
            });
        });
    } else if (newsitem.athlete.length > 0) {
        _imageButton.enabled = YES;
        [_imageButton setBackgroundImage:[currentSettings normalizedImage:[[currentSettings findAthlete:newsitem.athlete] getImage:@"thumb"] scaledToSize:125]
                      forState:UIControlStateNormal];
    } else if (newsitem.game.length > 0) {
        _imageButton.enabled = YES;
        [_imageButton setBackgroundImage:[currentSettings normalizedImage:[[currentSettings findGame:newsitem.game] vsimage] scaledToSize:50]
                      forState:UIControlStateNormal];
    } else if (newsitem.coach.length > 0) {
        _imageButton.enabled = YES;
        [_imageButton setBackgroundImage:[currentSettings normalizedImage:[[currentSettings findCoach:newsitem.coach] getImage:@"thumb"] scaledToSize:125]
                      forState:UIControlStateNormal];
    } else if (newsitem.team.length > 0) {
        [_imageButton setBackgroundImage:[currentSettings normalizedImage:[currentSettings.team getImage:@"thumb"] scaledToSize:125]
                                forState:UIControlStateNormal];
    } else {
        [_imageButton setBackgroundImage:[currentSettings normalizedImage:[currentSettings.sport getImage:@"thumb"] scaledToSize:125]
                      forState:UIControlStateNormal];
    }
    
    if (newsitem.athlete.length > 0) {
        [_athleteButton setTitle:[[currentSettings findAthlete:newsitem.athlete] logname] forState:UIControlStateNormal];
        _athleteButton.enabled = YES;
        _athleteButton.hidden = NO;
    }
    
    if (newsitem.game.length > 0) {
        [_gameButton setTitle:[[currentSettings findGame:newsitem.game ] vsOpponent] forState:UIControlStateNormal];
        _gameButton.enabled = YES;
        _gameButton.hidden = NO;
    }
    
    if (newsitem.coach.length > 0) {
        [_coachButton setTitle:[[currentSettings findCoach:newsitem.coach] fullname] forState:UIControlStateNormal];
        _coachButton.enabled = YES;
        _coachButton.hidden = NO;
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
    } else if ([segue.identifier isEqualToString:@"VideoClipSegue"]) {
        sportzteamsMovieViewController *destController = segue.destinationViewController;
        destController.videoid = newsitem.videoclip_id;
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

- (IBAction)imageButtonClicked:(id)sender {
    if (newsitem.videoclip_id.length > 0) {
        [self performSegueWithIdentifier:@"VideoClipSegue" sender:self];
    } else if (newsitem.athlete.length > 0) {
        [self performSegueWithIdentifier:@"PlayerInfoSegue" sender:self];
    } else if (newsitem.game.length > 0) {
        [self gameButtonClicked:self];
    } else if (newsitem.coach.length > 0) {
        [self performSegueWithIdentifier:@"CoachInfoSegue" sender:self];
    }
}

- (IBAction)athleteButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"PlayerInfoSegue" sender:self];
}

- (IBAction)coachButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"CoachInfoSegue" sender:self];
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

@end
