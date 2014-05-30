//
//  EazesportzLacrossePenaltyViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LacrossPenalty.h"
#import "Athlete.h"
#import "VisitorRoster.h"

@interface EazesportzLacrossePenaltyViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *playerTextField;
@property (weak, nonatomic) IBOutlet UITextField *personalFoulTextField;
@property (weak, nonatomic) IBOutlet UITextField *technicalFoulTextField;
@property (weak, nonatomic) IBOutlet UITextField *periodTextField;
@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondsTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) LacrossPenalty *penatlyStat;
@property (nonatomic, strong) Athlete *player;
@property (nonatomic, strong) VisitorRoster *visitor;
@property (nonatomic, assign) BOOL visitingTeam;
@property (nonatomic, strong) GameSchedule *game;

@end
