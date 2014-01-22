//
//  EazeBasketballGameSummaryViewController.h
//  EazeSportz
//
//  Created by Gil on 11/16/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"

@interface EazeBasketballGameSummaryViewController : UIViewController

@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UILabel *gameclockLabel;
@property (weak, nonatomic) IBOutlet UILabel *hometeamLabelText;
@property (weak, nonatomic) IBOutlet UIImageView *hometeamImage;
@property (weak, nonatomic) IBOutlet UILabel *visitorLabelText;
@property (weak, nonatomic) IBOutlet UIImageView *visitorTeamImage;
@property (weak, nonatomic) IBOutlet UIImageView *homeBonusImage;
@property (weak, nonatomic) IBOutlet UIImageView *visitorBonusImage;
@property (weak, nonatomic) IBOutlet UIImageView *homePossesionArrow;
@property (weak, nonatomic) IBOutlet UIImageView *visitorPossessionArrow;
@property (weak, nonatomic) IBOutlet UILabel *homeScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *homefoulsLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorFoulsLabel;
- (IBAction)refreshButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *statsButton;
@property (weak, nonatomic) IBOutlet UITableView *statTableView;
- (IBAction)teamstatsButtonClicked:(id)sender;
- (IBAction)playerstatsButtonClicked:(id)sender;

@end
