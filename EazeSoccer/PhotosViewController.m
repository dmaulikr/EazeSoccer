//
//  EazesportsSecondViewController.m
//  FootballStatsConsole
//
//  Created by Gil on 5/14/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "PhotosViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzServerInit.h"
#import "sportzCurrentSettings.h"
#import "HeaderSelectCollectionReusableView.h"

#import "Athlete.h"
#import "Photo.h"
#import "PhotoCell.h"
#import "User.h"

#import "PlayerSelectionViewController.h"
#import "GameScheduleViewController.h"
#import "UsersViewController.h"
#import "PhotoInfoViewController.h"
//#import "GamePlayViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface PhotosViewController ()

@end

@implementation PhotosViewController {
    NSMutableArray *photos;
    NSArray *serverData;
    NSMutableData *theData;
    int responseStatusCode;
        
    PlayerSelectionViewController *playerSelectionController;
    GameScheduleViewController *gameSelectionController;
    UsersViewController *userSelectController;
//    GamePlayViewController *gameplaySelectionController;
}

@synthesize player;
@synthesize game;
//@synthesize gamelog;
@synthesize user;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _playerContainer.hidden = YES;
    _gameContainer.hidden = YES;
    _userSelectContainer.hidden = YES;
    _activityIndicator.hidesWhenStopped = YES;
    
//    if ((player) || (gamelog) || (game) || (user))
    if ((player) || (game) || (user))
        [self getPhotos];
    else if (photos)
        [self teamButtonClicked:self];
    
    if (photos) {
        [_collectionView reloadData];
    }
}

- (IBAction)userButtonClicked:(id)sender {
    _userSelectContainer.hidden = NO;
}

- (IBAction)playerButtonClicked:(id)sender {
    _playerContainer.hidden = NO;
}

- (IBAction)gameButtonClicked:(id)sender {
    _gameContainer.hidden = NO;
}

- (IBAction)teamButtonClicked:(id)sender {
    game = nil;
    user = nil;
    player = nil;
    NSURL *url = [NSURL URLWithString:[sportzServerInit getTeamPhotos:currentSettings.team.teamid Token:currentSettings.user.authtoken]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_activityIndicator startAnimating];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (IBAction)refreshButtonClicked:(id)sender {
    [self viewWillAppear:YES];
}

- (IBAction)gamelogButtonClicked:(id)sender {
    if (game) {
//        gameplaySelectionController.game = game;
//        [gameplaySelectionController viewWillAppear:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Game Selected"
                             message:@"Select a game first. Big plays are associated with a game." delegate:self cancelButtonTitle:@"Ok"
                             otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [photos count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 6;
    cell.backgroundColor = [UIColor whiteColor];
    Photo *photo = [photos objectAtIndex:indexPath.row];
    UIImage *image;
    
    if (photo.thumbnail_url.length > 0) {
        NSURL *imageURL = [NSURL URLWithString:photo.thumbnail_url];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        image = [UIImage imageWithData:imageData];
    } else {
        image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_processing.png"], 1)];
    }
    
    [cell.photoImage setImage:image];
    [cell.photoLabel setText:photo.displayname];
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
    CGSize retval = CGSizeMake(150, 150);
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
                                                            withReuseIdentifier:@"PhotoHeaderCell" forIndexPath:indexPath];
        if (game != nil)
            headerView.headerLabel.text = game.game_name;
        else if (player != nil)
            headerView.headerLabel.text = player.logname;
//        else if (coach != nil)
//            headerView.headerLabel.text = coach.fullname;
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
        userSelectController = segue.destinationViewController;
//    } else if ([segue.identifier isEqualToString:@"GamePlaySelectSegue"]) {
//        gameplaySelectionController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"PhotoInfoSegue"]) {
        PhotoInfoViewController *destViewController = segue.destinationViewController;
        if ([[_collectionView indexPathsForSelectedItems] count] > 0) {
            NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
            Photo *photo = [photos objectAtIndex:indexPath.row];
            destViewController.photo = photo;
            photo.athletes = [[NSMutableArray alloc] init];
            for (int cnt = 0; cnt < [currentSettings.roster count]; cnt++) {
                for (int i = 0; i < [photo.players count]; i++) {
                    if ([[photo.players objectAtIndex:i] isEqualToString:[[currentSettings.roster objectAtIndex:cnt] athleteid]]) {
                        [photo.athletes addObject:[currentSettings.roster objectAtIndex:cnt]];
                    }
                }
            }
            for (int cnt = 0; cnt < [currentSettings.gameList count]; cnt++) {
                if ([[[currentSettings.gameList objectAtIndex:cnt] id] isEqualToString:photo.schedule]) {
                    photo.game = [currentSettings.gameList objectAtIndex:cnt];
                }
            }
        } else {
            destViewController.photo = nil;
        }
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
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    NSLog(@"%@", serverData);
    
    if (responseStatusCode == 200) {
        photos = [[NSMutableArray alloc] init];
        for (int i = 0; i < [serverData count]; i++) {
            NSDictionary *items = [serverData objectAtIndex:i];
            Photo *photo = [[Photo alloc] init];
            [photo parsePhoto:items];
            [photos addObject:photo];
        }
        [_activityIndicator stopAnimating];
        [_collectionView reloadData];
        
        if (photos.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Photos" message:@"Try a different search"
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem Retrieving Photo"
                                                        message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (IBAction)selectPhotoPlayer:(UIStoryboardSegue *)segue {
    player = playerSelectionController.player;
    if (player) {
        game = nil;
//        gamelog = nil;
        user = nil;
        photos = nil;
        [self getPhotos];
    }
    _playerContainer.hidden = YES;
}

- (IBAction)selectPhotoGame:(UIStoryboardSegue *)segue {
    game = gameSelectionController.thegame;
    if (game) {
        player = nil;
        user = nil;
//        gamelog = nil;
        photos = nil;
        [self getPhotos];
    }
    _gameContainer.hidden = YES;
}

- (IBAction)selectPhotoUser:(UIStoryboardSegue *)segue {
    user = userSelectController.user;
    if (userSelectController.user) {
        game = nil;
        player = nil;
//        gamelog = nil;
        photos = nil;
        [self getPhotos];
    }
    _userSelectContainer.hidden = YES;
}
/*
- (IBAction)selectPhotoGameLog:(UIStoryboardSegue *)segue {
    gamelog = gameplaySelectionController.play;
    if (gamelog) {
        game = nil;
        player = nil;
        photos = nil;
        user = nil;
        [self getPhotos];
    }
    _gamelogContainerView.hidden = YES;
}
*/
- (void)getPhotos {
    NSURL *url;
    
    if (player) {
        url = [NSURL URLWithString:[sportzServerInit getAthletePhotos:player.athleteid Team:currentSettings.team.teamid
                                                                       Token:currentSettings.user.authtoken]];
    } else if (game) {
        url = [NSURL URLWithString:[sportzServerInit getGamePhotos:game.id Team:currentSettings.team.teamid
                                                             Token:currentSettings.user.authtoken]];
//    } else if (gamelog) {
//        url = [NSURL URLWithString:[BasketballServerInit getGameLogPhotos:gamelog.gamelogid Team:currentSettings.team.teamid Token:currentSettings.user.authtoken]];
    } else if (user) {
        url = [NSURL URLWithString:[sportzServerInit getUserPhotos:user.userid Team:currentSettings.team.teamid
                                                                    Token:currentSettings.user.authtoken]];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_activityIndicator startAnimating];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

@end
