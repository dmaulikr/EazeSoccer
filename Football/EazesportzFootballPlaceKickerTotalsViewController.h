//
//  EazesportzFootballPlaceKickerTotalsViewController.h
//  EazeSportz
//
//  Created by Gil on 12/3/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"
#import "GameSchedule.h"

@interface EazesportzFootballPlaceKickerTotalsViewController : UIViewController

@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UIImageView *playerImage;
@property (weak, nonatomic) IBOutlet UILabel *playerNumber;
@property (weak, nonatomic) IBOutlet UILabel *playerName;

@property (weak, nonatomic) IBOutlet UITextField *fgattemptsTextField;
@property (weak, nonatomic) IBOutlet UITextField *fgmadeTextField;
@property (weak, nonatomic) IBOutlet UITextField *fgblockedTextField;
@property (weak, nonatomic) IBOutlet UITextField *fglongTextField;
@property (weak, nonatomic) IBOutlet UITextField *xpattemptsTextField;
@property (weak, nonatomic) IBOutlet UITextField *xpblockedTextField;
@property (weak, nonatomic) IBOutlet UITextField *xpmadeTextField;
@property (weak, nonatomic) IBOutlet UITextField *pointsTextField;

- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)saveBarButtonClicked:(id)sender;

@end
