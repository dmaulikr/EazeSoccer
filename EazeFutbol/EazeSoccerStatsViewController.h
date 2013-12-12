//
//  EazeSoccerStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 11/12/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "SoccerPlayerStatsViewController.h"

@interface EazeSoccerStatsViewController : SoccerPlayerStatsViewController

@property (weak, nonatomic) IBOutlet UITableView *soccerPlayerStatsTableView;
- (IBAction)refreshBurronClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *goalieStatsTableView;

@end
