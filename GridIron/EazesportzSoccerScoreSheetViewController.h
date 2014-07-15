//
//  EazesportzSoccerScoreSheetViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/8/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"

@interface EazesportzSoccerScoreSheetViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;
@property (nonatomic, assign) BOOL isVisitingTeam;

@property (weak, nonatomic) IBOutlet UITableView *scoreSheetTableView;
- (IBAction)scoreButtonClicked:(id)sender;
- (IBAction)subsButtonClicked:(id)sender;
- (IBAction)cardButtonClicked:(id)sender;
- (IBAction)statsButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *playerStatsContainer;
@property (weak, nonatomic) IBOutlet UIView *goalieStatsContainer;
@property (weak, nonatomic) IBOutlet UIView *scoreStatsContainer;
@property (weak, nonatomic) IBOutlet UIView *penaltyStatsContainer;
@property (weak, nonatomic) IBOutlet UIView *subsStatsContainer;

- (IBAction)soccerPlayerstatsDone:(UIStoryboardSegue *)segue;
- (IBAction)soccerGoaliestatsDone:(UIStoryboardSegue *)segue;
- (IBAction)soccerScorestatsDone:(UIStoryboardSegue *)segue;
- (IBAction)soccerPenaltystatsDone:(UIStoryboardSegue *)segue;
- (IBAction)soccerSubstatsDone:(UIStoryboardSegue *)segue;

@end
