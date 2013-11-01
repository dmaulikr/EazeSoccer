//
//  PassingStatsReceiverViewController.h
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 5/19/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"

@interface PlayerSelectionViewController : UIViewController

@property(nonatomic, strong) Athlete *player;

@property(nonatomic, strong) NSMutableArray *rosterdata;
@property(nonatomic, strong)NSString *jersey;
@property(nonatomic, strong)NSString *position;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@property (weak, nonatomic) IBOutlet UITableView *playerTableView;

- (IBAction)searchButtonClicked:(id)sender;
- (void)searchPlayer;
- (IBAction)searchPlayerSelected:(UIStoryboardSegue *)segue;

@property (weak, nonatomic) IBOutlet UIView *findPlayerContainer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end
