//
//  EazesportzBasketballNonScoreStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 12/12/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Athlete.h"
#import "BasketballStats.h"
#import "GameSchedule.h"

@interface EazesportzBasketballNonScoreStatsViewController : UIViewController

@property(nonatomic, strong) BasketballStats *stats;
@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UILabel *foulLabel;
@property (weak, nonatomic) IBOutlet UILabel *stealLabel;
@property (weak, nonatomic) IBOutlet UILabel *offrbLabel;
@property (weak, nonatomic) IBOutlet UILabel *defrbLabel;
@property (weak, nonatomic) IBOutlet UILabel *blockLabel;
@property (weak, nonatomic) IBOutlet UILabel *assistsLabel;
@property (weak, nonatomic) IBOutlet UILabel *turnoversLabel;

- (IBAction)foulButtonClicked:(id)sender;
- (IBAction)stealButtonClicked:(id)sender;
- (IBAction)assistButtonClicked:(id)sender;
- (IBAction)offReboundButtonClicked:(id)sender;
- (IBAction)defReboundButtonClicked:(id)sender;
- (IBAction)blocksButtonClicked:(id)sender;
- (IBAction)turnoverButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end
