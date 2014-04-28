//
//  EazePhotosViewController.m
//  EazeSportz
//
//  Created by Gil on 11/13/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazePhotosViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzServerInit.h"
#import "sportzteamsPhotoInfoViewController.h"
#import "EazesVideosViewController.h"
#import "EazesportzGameLogViewController.h"
#import "EazesportzDisplayAdBannerViewController.h"

@interface EazePhotosViewController () <UIAlertViewDelegate>

@end

@implementation EazePhotosViewController {
    EazesportzGameLogViewController *gamelogController;
    EazesportzDisplayAdBannerViewController *adBannerController;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    _gamelogContainer.hidden = YES;
    
    if (currentSettings.sport.id.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Please select a site before continuing"
                                                       delegate:nil cancelButtonTitle:@"Select Site" otherButtonTitles:nil, nil];
        
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        [super viewWillAppear:animated];
    }
    
    if (currentSettings.sport.hideAds) {
        _bannerView.hidden = YES;
        _adBannerContainer.hidden = NO;
        [adBannerController viewWillAppear:YES];
    } else {
        _adBannerContainer.hidden = YES;
    }
    
    if (([currentSettings isSiteOwner]) || (currentSettings.sport.enable_user_pics)) {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.searchButton, self.videoButton, self.addPhotoButton, nil];
    } else {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.searchButton, self.videoButton, nil];
    }
    
    self.navigationController.toolbarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (IBAction)searchBlogGameLog:(UIStoryboardSegue *)segue {
    _gamelogContainer.hidden = YES;
    
    if (gamelogController.gamelog) {
        NSString *urlstring = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                              @"/sports/", currentSettings.sport.id, @"/photos.json?team_id=", currentSettings.team.teamid, @"&gameschedule_id=",
                               self.game.id, @"&gamelog_id=", gamelogController.gamelog.gamelogid];
        
        if ([currentSettings isSiteOwner])
            urlstring = [urlstring stringByAppendingFormat:@"&auth_token=%@", currentSettings.user.authtoken];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstring]];
        [self.activityIndicator startAnimating];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

- (void)displayUpgradeAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                    message:[NSString stringWithFormat:@"%@%@", @"No photos for ", currentSettings.team.team_name]
                                                   delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)searchButtonClicked:(id)sender {
    UIAlertView *alert;
    
    if ([currentSettings.sport.name isEqualToString:@"Football"]) {
         alert = [[UIAlertView alloc] initWithTitle:@"Search" message:@"Select Photo Search Criteria"
                                            delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Player", @"Game", @"Play", @"User", @"All", nil];
    } else {
        alert = [[UIAlertView alloc] initWithTitle:@"Search" message:@"Select Photo Search Criteria"
                                          delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Player", @"Game", @"User", @"All", nil];
    }
    
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PhotoInfoSegue"]) {
        sportzteamsPhotoInfoViewController *destController = segue.destinationViewController;
        if ([[self.collectionView indexPathsForSelectedItems] count] > 0) {
            NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
            Photo *photo = [self.photos objectAtIndex:indexPath.row];
            destController.photos = [[NSMutableArray alloc] init];
            destController.photos = self.photos;
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
            destController.photoindex = indexPath.row;
        } else {
            destController.photo = nil;
        }
    } else if ([segue.identifier isEqualToString:@"VideoCollectionSegue"]) {
        EazesVideosViewController *destController = segue.destinationViewController;
        if (self.player)
            destController.player = self.player;
        else if (self.game)
            destController.game = self.game;
        else if (self.user)
            destController.user = self.user;
        else if (self.player)
            destController.player =self.player;
        else if (self.game)
            destController.game = self.game;
        else if (self.user)
            destController.user = self.user;
    } else if ([segue.identifier isEqualToString:@"GamePlaySelectSegue"]) {
        gamelogController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"AdDisplaySegue"]) {
        adBannerController = segue.destinationViewController;
    } else
        [super prepareForSegue:segue sender:self];
}

- (void)getPhotos {
    [super getPhotos];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Player"]) {
        self.game = nil;
        self.user = nil;
        self.playerContainer.hidden = NO;
    } else if ([title isEqualToString:@"Game"]) {
        self.player = nil;
        self.user = nil;
        self.gameContainer.hidden = NO;
    } else if ([title isEqualToString:@"Play"]) {
        self.player = nil;
        self.user = nil;
        
        if (self.game) {
            _gamelogContainer.hidden = NO;
            gamelogController.game = self.game;
            gamelogController.gamelog = nil;
            [gamelogController viewWillAppear:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Game must be selected before searching by play"
                                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
        
    } else if ([title isEqualToString:@"User"]) {
        self.player = nil;
        self.game = nil;
        self.userSelectContainer.hidden = NO;
    } else if ([title isEqualToString:@"All"]) {
        self.game = nil;
        self.user = nil;
        self.player = nil;
        
        NSString * urlstring = [NSString stringWithFormat:@"%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"], @"/sports/",
                                currentSettings.sport.id, @"/photos.json?team_id=", currentSettings.team.teamid];
        
        if ([currentSettings isSiteOwner])
            urlstring = [urlstring stringByAppendingFormat:@"&auth_token=%@", currentSettings.user.authtoken];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstring]];
        [self.activityIndicator startAnimating];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    } else if ([title isEqualToString:@"Dismiss"]) {
        self.tabBarController.selectedIndex = 0;
    } else if ([title isEqualToString:@"Select Site"]) {
        self.tabBarController.selectedIndex = 0;
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

@end
