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
#import "UsersViewController.h"
#import "PhotoInfoViewController.h"
//#import "GamePlayViewController.h"
#import "GameScheduleViewController.h"


#import <QuartzCore/QuartzCore.h>

@interface PhotosViewController () <UIAlertViewDelegate>

@end

@implementation PhotosViewController {
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
@synthesize photos;
@synthesize activityIndicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.addButton, self.searchButton, self.featuredButton, self.teamButton, nil];
    
    self.navigationController.toolbarHidden = YES;
    activityIndicator.hidesWhenStopped = YES;
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
    
    if ([currentSettings.sport isPackageEnabled]) {
        if ((player) || (game) || (user))
            [self getPhotos];
        else if (photos)
            [self teamButtonClicked:self];
        
//        if (photos) {
//            [_collectionView reloadData];
//        }
    } else {
        [self displayUpgradeAlert];
    }
    [_collectionView reloadData];
}

- (void)displayUpgradeAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade Required"
                                    message:[NSString stringWithFormat:@"%@%@", @"Photo support not available for ", currentSettings.team.team_name]
                                    delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Info", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
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
    NSURL *url;
    
    if (currentSettings.user.authtoken)
        url = [NSURL URLWithString:[sportzServerInit getTeamPhotos:currentSettings.team.teamid Token:currentSettings.user.authtoken]];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                    @"/sports/", currentSettings.sport.id, @"/photos.json?team_id=", currentSettings.team.teamid]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [activityIndicator startAnimating];
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
    
//    if (photo.thumbimage) {
 //       cell.photoImage.image = photo.thumbimage;
//    } else {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:photo.thumbnail_url]];
            
            //this will set the image when loading is finished
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.photoImage.image = [UIImage imageWithData:image];
            });
        });
//    }
    
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        HeaderSelectCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                            withReuseIdentifier:@"PhotoHeaderCell" forIndexPath:indexPath];
        headerView.bannerImage.image = [currentSettings getBannerImage];
        
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
            [photos addObject:[[Photo alloc] initWithDirectory:[serverData objectAtIndex:i]]];
        }
        [activityIndicator stopAnimating];
        [_collectionView reloadData];
        
        if (photos.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Photos" message:@"Try a different search"
                                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem Retrieving Photo"
                                                        message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (IBAction)playerSelected:(UIStoryboardSegue *)segue {
    player = playerSelectionController.player;
    if (player) {
        game = nil;
        user = nil;
        photos = nil;
        [self getPhotos];
    }
    _playerContainer.hidden = YES;
}

- (IBAction)gameSelected:(UIStoryboardSegue *)segue {
    game = gameSelectionController.thegame;
    if (game) {
        player = nil;
        user = nil;
        photos = nil;
        [self getPhotos];
    }
    _gameContainer.hidden = YES;
}

- (IBAction)selectUser:(UIStoryboardSegue *)segue {
    user = userSelectController.user;
    if (userSelectController.user) {
        game = nil;
        player = nil;
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
        if (currentSettings.user.authtoken)
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",
                                        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/photos.json?team_id=",
                                        currentSettings.team.teamid, @"&athlete_id=", player.athleteid, @"&auth_token=", currentSettings.user.authtoken]];
        else
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                                                                      @"/sports/", currentSettings.sport.id, @"/photos.json?team_id=",
                                                                                      currentSettings.team.teamid, @"&athlete_id=", player.athleteid]];
    } else if (game) {
        if (currentSettings.user.authtoken)
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/photos.json?team_id=",
                                        currentSettings.team.teamid, @"&gameschedule_id=", game.id, @"&auth_token=", currentSettings.user.authtoken]];
        else
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/photos.json?team_id=",
                                        currentSettings.team.teamid, @"&gameschedule_id=", game.id]];
        
//    } else if (gamelog) {
//        url = [NSURL URLWithString:[BasketballServerInit getGameLogPhotos:gamelog.gamelogid Team:currentSettings.team.teamid Token:currentSettings.user.authtoken]];
    } else if (user) {
        if (currentSettings.user.authtoken)
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",
                                        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/photos.json?team_id=",
                                        currentSettings.team.teamid, @"&user_id=", currentSettings.user.userid,
                                        @"&auth_token=", currentSettings.user.authtoken]];
        else
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/photos.json?team_id=",
                                        currentSettings.team.teamid, @"&user_id=", currentSettings.user.userid]];
        
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [activityIndicator startAnimating];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (IBAction)searchButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search"
                        message:@"Select Photo Search Criteria"
                        delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Player", @"Game", @"User", @"All", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Player"]) {
        _playerContainer.hidden = NO;
        playerSelectionController.player = nil;
        [playerSelectionController viewWillAppear:YES];
    } else if ([title isEqualToString:@"Game"]) {
        _gameContainer.hidden = NO;
        gameSelectionController.thegame = nil;
        [gameSelectionController viewWillAppear:YES];
    } else if ([title isEqualToString:@"User"]) {
        _userSelectContainer.hidden = NO;
        userSelectController.user = nil;
        [userSelectController viewWillAppear:YES];
    } else if ([title isEqualToString:@"All"]) {
        game = nil;
        user = nil;
        player = nil;
        NSURL *url = [NSURL URLWithString:[sportzServerInit getTeamPhotos:currentSettings.team.teamid Token:currentSettings.user.authtoken]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [activityIndicator startAnimating];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    } else if ([title isEqualToString:@"Info"]) {
        [self performSegueWithIdentifier:@"UpgradeInfoSegue" sender:self];
    } else if ([title isEqualToString:@"Dismiss"]) {
        self.tabBarController.selectedIndex = 0;
    }
}

- (IBAction)changeTeamButtonClicked:(id)sender {
    currentSettings.team = nil;
    UITabBarController *tabBarController = self.tabBarController;
    
    for (UIViewController *viewController in tabBarController.viewControllers)
    {
        if ([viewController isKindOfClass:[UINavigationController class]])
            [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
    }
    
    UIView * fromView = tabBarController.selectedViewController.view;
    UIView * toView = [[tabBarController.viewControllers objectAtIndex:0] view];
    currentSettings.selectedTab = tabBarController.selectedIndex;
    
    // Transition using a page curl.
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:(4 > tabBarController.selectedIndex ? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown)
                    completion:^(BOOL finished) {
                        if (finished) {
                            tabBarController.selectedIndex = 0;
                        }
                    }];
}

- (IBAction)videoButtonClicked:(id)sender {
}

@end
