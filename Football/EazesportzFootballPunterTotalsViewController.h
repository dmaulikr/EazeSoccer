//
//  EazesportzFootballPunterTotalsViewController.h
//  EazeSportz
//
//  Created by Gil on 12/3/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"
#import "GameSchedule.h"

@interface EazesportzFootballPunterTotalsViewController : UIViewController

@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UIImageView *playerImage;
@property (weak, nonatomic) IBOutlet UILabel *playerNumber;
@property (weak, nonatomic) IBOutlet UILabel *playerName;

@property (weak, nonatomic) IBOutlet UITextField *puntsTextField;
@property (weak, nonatomic) IBOutlet UITextField *puntblockedTextField;
@property (weak, nonatomic) IBOutlet UITextField *puntsyardsTextField;
@property (weak, nonatomic) IBOutlet UITextField *puntslongTextField;

- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

@end
