//
//  sportzteamsPhotoDescriptionViewController.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/5/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "sportzteamsPhotoDescriptionViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "EazesportzSoccerGameSummaryViewController.h"
#import "PlayerInfoViewController.h"
#import "EazeBasketballGameSummaryViewController.h"
#import "EazesportzSoccerGameSummaryViewController.h"
#import "EazeFootballGameSummaryViewController.h"
#import "PhotoInfoViewController.h"
#import "EazesportzDisplayAdBannerViewController.h"

@interface sportzteamsPhotoDescriptionViewController ()

@end

@implementation sportzteamsPhotoDescriptionViewController {
    EazesportzDisplayAdBannerViewController *adBannerController;
}

@synthesize photo;
@synthesize photoDescriptionText;
@synthesize photoNameLabel;

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
    _gameButton.layer.cornerRadius = 6;
    photoNameLabel.layer.cornerRadius = 6;
    _playerTableView.layer.cornerRadius = 6;
    _descriptionLabel.layer.cornerRadius = 6;
    _photoTitleLabel.layer.cornerRadius = 6;
    _gameTagLabel.layer.cornerRadius = 6;
    _playersTagLabel.layer.cornerRadius = 6;
//    self.view.backgroundColor = [UIColor clearColor];
    photoDescriptionText.layer.borderWidth = 1.0f;
    photoDescriptionText.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    if (currentSettings.sport.hideAds) {
        _bannerView.hidden = YES;
        _adBannerContainer.hidden = NO;
        [adBannerController displayAd];
    } else {
        _adBannerContainer.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (photo) {
        [photoDescriptionText setText:photo.description];
        [photoNameLabel setText:photo.displayname];
        
        if (photo.schedule.length > 0) {
            [_gameButton setTitle:[NSString stringWithFormat:@"%@%@", @"vs. ", [[currentSettings findGame:photo.schedule] opponent]]
                                                    forState:UIControlStateNormal];
            [_gameButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            _gameButton.enabled = YES;
        } else {
            [_gameButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            _gameButton.enabled = NO;
        }
        
        if ([photo.athletes count] > 0) {
            NSString *thePlayers = [[photo.athletes objectAtIndex:0] name];
            thePlayers = [thePlayers stringByAppendingString:@"\n"];
            if ([photo.athletes count] > 1) {
                for (int i = 1; i < [photo.athletes count]; i++) {
                    thePlayers = [thePlayers stringByAppendingString:[[photo.athletes objectAtIndex:i] name]];
                    thePlayers = [thePlayers stringByAppendingString:@"\n"];
                }
            }
        } else {
        }
        
        if (photo.pending)
            self.title = @"Pending Approval";
        else
            self.title = photo.displayname;
        
        [_playerTableView reloadData];
    } else {
        
    }
    
    _playButton.hidden = YES;
    _playLabel.hidden = YES;
    
    if (([currentSettings isSiteOwner]) || ([currentSettings.user.userid isEqualToString:photo.user_id])) {
        self.navigationItem.rightBarButtonItem = self.editBarButton;
    }
    
    self.navigationController.toolbarHidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [photo.players count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlayerTags";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Athlete *player = [currentSettings findAthlete:[photo.players objectAtIndex:indexPath.row]];
    
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.text = player.full_name;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Players - Swipe to delete";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //    NSString *cellText = cell.textLabel.text;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GameInfoSegue"]) {
        EazesportzSoccerGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings findGame:photo.schedule];
    } else if ([segue.identifier isEqualToString:@"PlayerInfoSegue"]) {
        NSIndexPath *indexPath = [_playerTableView indexPathForSelectedRow];
        PlayerInfoViewController *destController = segue.destinationViewController;
        destController.player = [currentSettings findAthlete:[photo.players objectAtIndex:indexPath.row]];
    } else if ([segue.identifier isEqualToString:@"BasketballGameInfoSegue"]) {
        EazeBasketballGameSummaryViewController *destController = segue .destinationViewController;
        destController.game = [currentSettings findGame:photo.schedule];
    } else if ([segue.identifier isEqualToString:@"FootballGameInfoSegue"]) {
        EazeFootballGameSummaryViewController *destController = segue .destinationViewController;
        destController.game = [currentSettings findGame:photo.schedule];
    } else if ([segue.identifier isEqualToString:@"SoccerGameInfoSegue"]) {
        EazesportzSoccerGameSummaryViewController *destController = segue .destinationViewController;
        destController.game = [currentSettings findGame:photo.schedule];
    } else if ([segue.identifier isEqualToString:@"EditPhotoSegue"]) {
        PhotoInfoViewController *destController = segue.destinationViewController;
        destController.photo = photo;
    } else if ([segue.identifier isEqualToString:@"AdDisplaySegue"]) {
        adBannerController = segue.destinationViewController;
    }
}

- (IBAction)gameButtonClicked:(id)sender {
    if ([currentSettings.sport.name isEqualToString:@"Football"])
        [self performSegueWithIdentifier:@"FootballGameInfoSegue" sender:self];
    else if ([currentSettings.sport.name isEqualToString:@"Basketball"])
        [self performSegueWithIdentifier:@"BaseketballGameInfoSegue" sender:self];
    else if ([currentSettings.sport.name isEqualToString:@"Soccer"]) {
        [self performSegueWithIdentifier:@"SoccerGameInfoSegue" sender:self];
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

@end
