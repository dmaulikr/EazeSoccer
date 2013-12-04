//
//  EazesportzFootballPassingTotalsViewController.h
//  EazeSportz
//
//  Created by Gil on 12/2/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"
#import "GameSchedule.h"

@interface EazesportzFootballPassingTotalsViewController : UIViewController

@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UIImageView *playerImage;
@property (weak, nonatomic) IBOutlet UILabel *playerNumber;
@property (weak, nonatomic) IBOutlet UILabel *playerName;
@property (weak, nonatomic) IBOutlet UITextField *attemptsTextField;
@property (weak, nonatomic) IBOutlet UITextField *completionsTextField;
@property (weak, nonatomic) IBOutlet UITextField *tdTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstdownsTextField;
@property (weak, nonatomic) IBOutlet UITextField *sacksTextField;
@property (weak, nonatomic) IBOutlet UITextField *yardslostTextField;
@property (weak, nonatomic) IBOutlet UITextField *twopointconvTextField;
- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *yardsTextField;
@end
