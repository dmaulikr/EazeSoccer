//
//  EazeSoccerPlayerStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 11/13/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EazesportzAppDelegate.h"

@interface EazeSoccerPlayerStatsViewController : UIViewController

@property(nonatomic, strong) Athlete *player;
@property(nonatomic, strong) GameSchedule *game;
@property (weak, nonatomic) IBOutlet UIImageView *playerImage;
@property (weak, nonatomic) IBOutlet UILabel *playerName;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalsLabel;
@property (weak, nonatomic) IBOutlet UILabel *shotsLabel;
@property (weak, nonatomic) IBOutlet UILabel *assistsLabel;
@property (weak, nonatomic) IBOutlet UILabel *stealsLabel;
@property (weak, nonatomic) IBOutlet UILabel *ckLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *savesLabel;
@property (weak, nonatomic) IBOutlet UILabel *golasAgainstLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
- (IBAction)totalsButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *savestitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *gatitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutestitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalieLabel;

@end
