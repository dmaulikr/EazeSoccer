//
//  PlayerStatisticsViewController.h
//  Basketball Console
//
//  Created by Gil on 9/23/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"
#import "GameSchedule.h"

@interface BasketballTotalStatsViewController : UIViewController

@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UITextField *fgmTextField;
@property (weak, nonatomic) IBOutlet UITextField *fgaTextField;
@property (weak, nonatomic) IBOutlet UITextField *fgpTextField;
@property (weak, nonatomic) IBOutlet UITextField *threefgmTextField;
@property (weak, nonatomic) IBOutlet UITextField *threefgaTextField;
@property (weak, nonatomic) IBOutlet UITextField *threefgpTextField;
@property (weak, nonatomic) IBOutlet UITextField *ftmTextField;
@property (weak, nonatomic) IBOutlet UITextField *ftaTextField;
@property (weak, nonatomic) IBOutlet UITextField *ftpTextField;
@property (weak, nonatomic) IBOutlet UITextField *foulsTextField;
@property (weak, nonatomic) IBOutlet UITextField *assistsTextField;
@property (weak, nonatomic) IBOutlet UITextField *stealsTextField;
@property (weak, nonatomic) IBOutlet UITextField *blocksTextField;
@property (weak, nonatomic) IBOutlet UITextField *offrbTextField;
@property (weak, nonatomic) IBOutlet UITextField *defrbTextField;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
- (IBAction)SubmitButtonClicked:(id)sender;
@end
