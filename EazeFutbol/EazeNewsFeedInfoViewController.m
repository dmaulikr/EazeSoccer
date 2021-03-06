
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
#import "NewsFeedEditViewController.h"
#import "EazesportzDisplayAdBannerViewController.h"
#import "EazeWebViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface EazeNewsFeedInfoViewController ()

@end

@implementation EazeNewsFeedInfoViewController {
    EazesportzDisplayAdBannerViewController *adbannerController;
}

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
    _newsTextView.layer.borderWidth = 1.0f;
    _newsTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    [_imageButton.imageView setClipsToBounds:YES];
    _imageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
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
        if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"])
            [_imageButton setImage:[currentSettings normalizedImage:newsitem.videoPoster scaledToSize:512] forState:UIControlStateNormal];
//            _imageView.image = [currentSettings normalizedImage:newsitem.videoPoster scaledToSize:512];
        else
            [_imageButton setImage:[currentSettings normalizedImage:newsitem.videoPoster scaledToSize:125] forState:UIControlStateNormal];
//            _imageView.image = [currentSettings normalizedImage:newsitem.videoPoster scaledToSize:125];
    } else if (((newsitem.tinyurl.length > 0) || (newsitem.thumburl.length > 0)) &&
               ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"])) {
        _imageButton.enabled = YES;
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:newsitem.thumburl]];
            [_imageButton setImage:[[UIImage alloc] initWithData:image] forState:UIControlStateNormal];
    } else if ((newsitem.mediumurl.length > 0) ||
               ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"])) {
        _imageButton.enabled = YES;
        NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:newsitem.mediumurl]];
        [_imageButton setImage:[UIImage imageWithData:image] forState:UIControlStateNormal];
    } else if (newsitem.athlete.length > 0) {
        _imageButton.enabled = YES;
        if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"])
            [_imageButton setImage:[currentSettings normalizedImage:
                                          [currentSettings getRosterMediumImage:[currentSettings findAthlete:newsitem.athlete]] scaledToSize:512] forState:UIControlStateNormal];
        else
            [_imageButton setImage:[currentSettings normalizedImage:
                                              [currentSettings getRosterThumbImage:[currentSettings findAthlete:newsitem.athlete]] scaledToSize:125] forState:UIControlStateNormal];
    } else if (newsitem.game.length > 0) {
        _imageButton.enabled = YES;
        if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"])
            [_imageButton setImage:[currentSettings normalizedImage:
                                          [currentSettings getOpponentImage:[currentSettings findGame:newsitem.game]] scaledToSize:512] forState:UIControlStateNormal];
        else
            [_imageButton setImage:[currentSettings normalizedImage:
                                              [currentSettings getOpponentImage:[currentSettings findGame:newsitem.game]] scaledToSize:50] forState:UIControlStateNormal];
    } else if (newsitem.coach.length > 0) {
        _imageButton.enabled = YES;
        if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"])
            [_imageButton setImage:[currentSettings normalizedImage:[[currentSettings findCoach:newsitem.coach] getImage:@"medium"] scaledToSize:512]
                      forState:UIControlStateNormal];
        else
            [_imageButton setImage:[currentSettings normalizedImage:[[currentSettings findCoach:newsitem.coach] getImage:@"thumb"] scaledToSize:125]
                                    forState:UIControlStateNormal];
    } else if (newsitem.team.length > 0) {
        [_imageButton setImage:[currentSettings normalizedImage:[currentSettings.team getImage:@"thumb"] scaledToSize:125]
                                forState:UIControlStateNormal];
    } else {
        [_imageButton setImage:[currentSettings normalizedImage:[currentSettings.sport getImage:@"thumb"] scaledToSize:125]
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
    
    
    if ([currentSettings isSiteOwner]) {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.editButton, nil];
    }
    
    self.navigationController.toolbarHidden = YES;
    
    if (currentSettings.sponsors.sponsors.count > 0)
        _bannerContainer.hidden = NO;
    else
        _bannerContainer.hidden = YES;
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
    } else if ([segue.identifier isEqualToString:@"EditNewsitemSegue"]) {
        NewsFeedEditViewController *destController = segue.destinationViewController;
        destController.newsitem = newsitem;
    } else if ([segue.identifier isEqualToString:@"AdDisplaySegue"]) {
        adbannerController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"NewsItemUrlSegue"]) {
        EazeWebViewController *destController = segue.destinationViewController;
        destController.external_url = [NSURL URLWithString:newsitem.external_url];
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (currentSettings.sport.hideAds) {
        _bannerView.hidden = YES;
        [adbannerController displayAd];
        _bannerContainer.hidden = NO;
    } else {
        _bannerContainer.hidden = YES;
        _bannerView.hidden = NO;
    }
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
    } else if (newsitem.thumburl.length > 0) {
        [self performSegueWithIdentifier:@"NewsItemUrlSegue" sender:self];
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

- (IBAction)notificationSwitchSelected:(id)sender {
}
@end
