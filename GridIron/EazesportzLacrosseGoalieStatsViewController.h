//
//  EazesportzLacrosseGoalieStatsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/2/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"
#import "Athlete.h"
#import "VisitorRoster.h"

@interface EazesportzLacrosseGoalieStatsViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;
@property (nonatomic, strong) Athlete *player;
@property (nonatomic, strong) VisitorRoster *visitingPlayer;
@property (nonatomic, strong) Lacrosstat *lacrosstat;

@property (weak, nonatomic) IBOutlet UITextField *savesTextField;
@property (weak, nonatomic) IBOutlet UITextField *goalsagainstTextField;
@property (weak, nonatomic) IBOutlet UITextField *decisionsTextField;
@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
- (IBAction)saveButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIStepper *savesStepper;
- (IBAction)savesStepperClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIStepper *goalsagainstStepper;
- (IBAction)goalsagainstStepperClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIStepper *decisionsStepper;
- (IBAction)decisionsStepperClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIStepper *minutesplayedStepper;
- (IBAction)minutesplayedStepperClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationItem *goalieNavigationItem;
@property (weak, nonatomic) IBOutlet UISegmentedControl *periodSegmentedControl;
- (IBAction)periodSegmentedControlClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *saveImage;

@end
