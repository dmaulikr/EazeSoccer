//
//  FullViewPlayerSelectionViewController.h
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/2/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "PlayerSelectionViewController.h"

@interface FullViewPlayerSelectionViewController : PlayerSelectionViewController

- (IBAction)refreshButtonClicked:(id)sender;
- (IBAction)searchPlayerButtonClicked:(id)sender;

- (IBAction)findFullPlayerSelected:(UIStoryboardSegue *)segue;

@property (weak, nonatomic) IBOutlet UITableView *playerTableView;
@property (weak, nonatomic) IBOutlet UIView *findPlayerContainer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *teamButton;
- (IBAction)teamButtonClicked:(id)sender;

@end
