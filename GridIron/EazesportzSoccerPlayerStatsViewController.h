//
//  EazesportzSoccerPlayerStatsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/11/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"
#import "Athlete.h"

@interface EazesportzSoccerPlayerStatsViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;
@property (nonatomic, strong) Athlete *player;
@property (nonatomic, assign) BOOL visitor;

@property (weak, nonatomic) IBOutlet UISegmentedControl *periodSegmentedControl;
- (IBAction)periodSegmentedControlClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *shotsTextField;
@property (weak, nonatomic) IBOutlet UITextField *cornerkickTextField;
@property (weak, nonatomic) IBOutlet UITextField *stealsTextField;
@property (weak, nonatomic) IBOutlet UITextField *foulsTextField;
- (IBAction)submitButtonClicked:(id)sender;

@end
