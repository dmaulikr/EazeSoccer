//
//  EazesportzPunterStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 12/1/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Athlete.h"
#import "GameSchedule.h"

@interface EazesportzPunterStatsViewController : UIViewController

@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UIImageView *playerImage;
@property (weak, nonatomic) IBOutlet UILabel *playerNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *puntsLabel;
@property (weak, nonatomic) IBOutlet UILabel *yardsLabel;
@property (weak, nonatomic) IBOutlet UILabel *longLabel;
@property (weak, nonatomic) IBOutlet UILabel *blockedLabel;
- (IBAction)puntButtonClicked:(id)sender;
- (IBAction)blockedButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *yardsTextField;
- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *totalsButton;
@end
