//
//  sportzteamsMovieViewController.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/6/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "sportzteamsMovieViewController.h"
#import "sportzServerInit.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "EazesportzSoccerGameSummaryViewController.h"
#import "PlayerInfoViewController.h"
#import "EazeBasketballGameSummaryViewController.h"
#import "EazeFootballGameSummaryViewController.h"
#import "EazesportzSoccerGameSummaryViewController.h"
#import "EazesportzFootballVideoInfoViewController.h"
#import "EazesportzCheckAdImageViewController.h"

@interface sportzteamsMovieViewController ()

@end

@implementation sportzteamsMovieViewController {
    NSDictionary *serverData;
    NSMutableData *theData;
    int responseStatusCode;

    EazesportzCheckAdImageViewController *adController;
}

@synthesize videoclip;
@synthesize videoid;

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
    _gameButton.layer.cornerRadius = 6;
    _playerTagTableView.layer.cornerRadius = 6;
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _adContainer.hidden = YES;
    
    if (videoid == nil) {
        NSURL * imageURL = [NSURL URLWithString:videoclip.poster_url];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        [_videoImage setImage:image];
        
        if (videoclip.schedule.length > 0) {
            _gameButton.enabled = YES;
            [_gameButton setTitle:[[currentSettings findGame:videoclip.schedule] vsOpponent] forState:UIControlStateNormal];
            _gameButtonLabel.text = [[currentSettings findGame:videoclip.schedule] vsOpponent];
        } else {
            _gameButton .hidden = YES;
            _gameButtonLabel.hidden = YES;
            _gameButton.enabled = NO;
        }
        
        [_playerTagTableView reloadData];
     } else {
        NSURL *url;
        
        if (currentSettings.user.authtoken)
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/videoclips/", videoid, @".json?auth_token=",
                                        currentSettings.user.authtoken]];
        else
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/videoclips/", videoid, @".json"]];
        
        NSLog(@"%@", url);
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    
    if (videoclip.pending)
        self.title = @"Pending Approval";
    else
        self.title = videoclip.displayName;
    
    if (currentSettings.sport.hideAds)
        _bannerView.hidden = YES;
    
    if (([currentSettings isSiteOwner]) || ([currentSettings.user.userid isEqualToString:videoclip.userid]))
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.playBarButton, self.editBarButton, nil];
    else
        self.navigationItem.rightBarButtonItem = self.playBarButton;
    
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return videoclip.players.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlayerTagCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Athlete *aplayer = [currentSettings findAthlete:[videoclip.players objectAtIndex:indexPath.row]];
    cell.textLabel.font = [UIFont fontWithName:@"ArialMT" size:12];
    cell.textLabel.text = aplayer.logname;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (videoclip.players.count > 0)
        return @"Tagged Players";
    else
        return @"No players tagged for this video";
}

- (IBAction)playButtonClicked:(id)sender {
    NSURL *url = [NSURL URLWithString:videoclip.video_url];
    
    _moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(moviePlayBackDidFinish:)
                                          name:MPMoviePlayerPlaybackDidFinishNotification
                                          object:_moviePlayer];
    
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:YES animated:YES];
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                          name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    
    if ([player respondsToSelector:@selector(setFullscreen:animated:)]) {
        [player.view removeFromSuperview];
    }
    
    if (currentSettings.sponsors.sponsors.count > 0) {
        _adContainer.hidden = NO;
        adController.sponsor = nil;
        [adController viewWillAppear:YES];
    }
}

- (void)closeAdSponsor:(UIStoryboardSegue *)segue {
    _adContainer.hidden = YES;
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
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    NSLog(@"%@", serverData);
    
    if (responseStatusCode == 200) {
        Video *avideo = [[Video alloc] initWithDirectory:serverData];
        videoclip = avideo;
        videoid = nil;
        [self viewWillAppear:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem Retrieving Video Clip"
                                                        message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GameInfoSegue"]) {
        EazesportzSoccerGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings findGame:videoclip.schedule];
    } else if ([segue.identifier isEqualToString:@"PlayerInfoSegue"]) {
        PlayerInfoViewController *destController = segue.destinationViewController;
        destController.player = [currentSettings findAthlete:[videoclip.players objectAtIndex:[[_playerTagTableView indexPathForSelectedRow] row]]];
    } else if ([segue.identifier isEqualToString:@"BasketballGameInfoSegue"]) {
        EazeBasketballGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings findGame:videoclip.schedule];
    } else if ([segue.identifier isEqualToString:@"FootballGameInfoSegue"]) {
        EazeFootballGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings findGame:videoclip.schedule];
    }  else if ([segue.identifier isEqualToString:@"SoccerGameInfoSegue"]) {
        EazesportzSoccerGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings findGame:videoclip.schedule];
    } else if ([segue.identifier isEqualToString:@"EditVideoSegue"]) {
        EazesportzFootballVideoInfoViewController *destController = segue.destinationViewController;
        videoclip.athletes = [[NSMutableArray alloc] init];
        for (int cnt = 0; cnt < [currentSettings.roster count]; cnt++) {
            for (int i = 0; i < [videoclip.players count]; i++) {
                if ([[videoclip.players objectAtIndex:i] isEqualToString:[[currentSettings.roster objectAtIndex:cnt] athleteid]]) {
                    [videoclip.athletes addObject:[currentSettings.roster objectAtIndex:cnt]];
                }
            }
        }
        destController.video = videoclip;
    } else if ([segue.identifier isEqualToString:@"AdSegue"]) {
        adController = segue.destinationViewController;
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

- (IBAction)gameButtonClicked:(id)sender {
    if ([currentSettings.sport.name isEqualToString:@"Football"]) {
        [self performSegueWithIdentifier:@"FootballGameInfoSegue" sender:self];
    } else if ([currentSettings.sport.name isEqualToString:@"Bsketball"]) {
        [self performSegueWithIdentifier:@"BasketballGameInfoSegue" sender:self];
    } else if ([currentSettings.sport.name isEqualToString:@"Soccer"]) {
        [self performSegueWithIdentifier:@"SoccerGameInfoSegue" sender:self];
    }
}

@end
