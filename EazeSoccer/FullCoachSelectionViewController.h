//
//  FullCoachSelectionViewController.h
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/17/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "CoachSelectionViewController.h"

@interface FullCoachSelectionViewController : CoachSelectionViewController
@property (weak, nonatomic) IBOutlet UITableView *coachTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addCoachButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *teamButton;
- (IBAction)changeteamButtonClicked:(id)sender;
- (IBAction)segmentButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentButton;

@end
