//
//  SoccerLiveClockViewController.h
//  EazeSportz
//
//  Created by Gil on 11/5/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"

@interface SoccerLiveClockViewController : UIViewController

@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UITextField *visitorScoreTextField;
@property (weak, nonatomic) IBOutlet UIImageView *homeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *visitorImageView;
@property (weak, nonatomic) IBOutlet UILabel *clockLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;
@property (weak, nonatomic) IBOutlet UITextField *periodTextView;
@property (weak, nonatomic) IBOutlet UILabel *homeShotsLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeCKLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeSavesLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorShotsLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorCKLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorSavesLabel;
@property (weak, nonatomic) IBOutlet UITextField *visitorShotsTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorCKTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitorSavesTextField;
@property (weak, nonatomic) IBOutlet UILabel *hometeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitingTeamLabel;
- (IBAction)saveButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *minutesTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondsTextField;
@end
