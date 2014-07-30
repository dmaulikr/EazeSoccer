//
//  EazesportzWaterPoloScoreStatsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/22/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"
#import "WaterPoloScoring.h"

@interface EazesportzWaterPoloScoreStatsViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;
@property (nonatomic, strong) WaterPoloScoring *score;
@property (nonatomic, assign) BOOL visitor;

- (IBAction)submitButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *secondsTextField;
@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *assistsTextField;
@property (weak, nonatomic) IBOutlet UITextField *playerTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *periodSegmentControl;
- (IBAction)periodSegmentControlClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteButtonClicked:(id)sender;
@end
