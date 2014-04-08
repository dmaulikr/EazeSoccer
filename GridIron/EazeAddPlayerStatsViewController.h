//
//  EazeAddPlayerStatsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 3/28/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"
#import "GameSchedule.h"

@interface EazeAddPlayerStatsViewController : UIViewController

@property (nonatomic, strong) Athlete *athlete;
@property (nonatomic, strong) GameSchedule *game;
@property (nonatomic, assign) NSString *position;

@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;
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

@property (weak, nonatomic) IBOutlet UITextField *receiverTextField;
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
- (IBAction)fumbleSwitchToggle:(id)sender;
- (IBAction)fumblelostSwitchToggle:(id)sender;
- (IBAction)refreshButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *playerSelectContainer;
- (IBAction)playerSelected:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UISegmentedControl *yardsPluMinusSegmentedControl;

@end
