//
//  CoachSelectionViewController.h
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/5/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Coach.h"

@interface CoachSelectionViewController : UIViewController

@property(nonatomic, strong) Coach *coach;

@property (weak, nonatomic) IBOutlet UITableView *coachTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
- (IBAction)addButtonClicked:(id)sender;

@end
