//
//  EazesportzLacrosseScoreEntryViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/28/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"
#import "LacrossScoring.h"
#import "Athlete.h"
#import "VisitorRoster.h"

@interface EazesportzLacrosseScoreEntryViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;
@property (nonatomic, assign) BOOL visitingTeam;
@property (nonatomic, strong) LacrossScoring *scorestat;
@property (nonatomic, strong) Athlete *athlete;
@property (nonatomic, strong) VisitorRoster *visitor;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondsTextField;
@property (weak, nonatomic) IBOutlet UITextField *periodTextField;
@property (weak, nonatomic) IBOutlet UITextField *scorecodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *playergoalTextField;
@property (weak, nonatomic) IBOutlet UITextField *playerassistTextField;

@end
