//
//  EazesportzReturnerStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 11/30/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"
#import "GameSchedule.h"

@interface EazesportzReturnerStatsViewController : UIViewController

@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UIImageView *playerImage;
@property (weak, nonatomic) IBOutlet UILabel *playerNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *koreturnsLabel;
@property (weak, nonatomic) IBOutlet UILabel *koreturnyardsLabel;
@property (weak, nonatomic) IBOutlet UILabel *kotdLabel;
@property (weak, nonatomic) IBOutlet UILabel *kolongLabel;
@property (weak, nonatomic) IBOutlet UILabel *puntreturnsLabel;
@property (weak, nonatomic) IBOutlet UILabel *puntreturnyardsLabel;
@property (weak, nonatomic) IBOutlet UILabel *puntreturntdLabel;
@property (weak, nonatomic) IBOutlet UILabel *puntreturnlongLabel;
- (IBAction)kickoffreturnButtonClicked:(id)sender;
- (IBAction)puntreturnButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *returnYardsTextField;
- (IBAction)tdButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *quarterLabel;
@property (weak, nonatomic) IBOutlet UITextField *quarterTextField;
@property (weak, nonatomic) IBOutlet UILabel *timeofscoreLabel;
@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
@property (weak, nonatomic) IBOutlet UILabel *colonLabel;
@property (weak, nonatomic) IBOutlet UITextField *secondsTextField;
- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *totalsButton;
@property (weak, nonatomic) IBOutlet UIButton *kickoffReturnButton;
@property (weak, nonatomic) IBOutlet UIButton *puntReturnButton;
@property (weak, nonatomic) IBOutlet UILabel *returnYardsLabel;
@end
