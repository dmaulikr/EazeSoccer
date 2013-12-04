//
//  EazesportzFootballKickerTotalsViewController.h
//  EazeSportz
//
//  Created by Gil on 12/3/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"
#import "GameSchedule.h"

@interface EazesportzFootballKickerTotalsViewController : UIViewController

@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UIImageView *playerImage;
@property (weak, nonatomic) IBOutlet UILabel *playerNumber;
@property (weak, nonatomic) IBOutlet UILabel *playerName;

@property (weak, nonatomic) IBOutlet UITextField *koattemptsTextField;
@property (weak, nonatomic) IBOutlet UITextField *touchbacksTextField;
@property (weak, nonatomic) IBOutlet UITextField *returnedTextField;

- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

@end
