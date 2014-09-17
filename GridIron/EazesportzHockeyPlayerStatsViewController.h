//
//  EazesportzHockeyPlayerStatsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 9/14/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"
#import "Athlete.h"

@interface EazesportzHockeyPlayerStatsViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;
@property (nonatomic, strong) Athlete *player;

@property (weak, nonatomic) IBOutlet UISegmentedControl *periodSegmentedControl;
- (IBAction)periodSegmentedControlClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *shotsTextField;
@property (weak, nonatomic) IBOutlet UITextField *blockedShotsTextField;
@property (weak, nonatomic) IBOutlet UITextField *hitsTextField;
@property (weak, nonatomic) IBOutlet UITextField *plusminusTextField;
@property (weak, nonatomic) IBOutlet UITextField *faceoffwonTextField;
@property (weak, nonatomic) IBOutlet UITextField *faceofflostTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeoniceMinutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeoniceSecondsTimeTextField;
- (IBAction)submitButtonClicked:(id)sender;
@end
