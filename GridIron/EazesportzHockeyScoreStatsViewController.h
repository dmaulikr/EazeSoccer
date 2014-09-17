//
//  EazesportzHockeyScoreStatsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 9/15/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"
#import "HockeyScoring.h"

@interface EazesportzHockeyScoreStatsViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;
@property (nonatomic, strong) HockeyScoring *score;

@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
- (IBAction)submitButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *secondsTextField;
@property (weak, nonatomic) IBOutlet UITextField *assistTextField;
- (IBAction)deleteButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UITextField *playerTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *periodSegmentedControl;
- (IBAction)periodSegmentedControlClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *playerPicker;
@property (weak, nonatomic) IBOutlet UITextField *goaltypeTextField;

@end
