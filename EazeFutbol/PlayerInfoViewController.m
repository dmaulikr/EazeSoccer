//
//  sportzteamsPlayerInfoViewController.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 3/27/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "PlayerInfoViewController.h"
#import "sportzServerInit.h"
#import "EazesportzAppDelegate.h"
//#import "sportzteamsGameScheduleJSON.h"
#import "EazeSoccerStatsViewController.h"
#import "EazeAlertViewController.h"
#import "EazePhotosViewController.h"
#import "EazesVideosViewController.h"
#import "EazeBasketballStatsViewController.h"
#import "EazeBballPlayerStatsViewController.h"
#import "EazeFootballPlayerStatsViewController.h"
#import "EazeSoccerPlayerStatsViewController.h"
#import "EazePlayerBioViewController.h"
#import "EditPlayerViewController.h"
#import "EazesportzDisplayAdBannerViewController.h"

@interface PlayerInfoViewController () <UIAlertViewDelegate>
@end

@implementation PlayerInfoViewController{
    NSArray *serverData;
    NSMutableData *theData;
    int responseStatusCode;
    
    BOOL follow;
    BOOL unfollow;
    
    EazesportzDisplayAdBannerViewController *adBannerController;
}


@synthesize player;

@synthesize playerImage;
@synthesize numberLabel;
@synthesize nameLabel;
@synthesize yearLabel;
@synthesize heightLabel;
@synthesize weightLabel;
@synthesize positionLabel;

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
    nameLabel.layer.cornerRadius = 6;
    yearLabel.layer.cornerRadius = 6;
    positionLabel.layer.cornerRadius = 6;
    heightLabel.layer.cornerRadius = 6;
    weightLabel.layer.cornerRadius = 6;
    positionLabel.layer.cornerRadius = 6;
    _yearTitleLabel.layer.cornerRadius = 6;
    _heightTitleLabel.layer.cornerRadius = 6;
    _followPlayerLabel.layer.cornerRadius = 6;
    _bioLabel.layer.cornerRadius = 6;
    _positionTitleLabel.layer.cornerRadius = 6;
    _weightTitleLabel.layer.cornerRadius = 6;
    _bioTextView.layer.cornerRadius = 6;
    
    [playerImage setClipsToBounds:YES];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.photoButton, self.videoButton, self.alertButton, self.statsButton, nil];
    
    self.navigationController.toolbarHidden = YES;
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([currentSettings getRosterMediumImage:player] == nil) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:player.mediumpic]];
            
            //this will set the image when loading is finished
            dispatch_async(dispatch_get_main_queue(), ^{
                playerImage.image = [UIImage imageWithData:image];
            });
        });
    } else {
        playerImage.image = [currentSettings getRosterMediumImage:player];
    }
    
    [self.numberLabel setText:[player.number stringValue]];
    [self.nameLabel setText:player.full_name];
    [self.yearLabel setText:player.year];
    [self.positionLabel setText:player.position];
    [self.heightLabel setText:player.height];
    [self.weightLabel setText:[player.weight stringValue]];
    _bioTextView.text = player.bio;
    
    if ([currentSettings hasAlerts:[player athleteid]] == NO) {
        _alertButton.enabled = NO;
    }
    
    if ([player.following boolValue]) {
        [_followSwitch setOn:YES];
    } else {
        [_followSwitch setOn:NO];
    }
    
    if (!player.hasphotos) {
        _photoButton.enabled = NO;
    }
    
    if (!player.hasvideos) {
        _videoButton.enabled = NO;
    }
    
    if ([currentSettings isSiteOwner]) {
        _editButton.enabled = YES;
        _editButton.hidden = NO;
    } else {
        _editButton.enabled = NO;
        _editButton.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayerStatsSegue"]) {
        EazeSoccerStatsViewController *destViewController = segue.destinationViewController;
        destViewController.athlete = player;
    } else if ([segue.identifier isEqualToString:@"AlertListSegue"]) {
        EazeAlertViewController *destViewController = segue.destinationViewController;
        destViewController.player = player;
    } else if ([segue.identifier isEqualToString:@"PlayerPhotosSegue"] ) {
        EazePhotosViewController *destController = segue.destinationViewController;
        destController.player = player;
        currentSettings.photodeleted = YES;
    } else if ([segue.identifier isEqualToString:@"PlayerVideosSegue"]) {
        EazesVideosViewController *destController = segue.destinationViewController;
        destController.player = player;
    } else if ([segue.identifier isEqualToString:@"BasketballPlayerStatsSegue"]) {
        EazeBballPlayerStatsViewController *destController = segue.destinationViewController;
        destController.player = player;
    } else if ([segue.identifier isEqualToString:@"FootballPlayerStatsSegue"]) {
        EazeFootballPlayerStatsViewController *destController = segue.destinationViewController;
        destController.player = player;
    } else if ([segue.identifier isEqualToString:@"SoccerPlayerStatsSegue"]) {
        EazeSoccerPlayerStatsViewController *destController = segue.destinationViewController;
        destController.player = player;
    } else if ([segue.identifier isEqualToString:@"PlayerBioSegue"]) {
        EazePlayerBioViewController *destController = segue.destinationViewController;
        destController.player = player;
    } else if ([segue.identifier isEqualToString:@"EditPlayerSegue"]) {
        EditPlayerViewController *destController = segue.destinationViewController;
        destController.player = player;
    } else if ([segue.identifier isEqualToString:@"AdDisplaySegue"]) {
        adBannerController = segue.destinationViewController;
    }
}

