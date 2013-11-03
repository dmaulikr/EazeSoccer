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

@interface BlogViewController : UIViewController

@property(nonatomic, strong) GameSchedule *game;
@property(nonatomic, strong) Team *team;
@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) Coach *coach;
@property(nonatomic, strong) User *user;
//@property(nonatomic, strong) Gamelogs *gamelog;

- (IBAction)refreshButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *blogTableView;

- (IBAction)userButtonClicked:(id)sender;
- (IBAction)playerButtonClicked:(id)sender;
- (IBAction)coachButtonClicked:(id)sender;
- (IBAction)gameButtonClicked:(id)sender;
- (IBAction)allButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *playerSelectionContainer;
@property (weak, nonatomic) IBOutlet UIView *coachSelectionContainer;

- (IBAction)selectBlogSearchPlayer:(UIStoryboardSegue *)segue;
- (IBAction)selectBlogSearchCoach:(UIStoryboardSegue *)segue;
- (IBAction)selectBlogSearchUser:(UIStoryboardSegue *)segue;
- (IBAction)selectBlogSearchGame:(UIStoryboardSegue *)segue;

@property (weak, nonatomic) IBOutlet UIView *gameScheduleContainer;
@property (weak, nonatomic) IBOutlet UIView *userContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBlogEntryButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@end
