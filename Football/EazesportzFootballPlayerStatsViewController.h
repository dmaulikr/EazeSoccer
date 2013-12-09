//
//  EazesportzFootballPlayerStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 12/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"
#import "GameSchedule.h"

@interface EazesportzFootballPlayerStatsViewController : UIViewController

@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UITableView *playerstatsTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *offenseButton;
- (IBAction)offenseButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *defenseButton;
- (IBAction)defenseButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *specialteamsButton;
- (IBAction)specialteamsButtonClicked:(id)sender;

@end
