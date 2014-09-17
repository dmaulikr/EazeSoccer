//
//  EazesportzHockeyPenaltyStatsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 9/16/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"
#import "HockeyPenalty.h"

@interface EazesportzHockeyPenaltyStatsViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;
@property (nonatomic, strong) HockeyPenalty *penaltystat;

@property (weak, nonatomic) IBOutlet UITextField *secondsTextField;
@property (weak, nonatomic) IBOutlet UITextField *penaltyTextField;
@property (weak, nonatomic) IBOutlet UITextField *penaltyTimeSecondsTextField;
@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *playerTextField;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *playerPickerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *periodSegmentedControl;
- (IBAction)periodSegmentedControlClicked:(id)sender;
- (IBAction)submitButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *penaltyTimeMinutesTextField;
@end
