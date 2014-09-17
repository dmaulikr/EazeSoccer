//
//  EazesportzHockeyGameSummaryViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 9/11/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"

@interface EazesportzHockeyGameSummaryViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UIImageView *homeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *visitorImageView;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *visitorButton;
@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondsTextField;
@property (weak, nonatomic) IBOutlet UITextField *homeScoreTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorScoreTextField;
@property (weak, nonatomic) IBOutlet UITextField *periodTextField;
@property (weak, nonatomic) IBOutlet UITextField *homeTimeOutsTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorTimeOutsTextField;

@property (weak, nonatomic) IBOutlet UITextField *penaltyHomePlayerOneTextField;
@property (weak, nonatomic) IBOutlet UITextField *penaltyHomePlayerTwoTextField;
@property (weak, nonatomic) IBOutlet UITextField *penaltyHomePlayerOneMinutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *penaltyHomePlayerTwoMinutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *penaltyHomePlayerOneSecondsTextField;
@property (weak, nonatomic) IBOutlet UITextField *penaltyHomePlayerTwoSecondsTextField;

@property (weak, nonatomic) IBOutlet UITextField *penaltyVisitorPlayerOneTextField;
@property (weak, nonatomic) IBOutlet UITextField *penaltyVisitorPlayerTwoTextField;
@property (weak, nonatomic) IBOutlet UITextField *penaltyVisitorPlayerOneMinutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *penaltyVisitorPlayerTwoMinutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *penaltyVisitorPlayerOneSecondsTextField;
@property (weak, nonatomic) IBOutlet UITextField *penaltyVisitorPlayerTwoSecondsTextField;

@property (weak, nonatomic) IBOutlet UILabel *homeTeamSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorTeamSummaryLabel;

@property (weak, nonatomic) IBOutlet UILabel *homeTeamPeriodOneScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamPeriodTwoScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamPeriodThreeScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamOvertimeScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamTotalScoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *visitorTeamPeriodOneScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorTeamPeriodTwoScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorTeamPeriodThreeScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorTeamOvertimeScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorTeamTotalScoreLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;
- (IBAction)saveBarButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshBarButton;
- (IBAction)refreshBarButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *statsBarButton;
@end
