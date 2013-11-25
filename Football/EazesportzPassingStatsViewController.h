//
//  EazesportzPassingStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 11/22/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"
#import "GameSchedule.h"

@interface EazesportzPassingStatsViewController : UIViewController

@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) GameSchedule *game;

- (IBAction)totalsButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;
@property (weak, nonatomic) IBOutlet UILabel *playerNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *attemptsLabel;
@property (weak, nonatomic) IBOutlet UILabel *completionLabel;
@property (weak, nonatomic) IBOutlet UILabel *compercentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *yardsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tdlabel;
@property (weak, nonatomic) IBOutlet UILabel *interceptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *sacksLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstdownsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lostLabel;
@property (weak, nonatomic) IBOutlet UILabel *twopointLabel;
- (IBAction)attemptButtonClicked:(id)sender;
- (IBAction)interceptionButtonClicked:(id)sender;
- (IBAction)sackButtonClicked:(id)sender;
- (IBAction)firstdownsButtonClicked:(id)sender;
- (IBAction)tdButtonClicked:(id)sender;
- (IBAction)twopointButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *sackyardslostTextField;
@property (weak, nonatomic) IBOutlet UITextField *receiverTextField;
@property (weak, nonatomic) IBOutlet UITextField *completionYardsTextField;
@property (weak, nonatomic) IBOutlet UISwitch *receiverFumbleSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *receverFumbleLostSwitch;
@property (weak, nonatomic) IBOutlet UITextField *quarterTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)completionButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *playerContainer;

- (IBAction)selectPassingReceiverPlayer:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UIPickerView *quarterPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *timeofscorePicker;

@property (weak, nonatomic) IBOutlet UILabel *receiverFumbleLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverFumbleLostLabel;
@property (weak, nonatomic) IBOutlet UILabel *quarterLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeofscoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverLabel;
@property (weak, nonatomic) IBOutlet UILabel *compyardsLabel;
@end
