//
//  EazesportzKickoffStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 12/1/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"
#import "GameSchedule.h"

@interface EazesportzKickoffStatsViewController : UIViewController

@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UIImageView *playerImage;
@property (weak, nonatomic) IBOutlet UILabel *playerNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *kickoffsLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnedLabel;
@property (weak, nonatomic) IBOutlet UILabel *touchbacksLabel;
- (IBAction)kickoffButtonClicked:(id)sender;
- (IBAction)touchbackButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *yardsTextField;
- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *totalsButton;
@end
