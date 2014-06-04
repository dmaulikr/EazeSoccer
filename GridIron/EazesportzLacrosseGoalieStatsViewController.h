//
//  EazesportzLacrosseGoalieStatsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/2/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"
#import "Athlete.h"
#import "VisitorRoster.h"

@interface EazesportzLacrosseGoalieStatsViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;
@property (nonatomic, strong) Athlete *player;
@property (nonatomic, strong) VisitorRoster *visitingPlayer;

@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (weak, nonatomic) IBOutlet UITextField *periodTextField;
@property (weak, nonatomic) IBOutlet UITextField *savesTextField;
@property (weak, nonatomic) IBOutlet UITextField *goalsagainstTextField;
@property (weak, nonatomic) IBOutlet UITextField *decisionsTextField;
@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
- (IBAction)saveButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@end
