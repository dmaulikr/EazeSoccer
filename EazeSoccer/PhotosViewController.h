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

- (IBAction)userButtonClicked:(id)sender;
- (IBAction)playerButtonClicked:(id)sender;
- (IBAction)gameButtonClicked:(id)sender;
- (IBAction)teamButtonClicked:(id)sender;
- (IBAction)refreshButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)selectPhotoPlayer:(UIStoryboardSegue *)segue;
- (IBAction)selectPhotoGame:(UIStoryboardSegue *)segue;
- (IBAction)selectPhotoUser:(UIStoryboardSegue *)segue;

@property (weak, nonatomic) IBOutlet UIView *playerContainer;
@property (weak, nonatomic) IBOutlet UIView *gameContainer;
@property (weak, nonatomic) IBOutlet UIView *userSelectContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
