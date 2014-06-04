//
//  EazesportzLacrosseGameSummaryViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/23/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"

#import "EazesportzAppDelegate.h"

@interface EazesportzLacrosseGameSummaryViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UIImageView *homeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *visitorImageView;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *visitorButton;
@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondsTextField;
@property (weak, nonatomic) IBOutlet UITextField *homeScoreTextField;
@property (weak, nonatomic) IBOutlet UITextField *periodTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorTextField;
@property (weak, nonatomic) IBOutlet UITextField *homePenaltyOnePlayerTextField;
@property (weak, nonatomic) IBOutlet UITextField *homePenaltyOneMinutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *homePenaltyOneSecondsTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorPenaltyOnePlayerTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorPenaltyOneMinutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorPenaltyOneSecondsTextField;
@property (weak, nonatomic) IBOutlet UITextField *homePenaltyTwoPlayerTextField;
@property (weak, nonatomic) IBOutlet UITextField *homePenaltyTwoMinutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *homePenaltyTwoSecondsTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorPenaltyTwoPlayerTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorPenaltyTwoMinutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorPenaltyTwoSecondsTextField;
@property (weak, nonatomic) IBOutlet UILabel *lastplayTextField;
- (IBAction)refreshButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *statsButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sheetButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
- (IBAction)saveButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *summaryHomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryVisitorLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryHomeFirstPeriodScore;
@property (weak, nonatomic) IBOutlet UILabel *summaryHomeSecondPeriodScore;
@property (weak, nonatomic) IBOutlet UILabel *summaryHomeThirdPeriodScore;
@property (weak, nonatomic) IBOutlet UILabel *summaryHomeFourthPeriodScore;
@property (weak, nonatomic) IBOutlet UILabel *summaryHomeOvertimeScore;
@property (weak, nonatomic) IBOutlet UILabel *summaryHomeTotalsScore;
@property (weak, nonatomic) IBOutlet UILabel *summaryVisitorFirstPeriodScore;
@property (weak, nonatomic) IBOutlet UILabel *summaryVisitorSecondPeriodScore;
@property (weak, nonatomic) IBOutlet UILabel *summaryVisitorThirdPeriodScore;
@property (weak, nonatomic) IBOutlet UILabel *summaryVisitorFourthPeriodScore;
@property (weak, nonatomic) IBOutlet UILabel *summaryVisitorOvertimeScore;
@property (weak, nonatomic) IBOutlet UILabel *summaryVisitorTotalScore;

@end
