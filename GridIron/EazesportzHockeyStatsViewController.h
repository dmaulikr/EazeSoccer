//
//  EazesportzHockeyStatsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 9/11/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"
@interface EazesportzHockeyStatsViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UITableView *statsTableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;
- (IBAction)saveBarButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *statsBarButton;
- (IBAction)scoreButtonClicked:(id)sender;
- (IBAction)goalieButtonClicked:(id)sender;
- (IBAction)statsButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goalieButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *statsButton;
@property (weak, nonatomic) IBOutlet UIView *statsContainer;
@property (weak, nonatomic) IBOutlet UIView *scoreContainer;
@property (weak, nonatomic) IBOutlet UIView *goalieContainer;
@property (weak, nonatomic) IBOutlet UIView *penaltyContainer;

- (IBAction)hockeyPlayerstatsDone:(UIStoryboardSegue *)segue;
- (IBAction)hockeyScorestatsDone:(UIStoryboardSegue *)segue;
- (IBAction)hockeyGoaliestatsDone:(UIStoryboardSegue *)segue;
- (IBAction)hockeyPenaltystatsDone:(UIStoryboardSegue *)segue;

- (IBAction)statsInfoBarButtonClicked:(id)sender;
- (IBAction)penaltiesButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *penaltiesButton;
@end
