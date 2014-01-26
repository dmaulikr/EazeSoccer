//
//  SoccerPlayerStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 11/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"
#import "Athlete.h"

@interface SoccerPlayerStatsViewController : UIViewController

@property(nonatomic, strong) GameSchedule *game;
@property(nonatomic, strong) Athlete *athlete;
@property(nonatomic, strong) NSMutableArray *goalies;

@property (weak, nonatomic) IBOutlet UITableView *soccerPlayerStatsTableView;
@property (weak, nonatomic) IBOutlet UIView *soccerStatsContainer;
@property (weak, nonatomic) IBOutlet UILabel *clockLabel;
@property (weak, nonatomic) IBOutlet UITextField *visitorScoreTextField;

-(IBAction)liveSoccerPlayerStats:(UIStoryboardSegue *)segue;
-(IBAction)updateTotalSoccerStats:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UIView *totalStatsContainer;
- (IBAction)saveButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *infoImage;

@property (weak, nonatomic) IBOutlet UIImageView *homeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *visitorImageView;
@property (weak, nonatomic) IBOutlet UILabel *homeScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorTeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeSavesLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeCKLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeShotsLabel;
@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondsTextField;
@property (weak, nonatomic) IBOutlet UITextField *periodTextField;
@property (weak, nonatomic) IBOutlet UIButton *finalButton;
- (IBAction)finalButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *finalLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorShotsLabel;
@property (weak, nonatomic) IBOutlet UITextField *visitorShotsTextfield;
@property (weak, nonatomic) IBOutlet UILabel *visitorCKLabel;
@property (weak, nonatomic) IBOutlet UITextField *visitorCKTextField;
@property (weak, nonatomic) IBOutlet UILabel *visitorSavesLabel;
@property (weak, nonatomic) IBOutlet UITextField *visitorSavesTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end
