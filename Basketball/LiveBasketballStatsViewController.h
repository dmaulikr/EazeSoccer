//
//  ShotChartViewController.h
//  Basketball Console
//
//  Created by Gilbert Zaldivar on 9/17/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"
#import "Athlete.h"
#import "BasketballStats.h"
#import "GameSchedule.h"

@interface LiveBasketballStatsViewController : UIViewController

@property(nonatomic, strong) BasketballStats *stats;
@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) GameSchedule *game;

- (IBAction)threePointButtonClicked:(id)sender;
- (IBAction)twoPointButtonClicked:(id)sender;
- (IBAction)freeThrowButtonClicked:(id)sender;
- (IBAction)foulButtonClicked:(id)sender;
- (IBAction)stealButtonClicked:(id)sender;
- (IBAction)assistButtonClicked:(id)sender;
- (IBAction)offReboundButtonClicked:(id)sender;
- (IBAction)defReboundButtonClicked:(id)sender;
- (IBAction)blocksButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *fieldGoalMadeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fieldGoalAttemptLabel;
@property (weak, nonatomic) IBOutlet UILabel *fieldGoalPercentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *threePointFGMLabel;
@property (weak, nonatomic) IBOutlet UILabel *threePointFGALabel;
@property (weak, nonatomic) IBOutlet UILabel *threePointFGPLabel;
@property (weak, nonatomic) IBOutlet UILabel *FTMMadeLabel;
@property (weak, nonatomic) IBOutlet UILabel *FTALabel;
@property (weak, nonatomic) IBOutlet UILabel *FTPLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *foulLabel;
@property (weak, nonatomic) IBOutlet UILabel *stealLabel;
@property (weak, nonatomic) IBOutlet UILabel *offrbLabel;
@property (weak, nonatomic) IBOutlet UILabel *defrbLabel;
@property (weak, nonatomic) IBOutlet UILabel *blockLabel;
@property (weak, nonatomic) IBOutlet UILabel *assistsLabel;

@property (weak, nonatomic) IBOutlet UIButton *savestatsButton;

@end
