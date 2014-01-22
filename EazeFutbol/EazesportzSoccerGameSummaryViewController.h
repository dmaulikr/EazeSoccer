//
//  EazesportzSoccerGameSummaryViewController.h
//  EazeSportz
//
//  Created by Gil on 11/12/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"

@interface EazesportzSoccerGameSummaryViewController : UIViewController

@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UILabel *hometeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorteamLabel;
@property (weak, nonatomic) IBOutlet UILabel *clockLabel;
@property (weak, nonatomic) IBOutlet UIImageView *homeimage;
@property (weak, nonatomic) IBOutlet UIImageView *vsitorimage;
@property (weak, nonatomic) IBOutlet UILabel *homescoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorscoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeshotsLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeCkLabel;
@property (weak, nonatomic) IBOutlet UILabel *homesavesLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorshotsLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorCKLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorsavesLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;

- (IBAction)refreshButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *statsButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
- (IBAction)teamstatsButtonClicked:(id)sender;
- (IBAction)playerstatsButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *statTableView;

@end
