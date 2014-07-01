//
//  EazesportzSoccerGameSummaryViewController.h
//  EazeSportz
//
//  Created by Gil on 11/12/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"

@interface EazesportzSoccerGameSummaryViewController : UIViewController

@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UILabel *hometeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorteamLabel;
@property (weak, nonatomic) IBOutlet UIImageView *homeimage;
@property (weak, nonatomic) IBOutlet UIImageView *vsitorimage;
@property (weak, nonatomic) IBOutlet UILabel *homescoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeshotsLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeCkLabel;
@property (weak, nonatomic) IBOutlet UILabel *homesavesLabel;
- (IBAction)refreshButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *statsButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
- (IBAction)teamstatsButtonClicked:(id)sender;
- (IBAction)playerstatsButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *statTableView;
@property (weak, nonatomic) IBOutlet UIButton *playerStatsButton;

@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondsTextField;
@property (weak, nonatomic) IBOutlet UITextField *periodsTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorScoreTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorShotsTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorCKTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorSavesTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;
- (IBAction)saveBarButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *homeScoreTextField;
- (IBAction)teamstatsBarButtonClicked:(id)sender;
- (IBAction)playerstatsBarButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *gameSummaryDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameSmmaryHomeTeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameSummaryVisitorTeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameSummaryHomePeriodOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameSummaryHomePeriodTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameSummaryHomeOT1Label;
@property (weak, nonatomic) IBOutlet UILabel *gameSummaryHomeOT2Label;
@property (weak, nonatomic) IBOutlet UILabel *gameSummaryHomeFinalLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameSummaryVisitorPeriodOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameSummaryVisitorPeriodTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameSummaryVisitorOT1Label;
@property (weak, nonatomic) IBOutlet UILabel *gameSummaryVisitorOT2Label;
@property (weak, nonatomic) IBOutlet UILabel *gameSummaryVisitorFinalLabel;

@end
