//
//  EazesVideosViewController.m
//  EazeSportz
//
//  Created by Gil on 11/14/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesVideosViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazeUsersSelectViewController.h"
#import "EazePlayerSelectViewController.h"
#import "EazeGameSelectionViewController.h"
#import "sportzteamsMovieViewController.h"
#import "sportzServerInit.h"
#import "VideoCell.h"
#import "EazesportzGameLogViewController.h"

@interface EazesVideosViewController ()

@end

@implementation EazesVideosViewController {
    PlayerSelectionViewController *playerSelectController;
    EazeGameSelectionViewController *gameSelectController;
    EazeUsersSelectViewController *usersSelectController;
    EazesportzGameLogViewController *gamelogSelectController;
 }

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
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.searchButton, nil];
    
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    if (currentSettings.sport.id.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Please select a site before continuing"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    } else {
        if (playerSelectController) {
            if (playerSelectController.player)
                self.player = playerSelectController.player;
        } else if (gameSelectController) {
            if (gameSelectController.thegame)
                self.game = gameSelectController.thegame;
        } else if (usersSelectController) {
            if (usersSelectController.user)
                self.user = usersSelectController.user;
        }
        
        if (gamelogSelectController) {
            if (gamelogSelectController.game) {
                self.gamelog = gamelogSelectController.gamelog;
            }
        }
        
        [super viewWillAppear:animated];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 6;
    cell.backgroundColor = [UIColor whiteColor];
    Video *video = [self.videos objectAtIndex:indexPath.row];
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //this will start the image loading in bg
    dispatch_async(concurrentQueue, ^{
        NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:video.poster_url]];
        
        //this will set the image when loading is finished
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.videoImage.image = [UIImage imageWithData:image];
        });
    });
    
    [cell.videoName setText:video.displayName];
    [cell.videoDuration setText:[NSString stringWithFormat:@"%d", video.duration.intValue]];
    
    if (video.schedule.length > 0) {
        cell.gametagLabel.hidden = NO;
        cell.gametagLabel.text = [[currentSettings findGame:video.schedule] vsOpponent];
    } else
        cell.gametagLabel.hidden = YES;
    
    return cell;
}

- (IBAction)searchButtonClicked:(id)sender {
    UIAlertView *alert;
    
    if ([currentSettings.sport.name isEqualToString:@"Football"]) {
        alert = [[UIAlertView alloc] initWithTitle:@"Search" message:@"Select Video Search Criteria"
                                        delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Player", @"Game", @"Play", @"User", @"All", nil];
    } else {
         alert = [[UIAlertView alloc] initWithTitle:@"Search" message:@"Select Video Search Criteria"
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Player", @"Game", @"User", @"All", nil];
    }
    
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayerSelectSegue"]) {
        playerSelectController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"GameSelectSegue"]) {
        gameSelectController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"VideoPlaySegue"]) {
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        sportzteamsMovieViewController *destViewController = segue.destinationViewController;
        destViewController.videoclip = [self.videos objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"UserSelectSegue"]) {
        usersSelectController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"GamePlaySelectSegue"]) {
        gamelogSelectController = segue.destinationViewController;
        gamelogSelectController.game = gameSelectController.thegame;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Player"]) {
        self.game = nil;
        self.user = nil;
        gameSelectController = nil;
        gamelogSelectController.game = nil;
        [self performSegueWithIdentifier:@"PlayerSelectSegue" sender:self];
    } else if ([title isEqualToString:@"Game"]) {
        self.player = nil;
        self.user = nil;
        playerSelectController = nil;
        gamelogSelectController.game = nil;
        [self performSegueWithIdentifier:@"GameSelectSegue" sender:self];
    } else if ([title isEqualToString:@"Play"]) {
        self.player = nil;
        self.user = nil;
        playerSelectController = nil;
        
        if (gameSelectController.thegame)
            [self performSegueWithIdentifier:@"GamePlaySelectSegue" sender:self];
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Game must be selected before searching by play"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else if ([title isEqualToString:@"User"]) {
        self.player = nil;
        self.game = nil;
        gamelogSelectController.game = nil;
       [self performSegueWithIdentifier:@"UserSelectSegue" sender:self];
    } else if ([title isEqualToString:@"All"]) {
        self.game = nil;
        self.user = nil;
        self.player = nil;
        gamelogSelectController.game = nil;
        
        [super retrieveVideos];
    }
}

@end
