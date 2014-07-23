//
//  EazesportzWaterPoloStatsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/22/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"

@interface EazesportzWaterPoloStatsViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;
@property (nonatomic, assign) BOOL isVisitingTeam;

@property (weak, nonatomic) IBOutlet UITableView *statsTableView;

@property (weak, nonatomic) IBOutlet UIView *playerStatsContainer;
@property (weak, nonatomic) IBOutlet UIView *goalieStatsContainer;
@property (weak, nonatomic) IBOutlet UIView *scoreStatsContainer;
@property (weak, nonatomic) IBOutlet UIView *penaltyStatsContainer;

- (IBAction)waterpoloPlayerstatsDone:(UIStoryboardSegue *)segue;
- (IBAction)waterpoloGoaliestatsDone:(UIStoryboardSegue *)segue;
- (IBAction)waterpoloScorestatsDone:(UIStoryboardSegue *)segue;
- (IBAction)waterpoloPenaltystatsDone:(UIStoryboardSegue *)segue;

@end
