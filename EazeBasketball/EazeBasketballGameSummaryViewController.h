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

@property (weak, nonatomic) IBOutlet UILabel *hometeamLabelText;
@property (weak, nonatomic) IBOutlet UIImageView *hometeamImage;
@property (weak, nonatomic) IBOutlet UILabel *visitorLabelText;
@property (weak, nonatomic) IBOutlet UIImageView *visitorTeamImage;
@property (weak, nonatomic) IBOutlet UILabel *homeScoreLabel;
- (IBAction)refreshButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *statsButton;
@property (weak, nonatomic) IBOutlet UITableView *statTableView;
- (IBAction)teamstatsButtonClicked:(id)sender;
- (IBAction)playerstatsButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *visitorPossessionArrowButton;
- (IBAction)visitorPossessionArrowButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *homePossessionArrowButton;
- (IBAction)homePossessionArrowButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *homeBonusButton;
- (IBAction)homeBonusButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *visitorBonusButton;
- (IBAction)visitorBonusButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *visitorScoreTextField;
@property (weak, nonatomic) IBOutlet UITextField *periodTextField;
@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondsTextfield;
@property (weak, nonatomic) IBOutlet UITextField *visitorFoulsTextField;
@property (weak, nonatomic) IBOutlet UITextField *homeFoulsTextField;
- (IBAction)saveBarButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;
@property (weak, nonatomic) IBOutlet UIImageView *visitorBonusImage;
@property (weak, nonatomic) IBOutlet UIImageView *homeBonusImage;
@property (weak, nonatomic) IBOutlet UITextField *homeScoreTextField;

@end
