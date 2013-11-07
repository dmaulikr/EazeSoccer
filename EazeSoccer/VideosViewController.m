//
//  VideosViewController.m
//  FootballStatsConsole
//
//  Created by Gil on 5/15/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "VideosViewController.h"

#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "sportzServerInit.h"

#import "HeaderSelectCollectionReusableView.h"
#import "VideoCell.h"
#import "Video.h"

#import "GameScheduleViewController.h"
#import "PlayerSelectionViewController.h"
#import "UsersViewController.h"
#import "VideoInfoViewController.h"
//#import "GamePlayViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface VideosViewController ()

@end

@implementation VideosViewController {
    NSMutableArray *videos, *serverData;
    int responseStatusCode;
    NSMutableData *theData;
    
    GameScheduleViewController *gameSelectionController;
    PlayerSelectionViewController *playerSelectionController;
    UsersViewController *userSelectionController;
}

@synthesize player;
@synthesize game;
@synthesize user;
//@synthesize gamelog;

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
    _activityIndicator.hidesWhenStopped = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _gameSelectContainer.hidden = YES;
    _playerSelectContainer.hidden = YES;
    _userSelectionContainer.hidden = YES;
    
//    if ((player) || (gamelog) || (game) || (user)) {
    
    if ((player) || (game) || (user)) {
        [self getVideos];
    } else if (videos) {
        [self teamButtonClicked:self];
    }
    
    if (videos)
        [_collectionView reloadData];    
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
    [_activityIndicator stopAnimating];
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:nil error:nil];
    
    if (responseStatusCode == 200) {
        videos = [[NSMutableArray alloc] init];
        for (int i = 0; i < [serverData count]; i++) {
            [videos addObject:[[Video alloc] initWithDirectory:[serverData objectAtIndex:i]]];
        }
        [_collectionView reloadData];
        
        if (videos.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Videos" message:@"Try a different search"
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem Retrieving Videos"
                                                        message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (IBAction)selectVideoGame:(UIStoryboardSegue *)segue {
    game = gameSelectionController.thegame;
    if (game) {
        player = nil;
        user = nil;
        videos = nil;
//        gamelog = nil;
        [self getVideos];
    }
    _gameSelectContainer.hidden = YES;
}

- (IBAction)selectVideoPlayer:(UIStoryboardSegue *)segue {
    player = playerSelectionController.player;
    if (player) {
        game = nil;
        user = nil;
        videos = nil;
//        gamelog = nil;
        [self getVideos];
    }
    _playerSelectContainer.hidden = YES;
}

- (IBAction)selectvideoUser:(UIStoryboardSegue *)segue {
    user = userSelectionController.user;
    if (user) {
        player = nil;
        user = nil;
        videos = nil;
//        gamelog = nil;
        [self getVideos];
    }
    _userSelectionContainer.hidden = YES;
}
/*
- (IBAction)selectVideoGameLog:(UIStoryboardSegue *)segue {
    gamelog = gameplaySelectionController.play;
    if (gamelog) {
        player = nil;
        videos = nil;
        user = nil;
        game = nil;
        [self getVideos];
    }
    _gamelogSelectContainer.hidden = YES;
}
*/
#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [videos count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 6;
    cell.backgroundColor = [UIColor whiteColor];
    Video *video = [videos objectAtIndex:indexPath.row];
    NSURL * imageURL = [NSURL URLWithString:video.poster_url];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    [cell.videoImage setImage:image];
    [cell.videoName setText:video.displayName];
    [cell.videoDuration setText:[NSString stringWithFormat:@"%d", video.duration.intValue]];
    return cell;
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
    //    [self performSegueWithIdentifier:@"RosterInfoSegue" sender:self];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval = CGSizeMake(320, 160);
    return retval;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        HeaderSelectCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                        withReuseIdentifier:@"VideoHeaderCell" forIndexPath:indexPath];
        headerView.bannerImage.image = [currentSettings getBannerImage];
        
        if (game != nil)
            headerView.headerLabel.text = game.game_name;
        else if (player != nil)
            headerView.headerLabel.text = player.logname;
        else if (user != nil)
            headerView.headerLabel.text = user.username;
        else
            headerView.headerLabel.text = currentSettings.team.team_name;
        
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterCell" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayerSelectSegue"]) {
        playerSelectionController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"GameSelectSegue"]) {
        gameSelectionController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"UserSelectSegue"]) {
        userSelectionController = segue.destinationViewController;
//    } else if ([segue.identifier isEqualToString:@"GamePlaySelectSegue"]) {
//       gameplaySelectionController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"VideoInfoSegue"]) {
        VideoInfoViewController *destViewController = segue.destinationViewController;
        if ([[_collectionView indexPathsForSelectedItems] count] > 0) {
            NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
            Video *video = [videos objectAtIndex:indexPath.row];
            destViewController.video = video;
            video.athletes = [[NSMutableArray alloc] init];
            for (int cnt = 0; cnt < [currentSettings.roster count]; cnt++) {
                for (int i = 0; i < [video.players count]; i++) {
                    if ([[video.players objectAtIndex:i] isEqualToString:[[currentSettings.roster objectAtIndex:cnt] athleteid]]) {
                        [video.athletes addObject:[currentSettings.roster objectAtIndex:cnt]];
                    }
                }
            }
            for (int cnt = 0; cnt < [currentSettings.gameList count]; cnt++) {
                if ([[[currentSettings.gameList objectAtIndex:cnt] id] isEqualToString:video.schedule]) {
                    video.game = [currentSettings.gameList objectAtIndex:cnt];
                }
            }
        } else {
            destViewController.video = nil;
        }
    }
}

- (IBAction)gameButtonClicked:(id)sender {
    _gameSelectContainer.hidden = NO;
}

- (IBAction)playerButtonClicked:(id)sender {
    _playerSelectContainer.hidden = NO;
}

- (IBAction)userButtonClicked:(id)sender {
    _userSelectionContainer.hidden = NO;
}

- (IBAction)teamButtonClicked:(id)sender {
    player = nil;
    game = nil;
    user = nil;
    NSURL *url = [NSURL URLWithString:[sportzServerInit getTeamVideos:currentSettings.team.teamid Token:currentSettings.user.authtoken]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_activityIndicator startAnimating];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)getVideos {
    NSURL *url;
    
    if (player) {
        url = [NSURL URLWithString:[sportzServerInit getAthleteVideos:player.athleteid Team:currentSettings.team.teamid
                                                                Token:currentSettings.user.authtoken]];
    } else if (game) {
        url = [NSURL URLWithString:[sportzServerInit getGameVideos:game.id Team:currentSettings.team.teamid
                                                             Token:currentSettings.user.authtoken]];
//    } else if (gamelog) {
//        url = [NSURL URLWithString:[sportzServerInit getGameLogVideos:gamelog.gamelogid Team:currentSettings.team.teamid
//                                                                Token:currentSettings.user.authtoken]];
    } else if (user) {
        url = [NSURL URLWithString:[sportzServerInit getUserVideos:user.userid Team:currentSettings.team.teamid
                                                             Token:currentSettings.user.authtoken]];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_activityIndicator startAnimating];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

@end
