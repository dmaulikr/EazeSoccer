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

@property (weak, nonatomic) IBOutlet UITableView *soccerPlayerStatsTableView;
@property (weak, nonatomic) IBOutlet UIView *soccerStatsContainer;

-(IBAction)liveSoccerPlayerStats:(UIStoryboardSegue *)segue;
-(IBAction)updateTotalSoccerStats:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UIView *totalStatsContainer;
- (IBAction)saveButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *infoImage;

@end
