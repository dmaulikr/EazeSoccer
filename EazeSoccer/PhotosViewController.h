//
//  EazesportsSecondViewController.h
//  FootballStatsConsole
//
//  Created by Gil on 5/14/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"
#import "GameSchedule.h"
//#import "Gamelogs.h"
#import "Coach.h"
#import "User.h"


@interface PhotosViewController : UIViewController

@property(nonatomic, strong) Athlete* player;
@property(nonatomic, strong) GameSchedule *game;
@property(nonatomic, strong) User *user;

@property (nonatomic, strong) NSString *lacross_scoring_id;
@property (nonatomic, strong) NSString *soccer_scoring_id;
@property (nonatomic, strong) NSString *hockey_scoring_id;

@property(nonatomic, strong) NSMutableArray *photos;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
- (IBAction)searchButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)playerSelected:(UIStoryboardSegue *)segue;

- (IBAction)gameSelected:(UIStoryboardSegue *)segue;

- (IBAction)selectUser:(UIStoryboardSegue *)segue;

- (void)getPhotos;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *playerContainer;
@property (weak, nonatomic) IBOutlet UIView *gameContainer;
@property (weak, nonatomic) IBOutlet UIView *userSelectContainer;
- (IBAction)teamButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *teamButton;
- (IBAction)changeTeamButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *featuredButton;
- (IBAction)videoButtonClicked:(id)sender;

- (void)displayUpgradeAlert;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *videosBarButton;

@end
