//
//  EazesportzWaterPoloGameSummaryStatsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzWaterPoloGameSummaryViewController.h"

@interface EazesportzWaterPoloGameSummaryStatsViewController : EazesportzWaterPoloGameSummaryViewController

@property (weak, nonatomic) IBOutlet UITableView *statsTableView;

@property (weak, nonatomic) IBOutlet UIView *playerStatsContainer;
@property (weak, nonatomic) IBOutlet UIView *goalieStatsContainer;
@property (weak, nonatomic) IBOutlet UIView *scoreStatsContainer;
@property (weak, nonatomic) IBOutlet UIView *penaltyStatsContainer;

- (IBAction)waterpoloPlayerstatsDone:(UIStoryboardSegue *)segue;
- (IBAction)waterpoloGoaliestatsDone:(UIStoryboardSegue *)segue;
- (IBAction)waterpoloScorestatsDone:(UIStoryboardSegue *)segue;
- (IBAction)waterpoloPenaltystatsDone:(UIStoryboardSegue *)segue;
- (IBAction)statsButtonClicked:(id)sender;
- (IBAction)scoreButtonClicked:(id)sender;
@end
