//
//  UpdateSoccerTotalsViewController.h
//  EazeSportz
//
//  Created by Gil on 11/5/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Soccer.h"
#import "Athlete.h"
#import "GameSchedule.h"

@interface UpdateSoccerTotalsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property(nonatomic, strong) Soccer *soccerstats;
@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UIImageView *playerImage;
@property (weak, nonatomic) IBOutlet UITextField *minutesPlayedTextField;
@property (weak, nonatomic) IBOutlet UITextField *goalsTextField;
@property (weak, nonatomic) IBOutlet UITextField *shotsTextField;
@property (weak, nonatomic) IBOutlet UITextField *assistsTextField;
@property (weak, nonatomic) IBOutlet UITextField *stealsTextField;
@property (weak, nonatomic) IBOutlet UITextField *savesTextField;
@property (weak, nonatomic) IBOutlet UITextField *goalsagainstTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UITextField *cornerkickTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)saveBarButtonClicked:(id)sender;
@end
