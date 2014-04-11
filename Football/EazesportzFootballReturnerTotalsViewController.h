//
//  EazesportzFootballReturnerTotalsViewController.h
//  EazeSportz
//
//  Created by Gil on 12/3/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"
#import "GameSchedule.h"

@interface EazesportzFootballReturnerTotalsViewController : UIViewController

@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UIImageView *playerImage;
@property (weak, nonatomic) IBOutlet UILabel *playerNumber;
@property (weak, nonatomic) IBOutlet UILabel *playerName;

@property (weak, nonatomic) IBOutlet UITextField *puntreturnTextField;
@property (weak, nonatomic) IBOutlet UITextField *puntreturnlongTextField;
@property (weak, nonatomic) IBOutlet UITextField *puntreturntdTextField;
@property (weak, nonatomic) IBOutlet UITextField *puntreturnyardsTextField;
@property (weak, nonatomic) IBOutlet UITextField *kickoffreturnTextField;
@property (weak, nonatomic) IBOutlet UITextField *kickoffreturnlongTextField;
@property (weak, nonatomic) IBOutlet UITextField *kickoffreturntdTextField;
@property (weak, nonatomic) IBOutlet UITextField *kickoffreturnyardsTextField;
@property (weak, nonatomic) IBOutlet UITextField *kickoffReturnAverageTextField;
@property (weak, nonatomic) IBOutlet UITextField *puntReturnAverageTextField;

- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)saveBarButtonClicked:(id)sender;

@end
