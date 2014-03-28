//
//  EazesportzFootballTotalsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 3/25/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"
#import "GameSchedule.h"

@interface EazesportzFootballTotalsViewController : UIViewController

@property (nonatomic, strong) Athlete *athlete;
@property (nonatomic, strong) GameSchedule *game;
@property (nonatomic, strong) NSMutableArray *qbs, *rbs, *wrs, *pks, *kickerlist, *returnerlist, *punterlist, *defenselist;

@property (weak, nonatomic) IBOutlet UITableView *statsTableView;
- (IBAction)specialteamsButtonClicked:(id)sender;
- (IBAction)defenseButtonClicked:(id)sender;
- (IBAction)offenseButtonClicked:(id)sender;

@end
