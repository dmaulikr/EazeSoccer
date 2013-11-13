//
//  sportzteamsPhotoVideoSelectViewController.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/5/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "PhotoVideoSelectViewController.h"
#import "EazesportzAppDelegate.h"
#import "PhotosCollectionViewController.h"
#import "sportzteamsVideoCollectionViewController.h"
#import "sportzServerInit.h"
#import "PlayerSelectionViewController.h"
#import "GameScheduleViewController.h"
#import "PlayerInfoViewController.h"
#import "EazesportzSoccerGameSummaryViewController.h"

@interface PhotoVideoSelectViewController ()

@end

@implementation PhotoVideoSelectViewController {
    NSArray *serverData;
    NSMutableData *theData;
    int responseStatusCode;
    UIActionSheet *actionSheet;
    BOOL games;
    BOOL photos;
    GameSchedule *game;
    Athlete *player;
    
    PlayerSelectionViewController *playerSelectController;
    GameScheduleViewController *gameSelectController;
}

@synthesize selectSegmentControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        photos = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _playerTextField.inputView = playerSelectController.inputView;
    _gameTextField.inputView = gameSelectController.inputView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    player = nil;
    _playerSelectContainer.hidden = YES;
    _playerButton.enabled = NO;
    [_playerButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _playerTextField.text = @"";
    
    game = nil;
    _gameScheduleContainer.hidden = YES;
    _gameButton.enabled = NO;
    [_gameButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _gameTextField.text = @"";
    
    
    if (selectSegmentControl.selectedSegmentIndex == 0){
		photos = YES;
        games = YES;
	} else if(selectSegmentControl.selectedSegmentIndex == 1){
        photos = NO;
        games = NO;
	}
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectSegmentClicked:(id)sender {
    if (selectSegmentControl.selectedSegmentIndex == 0) {
		photos = YES;
	} else if(selectSegmentControl.selectedSegmentIndex == 1) {
        photos = NO;
	}
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _playerTextField) {
        _playerSelectContainer.hidden = NO;
        playerSelectController.player = nil;
        [playerSelectController viewWillAppear:YES];
        [_playerTextField resignFirstResponder];
    } else if (textField == _gameTextField) {
        _gameScheduleContainer.hidden = NO;
        gameSelectController.thegame = nil;
        [gameSelectController viewWillAppear:YES];
        [_gameTextField resignFirstResponder];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PhotoSegue"]) {
        PhotosCollectionViewController *destViewController = segue.destinationViewController;
        if ((player != nil) && (game != nil)) {
            destViewController.player = player;
            destViewController.game = game;
        } else if (player != nil) {
            destViewController.player = player;
        } else {
            destViewController.game = game;
        }
    } else if ([segue.identifier isEqualToString:@"VideoSegue"]) {
        sportzteamsVideoCollectionViewController *destViewController = segue.destinationViewController;
        if (player != nil) {
            destViewController.player = player;
            destViewController.game = game;
        } else if (player != nil) {
            destViewController.player = player;            
        }else {
            destViewController.game = game;
        }
    } else if ([segue.identifier isEqualToString:@"PlayerSelectSegue"]) {
        playerSelectController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"GameSelectSegue"]) {
        gameSelectController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"PlayerInfoSegue"]) {
        PlayerInfoViewController *destController = segue.destinationViewController;
        destController.player = player;
    } else if ([segue.identifier isEqualToString:@"GameInfoSegue"]) {
        EazesportzSoccerGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = game;
    }
}

- (IBAction)submitButtonClicked:(id)sender {
    if (currentSettings.user.isBasic) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade for Photo and Video"
                             message:@"Click settings to upgrade for photo and videos!" delegate:self cancelButtonTitle:@"Ok"
                             otherButtonTitles:nil, nil];
        
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        if (photos) {
            [self performSegueWithIdentifier:@"PhotoSegue" sender:self];
        } else {
            [self performSegueWithIdentifier:@"VideoSegue" sender:self];
        }
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
//    banner.frame = CGRectOffset(banner.frame, 0, -100);
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
//    banner.frame = CGRectOffset(banner.frame, 0, 460);
    _bannerView.hidden = YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)selectPhotoVideoPlayer:(UIStoryboardSegue *)segue {
    player = playerSelectController.player;
    
    if (player) {
        _playerTextField.text = player.logname;
        _playerButton.enabled = YES;
        [_playerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    } else {
        player = nil;
        _playerTextField.text = @"";
        _playerButton.enabled = NO;
        [_playerButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    _playerSelectContainer.hidden = YES;
}

- (IBAction)selectPhotoVideoGame:(UIStoryboardSegue *)segue {
    game = gameSelectController.thegame;
    
    if (game) {
        _gameTextField.text = game.game_name;
        _gameButton.enabled = YES;
        [_gameButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    } else {
        game = nil;
        _gameTextField.text = @"";
        _gameButton.enabled = NO;
        [_gameButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    _gameScheduleContainer.hidden = YES;
}

@end
