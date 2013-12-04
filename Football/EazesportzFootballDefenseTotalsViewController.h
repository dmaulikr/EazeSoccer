//
//  EazesportzFootballDefenseTotalsViewController.h
//  EazeSportz
//
//  Created by Gil on 12/2/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"
#import "GameSchedule.h"

@interface EazesportzFootballDefenseTotalsViewController : UIViewController

@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UIImageView *playerImage;
@property (weak, nonatomic) IBOutlet UILabel *playerNumber;
@property (weak, nonatomic) IBOutlet UILabel *playerName;

@property (weak, nonatomic) IBOutlet UITextField *tacklesTextField;
@property (weak, nonatomic) IBOutlet UITextField *assistsTextField;
@property (weak, nonatomic) IBOutlet UITextField *sacksTextField;
@property (weak, nonatomic) IBOutlet UITextField *sackAssistsTextField;
@property (weak, nonatomic) IBOutlet UITextField *passdefendedTextField;
@property (weak, nonatomic) IBOutlet UITextField *interceptionsTextField;
@property (weak, nonatomic) IBOutlet UITextField *returnYardsTextField;
@property (weak, nonatomic) IBOutlet UITextField *returnTDTextField;
@property (weak, nonatomic) IBOutlet UITextField *longestReturnTextField;
@property (weak, nonatomic) IBOutlet UITextField *safetiesTextField;
@property (weak, nonatomic) IBOutlet UITextField *fumblesRecoveredTextField;

- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;


@end
