//
//  GameScheduleViewController.h
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/7/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"

@interface GameScheduleViewController : UIViewController

@property(nonatomic, strong) GameSchedule *thegame;

@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UITableView *gamesTableView;

@end
