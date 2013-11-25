//
//  VideosViewController.h
//  FootballStatsConsole
//
//  Created by Gil on 5/15/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"
#import "GameSchedule.h"
#import "User.h"
//#import "Gamelogs.h"

@interface VideosViewController : UIViewController

@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) GameSchedule *game;
@property(nonatomic, strong) User *user;
//@property(nonatomic, strong) Gamelogs *gamelog;

@property(nonatomic, strong) NSMutableArray *videos;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)searchButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@property (weak, nonatomic) IBOutlet UIView *gameSelectContainer;
@property (weak, nonatomic) IBOutlet UIView *playerSelectContainer;
@property (weak, nonatomic) IBOutlet UIView *userSelectionContainer;

- (IBAction)selectVideoGame:(UIStoryboardSegue *)segue;
- (IBAction)selectVideoPlayer:(UIStoryboardSegue *)segue;
- (IBAction)selectvideoUser:(UIStoryboardSegue *)segue;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *teamButton;
- (IBAction)changeTeamButtonClicked:(id)sender;

@end