- (void)displayUpgradeAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade Required"
                                                    message:[NSString stringWithFormat:@"%@%@%@", @"Stats not available for ",
                                                             player.logname, @". Contact your administrator with questions."]
                                                   delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (currentSettings.sport.hideAds) {
        _bannerView.hidden = YES;
        _adBannerContainer.hidden = NO;
        [adBannerController displayPlayerAd:player];
    } else {
        _adBannerContainer.hidden = YES;
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

- (IBAction)followPlayerSwitch:(id)sender {
    if (currentSettings.user.userid.length > 0) {
        if ([_followSwitch isOn]) {
            follow = YES;
            NSURL *url = [NSURL URLWithString:[sportzServerInit followAthlete:[player athleteid] Token:currentSettings.user.authtoken]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [[NSURLConnection alloc] initWithRequest:request delegate:self];
        } else {
            unfollow = YES;
            NSURL *url = [NSURL URLWithString:[sportzServerInit unfollowAthlete:[player athleteid] Token:currentSettings.user.authtoken]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"You must login to follow players."
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    responseStatusCode = [httpResponse statusCode];
    theData = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [theData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The download cound not complete - please make sure you're connected to either 3G or WI-FI" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:nil error:nil];
    NSLog(@"%@", serverData);
    
    if (responseStatusCode == 200) {
        UIAlertView *alert;
        if (follow) {
            follow = NO;
            player.following = [NSNumber numberWithBool:YES];
            alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                         message:[NSString stringWithFormat:@"%@%@", @"Now following: ", [player name]]
                                         delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        } else if (unfollow) {
            unfollow = NO;
            player.following = [NSNumber numberWithBool:NO];
            alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                         message:[NSString stringWithFormat:@"%@%@", @"Stopped following: ", [player name]]
                                         delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        }
        
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        [self viewWillAppear:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Alerts"
                                                        message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (IBAction)statButtonClicked:(id)sender {
    if ([currentSettings.sport.name isEqualToString:@"Football"]) {
        [self performSegueWithIdentifier:@"FootballPlayerStatsSegue" sender:self];
    } else if ([currentSettings.sport.name isEqualToString:@"Basketball"]) {
        [self performSegueWithIdentifier:@"BasketballPlayerStatsSegue" sender:self];
    } else if ([currentSettings.sport.name isEqualToString:@"Soccer"]) {
        [self performSegueWithIdentifier:@"SoccerPlayerStatsSegue" sender:self];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Login"]) {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
}

@end
