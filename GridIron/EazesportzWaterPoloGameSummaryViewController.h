//
//  EazesportzWaterPoloGameSummaryViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/19/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"

@interface EazesportzWaterPoloGameSummaryViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UIImageView *homeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *visitorImageView;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
- (IBAction)homeButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *visitorButton;
- (IBAction)visitorButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondsTextField;
@property (weak, nonatomic) IBOutlet UITextField *homeScoreTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorScoreTextField;
@property (weak, nonatomic) IBOutlet UITextField *periodTextField;
@property (weak, nonatomic) IBOutlet UITextField *homeTimeOutsTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorTimeOutsTextField;
@property (weak, nonatomic) IBOutlet UITextField *homeOneExclusionNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *homeOneExclusionTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *homeTwoExclusionNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *homeTwoExclusionTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorOneExclusionNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorOneExclusionTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorTwoExclusionNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorTwoExclusionTimeTextField;

@property (weak, nonatomic) IBOutlet UILabel *homeSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *homePeriodOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *homePeriodTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *homePeriodThreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *homePeriodFourLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeOverTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorPeriodOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorPeriodTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorPeriodThreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorPeriodFourLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorOverTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorTotalLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;
- (IBAction)saveBarButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshBarButton;
- (IBAction)refreshBarButtonClicked:(id)sender;
@end
