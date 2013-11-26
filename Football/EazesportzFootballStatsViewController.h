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

- (IBAction)offenseButtonClicked:(id)sender;
- (IBAction)defenseButtonClicked:(id)sender;
- (IBAction)specialteamsButtonClicked:(id)sender;
- (IBAction)savestatsButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *statsTableView;
@property (weak, nonatomic) IBOutlet UILabel *statLabel;
@property (weak, nonatomic) IBOutlet UIView *playerSelectContainer;

- (IBAction)otherPlayerFootballStat:(UIStoryboardSegue *)segue;
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

- (IBAction)cancelGamelogTable:(UIStoryboardSegue *)segue;

@end
