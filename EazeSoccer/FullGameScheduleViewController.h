//
//  FullGameScheduleViewController.h
//  EazeSportz
//
//  Created by Gil on 11/7/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "GameScheduleViewController.h"

@interface FullGameScheduleViewController : GameScheduleViewController
@property (weak, nonatomic) IBOutlet UITableView *gamesTableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *teamButton;
- (IBAction)teamButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addGameButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *standingsButton;
@end
