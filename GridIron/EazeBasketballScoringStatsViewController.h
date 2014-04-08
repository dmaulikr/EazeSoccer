//
//  EazeBasketballScoringStatsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/5/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"
#import "Athlete.h"

@interface EazeBasketballScoringStatsViewController : UIViewController

@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) GameSchedule *game;

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

- (IBAction)saveBarButtonClicked:(id)sender;
- (IBAction)fgaButtonClicked:(id)sender;
- (IBAction)fgmButtonClicked:(id)sender;
- (IBAction)threefgaButtonClicked:(id)sender;
- (IBAction)threefgmButtonClicked:(id)sender;
- (IBAction)ftaButtonClicked:(id)sender;
- (IBAction)ftmButtonClicked:(id)sender;
- (IBAction)toggleButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *toggleButton;

@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;

@end
