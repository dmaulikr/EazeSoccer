//
//  LiveSoccerStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 11/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Soccer.h"
#import "Athlete.h"
#import "GameSchedule.h"

@interface LiveSoccerStatsViewController : UIViewController

@property(nonatomic, strong) Soccer *playerStats;
@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UITextField *minutesPlayedTextField;
- (IBAction)goalButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
- (IBAction)shotsButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *shotsLabel;
- (IBAction)assistsButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *assistsLabel;
- (IBAction)stealButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *stealsLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
- (IBAction)savesButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *savesLabel;
- (IBAction)goalsAgainstButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *goalsAgainstLabel;
- (IBAction)submitButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)cornerKickButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *cornerKickLabel;

@end
