//
//  EazesportzScoreLogViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/3/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"
#import "LacrossScoring.h"
#import "SoccerScoring.h"
#import "HockeyScoring.h"
#import "WaterPoloScoring.h"

@interface EazesportzScoreLogViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;
@property (nonatomic, strong) LacrossScoring *lacrosse_score;
@property (nonatomic, strong) HockeyScoring *hockey_score;
@property (nonatomic, strong) SoccerScoring *soccer_score;
@property (nonatomic, strong) WaterPoloScoring *waterpolo_score;

@property (weak, nonatomic) IBOutlet UITableView *scorelogTableView;

@end
