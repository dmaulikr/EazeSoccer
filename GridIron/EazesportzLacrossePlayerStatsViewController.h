//
//  EazesportzLacrossePlayerStatsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/1/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"
#import "Athlete.h"
#import "VisitorRoster.h"

@interface EazesportzLacrossePlayerStatsViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;
@property (nonatomic, strong) Athlete *player;
@property (nonatomic, strong) VisitorRoster *visitingPlayer;

@property (weak, nonatomic) IBOutlet UITextField *groundBallTextField;
@property (weak, nonatomic) IBOutlet UITextField *turnoverTextField;
@property (weak, nonatomic) IBOutlet UITextField *causedTurnoverTextField;
@property (weak, nonatomic) IBOutlet UITextField *stealsTextField;
@property (weak, nonatomic) IBOutlet UITextField *faceoffwonTextField;
@property (weak, nonatomic) IBOutlet UITextField *faceofflostTextField;
@property (weak, nonatomic) IBOutlet UITextField *faceoffviolationTextField;
- (IBAction)saveButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *periodSegmentControl;
- (IBAction)periodSegmentControlClicked:(id)sender;
- (IBAction)groundBallStepperClicked:(id)sender;
- (IBAction)turnoverStepperClicked:(id)sender;
- (IBAction)causedTurnoverStepperClicked:(id)sender;
- (IBAction)stealsStepperClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationItem *playerStatsNavigationItem;
@property (weak, nonatomic) IBOutlet UIStepper *groundballStepper;
@property (weak, nonatomic) IBOutlet UIStepper *turnoverStepper;
@property (weak, nonatomic) IBOutlet UIStepper *causedturnoverStepper;
@property (weak, nonatomic) IBOutlet UIStepper *stealsStepper;
@property (weak, nonatomic) IBOutlet UIImageView *saveImage;
@end
