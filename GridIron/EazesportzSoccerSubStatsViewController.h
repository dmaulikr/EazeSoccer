//
//  EazesportzSoccerSubStatsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/12/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"
#import "SoccerSubs.h"

@interface EazesportzSoccerSubStatsViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;
@property (nonatomic, assign) BOOL visitor;
@property (nonatomic, strong) SoccerSubs *subentry;

@property (weak, nonatomic) IBOutlet UISegmentedControl *periodSegmentedControl;
- (IBAction)periodSegmentedControlClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *inplayerTextField;
@property (weak, nonatomic) IBOutlet UITextField *outplayerTextField;
@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondsTextField;
- (IBAction)submitButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteButtonClicked:(id)sender;

@end
