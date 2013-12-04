//
//  EazesportzDefenseStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 11/29/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"
#import "GameSchedule.h"

@interface EazesportzDefenseStatsViewController : UIViewController

@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;
@property (weak, nonatomic) IBOutlet UILabel *playerNumbeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tacklesLabel;
@property (weak, nonatomic) IBOutlet UILabel *assistsLabel;
@property (weak, nonatomic) IBOutlet UILabel *sacksLabel;
@property (weak, nonatomic) IBOutlet UILabel *intLabel;
@property (weak, nonatomic) IBOutlet UILabel *passdefendedlabel;
@property (weak, nonatomic) IBOutlet UILabel *tdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fumbleRecoverecLabel;
@property (weak, nonatomic) IBOutlet UILabel *retYardsLabel;
@property (weak, nonatomic) IBOutlet UILabel *sackassistLabel;
- (IBAction)sackAssistsButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *safetylabel;
- (IBAction)tackleButtonClicked:(id)sender;
- (IBAction)assistButtonClicked:(id)sender;
- (IBAction)sackButtonClicked:(id)sender;
- (IBAction)intButtonClicked:(id)sender;
- (IBAction)passdefendedButtonClicked:(id)sender;
- (IBAction)fumblerecoveredButtonClicked:(id)sender;
- (IBAction)tdButtonClicked:(id)sender;
- (IBAction)safetyButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *returnyardsLabel;
@property (weak, nonatomic) IBOutlet UITextField *returnyardsTextField;
@property (weak, nonatomic) IBOutlet UILabel *quarterLabel;
@property (weak, nonatomic) IBOutlet UITextField *quarterTextField;
@property (weak, nonatomic) IBOutlet UILabel *timeofscoreLabel;
@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
@property (weak, nonatomic) IBOutlet UILabel *colonLabel;
@property (weak, nonatomic) IBOutlet UITextField *secondsTextField;
- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *totalsButton;
@end
