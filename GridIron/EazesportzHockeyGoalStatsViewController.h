//
//  EazesportzHockeyGoalStatsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 9/15/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"
#import "Athlete.h"

@interface EazesportzHockeyGoalStatsViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;
@property (nonatomic, strong) Athlete *player;

@property (weak, nonatomic) IBOutlet UISegmentedControl *periodSegmentedControl;
- (IBAction)periodSegmentedControlClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *savesTextField;
@property (weak, nonatomic) IBOutlet UITextField *goalsallowedTextField;
@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
- (IBAction)submitButtonClicked:(id)sender;
@end
