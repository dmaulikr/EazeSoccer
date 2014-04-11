//
//  EazesportzFootballRushingTotalsViewController.h
//  EazeSportz
//
//  Created by Gil on 12/2/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"
#import "GameSchedule.h"

@interface EazesportzFootballRushingTotalsViewController : UIViewController

@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UIImageView *playerImage;
@property (weak, nonatomic) IBOutlet UILabel *playerNumber;
@property (weak, nonatomic) IBOutlet UILabel *playerName;

@property (weak, nonatomic) IBOutlet UITextField *attemptsTextField;
@property (weak, nonatomic) IBOutlet UITextField *yardsTextField;
@property (weak, nonatomic) IBOutlet UITextField *tdTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstdownsTextField;
@property (weak, nonatomic) IBOutlet UITextField *fumblesTextField;
@property (weak, nonatomic) IBOutlet UITextField *fumblesLostTextField;
@property (weak, nonatomic) IBOutlet UITextField *twopointconvTextField;
@property (weak, nonatomic) IBOutlet UITextField *longestTextField;
@property (weak, nonatomic) IBOutlet UITextField *averageTextField;
- (IBAction)saveBarButtonClicked:(id)sender;

- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;


@end
