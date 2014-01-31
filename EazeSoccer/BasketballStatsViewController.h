//
//  BasketballStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 11/8/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameSchedule.h"
#import "Athlete.h"
#import "BasketballGameClockViewController.h"

@interface BasketballStatsViewController : UIViewController

@property(nonatomic, strong) GameSchedule *game;
@property(nonatomic, strong) Athlete *athlete;

@property (weak, nonatomic) IBOutlet UITableView *basketballTableView;
- (IBAction)saveButtonClicked:(id)sender;

- (IBAction)liveBasketballPlayerStats:(UIStoryboardSegue *)segue;
- (IBAction)nonscoreBasketballPlayerStats:(UIStoryboardSegue *)segue;
- (IBAction)updateTotalBasketballStats:(UIStoryboardSegue *)segue;

@property (weak, nonatomic) IBOutlet UIView *basketballLiveStatsContainer;
@property (weak, nonatomic) IBOutlet UIView *basketballTotalStatsContainer;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UILabel *statLabel;

@property(nonatomic, strong) BasketballGameClockViewController *clock;

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
- (IBAction)saveClockButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *homePossessionArrow;
@property (weak, nonatomic) IBOutlet UIImageView *visitorPossessionArrow;
- (IBAction)possessionArrorButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *homeScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorScoreLabel;
@property (weak, nonatomic) IBOutlet UIView *nonscoreStatsContainer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UILabel *finalLabel;
- (IBAction)finalButtonClicked:(id)sender;

@end
