//
//  EazesportzFootballStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 11/21/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"
#import "GameSchedule.h"

@interface EazesportzFootballStatsViewController : UIViewController

@property(nonatomic, strong) Athlete *athlete;
@property(nonatomic, strong) GameSchedule *game;

- (IBAction)offenseButtonClicked:(id)sender;
- (IBAction)defenseButtonClicked:(id)sender;
- (IBAction)specialteamsButtonClicked:(id)sender;
- (IBAction)addplayerButtonClicked:(id)sender;
- (IBAction)savestatsButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *statsTableView;
@property (weak, nonatomic) IBOutlet UILabel *statLabel;

@end
