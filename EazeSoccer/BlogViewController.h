//
//  BlogViewController.h
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/5/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"
#import "Team.h"
#import "Athlete.h"
#import "Coach.h"
#import "User.h"
//#import "Gamelogs.h"
#import "GameScheduleViewController.h"

@interface BlogViewController : UIViewController

@property(nonatomic, strong) GameSchedule *game;
@property(nonatomic, strong) Team *team;
@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) Coach *coach;
@property(nonatomic, strong) User *user;
//@property(nonatomic, strong) Gamelogs *gamelog;
@property(nonatomic, strong) GameScheduleViewController *gameController;

@property(nonatomic, strong) NSMutableArray *blogfeed;

- (void)getBlogs:(NSString *)fromdate;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
- (IBAction)searchBurronClicked:(id)sender;

- (IBAction)refreshButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *blogTableView;

@property (weak, nonatomic) IBOutlet UIView *playerSelectionContainer;
@property (weak, nonatomic) IBOutlet UIView *coachSelectionContainer;

- (IBAction)selectUser:(UIStoryboardSegue *)segue;

@property (weak, nonatomic) IBOutlet UIView *gameScheduleContainer;
@property (weak, nonatomic) IBOutlet UIView *userContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBlogEntryButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *teamButton;
- (IBAction)teamButtonClicked:(id)sender;

- (IBAction)playerSelected:(UIStoryboardSegue *)segue;
- (IBAction)gameSelected:(UIStoryboardSegue *)segue;
- (IBAction)coachSelected:(UIStoryboardSegue *)segue;

- (void)displayUpgradeAlert;

@end
