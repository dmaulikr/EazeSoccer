//
//  EazesportzRushingStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 11/26/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"
#import "Athlete.h"

@interface EazesportzRushingStatsViewController : UIViewController

@property(nonatomic, strong) GameSchedule *game;
@property(nonatomic, strong) Athlete *player;

@property (weak, nonatomic) IBOutlet UIView *theview;
@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;
@property (weak, nonatomic) IBOutlet UILabel *playerNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *attemptLabel;
@property (weak, nonatomic) IBOutlet UILabel *yardsLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet UILabel *tdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fdLabel;
@property (weak, nonatomic) IBOutlet UILabel *longestLabel;
@property (weak, nonatomic) IBOutlet UILabel *fumbleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fumbleLostLabel;
@property (weak, nonatomic) IBOutlet UILabel *twopointLabel;
- (IBAction)attemptButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *rushyardsTextField;
- (IBAction)fumbleButtonClicked:(id)sender;
- (IBAction)fumblelostButtonClicked:(id)sender;
- (IBAction)tdButtonClicked:(id)sender;
- (IBAction)twopointButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *quarterLabel;
@property (weak, nonatomic) IBOutlet UITextField *quarterTextField;
@property (weak, nonatomic) IBOutlet UILabel *timeofscoreLabel;
- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
@property (strong, nonatomic) IBOutlet UIView *colonLabel;
@property (weak, nonatomic) IBOutlet UITextField *secondsTextField;
@end
