//
//  LiveGameSummaryViewController.h
//  Basketball Console
//
//  Created by Gil on 10/1/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"

@interface BasketballGameClockViewController : UIViewController

@property(nonatomic, strong) GameSchedule *game;

- (IBAction)homeBonusButton:(id)sender;
- (IBAction)visitorBonusButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondsTextField;
@property (weak, nonatomic) IBOutlet UIImageView *leftBonusImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightBonusImage;
@property (weak, nonatomic) IBOutlet UITextField *homeScoreTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorScoreTextField;
@property (weak, nonatomic) IBOutlet UIButton *firstPeriodButton;
- (IBAction)firstPeriodButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *secondPeriodButton;
- (IBAction)secondPeriodButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *thirdPeriodButton;
- (IBAction)thirdPeriodButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *fourthPeriodButton;
- (IBAction)fourthPeriodButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *homeFoulsTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorFoulsTextField;
@property (weak, nonatomic) IBOutlet UIImageView *hometeamImage;
@property (weak, nonatomic) IBOutlet UILabel *hometeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorteamLabel;
@property (weak, nonatomic) IBOutlet UIImageView *visitorImage;
@property (weak, nonatomic) IBOutlet UILabel *gameclockLabel;
- (IBAction)saveButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *homePossessionArrow;
@property (weak, nonatomic) IBOutlet UIImageView *visitorPossessionArrow;
- (IBAction)possessionArrorButtonClicked:(id)sender;

@end
