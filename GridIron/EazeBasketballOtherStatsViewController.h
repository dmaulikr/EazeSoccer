//
//  EazeBasketballOtherStatsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/5/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"
#import "GameSchedule.h"

@interface EazeBasketballOtherStatsViewController : UIViewController

@property (nonatomic, strong) Athlete *player;
@property (nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UIImageView *playerImage;
@property (weak, nonatomic) IBOutlet UILabel *personalFoulsLabel;
@property (weak, nonatomic) IBOutlet UILabel *offensiveReboundLabel;
@property (weak, nonatomic) IBOutlet UILabel *defensiveReboundLabel;
@property (weak, nonatomic) IBOutlet UILabel *assistLabel;
@property (weak, nonatomic) IBOutlet UILabel *stealLabel;
@property (weak, nonatomic) IBOutlet UILabel *blocksLabel;
@property (weak, nonatomic) IBOutlet UILabel *turnoversLabel;

- (IBAction)foulsButtonClicked:(id)sender;
- (IBAction)offensiveReboundButtonClicked:(id)sender;
- (IBAction)assistButtonClicked:(id)sender;
- (IBAction)defensiveReboundButtonClicked:(id)sender;
- (IBAction)stealsButtonClicked:(id)sender;
- (IBAction)blocksButtonClicked:(id)sender;
- (IBAction)turnoversButtonClicked:(id)sender;
- (IBAction)toggleButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *toggleButton;
- (IBAction)saveBarButtonClicked:(id)sender;
@end
