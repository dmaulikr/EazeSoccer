//
//  EazesportzFootballStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 11/21/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"
#import "GameSchedule.h"

@interface EazesportzFootballStatsViewController : UIViewController

@property(nonatomic, strong) Athlete *athlete;
@property(nonatomic, strong) GameSchedule *game;

- (IBAction)finalButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *finalButton;
@property (weak, nonatomic) IBOutlet UILabel *finalLabel;
- (IBAction)offenseButtonClicked:(id)sender;
- (IBAction)defenseButtonClicked:(id)sender;
- (IBAction)specialteamsButtonClicked:(id)sender;
- (IBAction)savestatsButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *statsTableView;
@property (weak, nonatomic) IBOutlet UILabel *statLabel;
@property (weak, nonatomic) IBOutlet UIView *playerSelectContainer;

- (IBAction)playerSelected:(UIStoryboardSegue *)segue;

@property (weak, nonatomic) IBOutlet UIView *gamelogContainer;
- (IBAction)scoreLogButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *homeImageView;
@property (weak, nonatomic) IBOutlet UILabel *homeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *visitorImageView;
@property (weak, nonatomic) IBOutlet UILabel *visitorLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameClockLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorScoreLabel;
@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondsTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorScoreTextField;
@property (weak, nonatomic) IBOutlet UITextField *quarterTextField;
@property (weak, nonatomic) IBOutlet UITextField *ballonTextField;
@property (weak, nonatomic) IBOutlet UITextField *downTextField;
@property (weak, nonatomic) IBOutlet UITextField *togoTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorTimeOutsTextField;
@property (weak, nonatomic) IBOutlet UITextField *homeTimeOutsTextField;

- (IBAction)searchBlogGameLog:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *penaltyYardsTextField;
@property (weak, nonatomic) IBOutlet UILabel *penaltyYardsLabel;
- (IBAction)penaltyButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *statTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statLabel1;
@property (weak, nonatomic) IBOutlet UILabel *statLabel2;
@property (weak, nonatomic) IBOutlet UILabel *statLabel3;
@property (weak, nonatomic) IBOutlet UILabel *statLabel4;
@property (weak, nonatomic) IBOutlet UILabel *statLabel5;
@property (weak, nonatomic) IBOutlet UILabel *statLabel6;
@property (weak, nonatomic) IBOutlet UILabel *statLabel7;
@property (weak, nonatomic) IBOutlet UILabel *statLabel8;
@property (weak, nonatomic) IBOutlet UILabel *statLabel9;
@property (weak, nonatomic) IBOutlet UILabel *statLabel10;
@property (weak, nonatomic) IBOutlet UILabel *statData1;
@property (weak, nonatomic) IBOutlet UILabel *statData2;
@property (weak, nonatomic) IBOutlet UILabel *statData3;
@property (weak, nonatomic) IBOutlet UILabel *statData4;
@property (weak, nonatomic) IBOutlet UILabel *statData5;
@property (weak, nonatomic) IBOutlet UILabel *statData6;
@property (weak, nonatomic) IBOutlet UILabel *statData7;
@property (weak, nonatomic) IBOutlet UILabel *statData8;
@property (weak, nonatomic) IBOutlet UILabel *statData9;
@property (weak, nonatomic) IBOutlet UILabel *statData10;

@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
- (IBAction)buttonOneClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
- (IBAction)buttonTwoClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
- (IBAction)buttonThreeClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
- (IBAction)buttonFourClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonFive;
- (IBAction)buttonFiveClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonSix;
- (IBAction)buttonSixClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonSeven;
- (IBAction)buttonSevenClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonEight;
- (IBAction)buttonEightClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonNine;
- (IBAction)buttonNineClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *yardsLostLabel;
@property (weak, nonatomic) IBOutlet UITextField *yardsLostTextField;
@property (weak, nonatomic) IBOutlet UITextField *receiverTextField;
@property (weak, nonatomic) IBOutlet UILabel *yardsLabel;
@property (weak, nonatomic) IBOutlet UITextField *yardsTextField;
@property (weak, nonatomic) IBOutlet UILabel *fumbleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *fumbleSwitch;
@property (weak, nonatomic) IBOutlet UILabel *fumbleLostLabel;
@property (weak, nonatomic) IBOutlet UISwitch *fumbleLostSwitch;
@property (weak, nonatomic) IBOutlet UILabel *quarterLabel;
@property (weak, nonatomic) IBOutlet UITextField *quarterStatTextField;
@property (weak, nonatomic) IBOutlet UILabel *timeofscoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *colonLabel;
@property (weak, nonatomic) IBOutlet UITextField *secondsStatTextField;
@property (weak, nonatomic) IBOutlet UITextField *minutesStatTextField;
@property (weak, nonatomic) IBOutlet UIButton *savePlayerStatsButton;
- (IBAction)savePlayerStatsButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *toggleButton;
- (IBAction)toggleButtonClicked:(id)sender;

- (IBAction)refreshButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIButton *totalsButton;
- (IBAction)totalsButtonClicked:(id)sender;
- (IBAction)fumbleSwitchToggle:(id)sender;
- (IBAction)fumblelostSwitchToggle:(id)sender;

@end
