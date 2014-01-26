//
//  EazeFootballGameSummaryViewController.h
//  EazeSportz
//
//  Created by Gil on 1/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"

@interface EazeFootballGameSummaryViewController : UIViewController

@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UIImageView *homeImage;
@property (weak, nonatomic) IBOutlet UIImageView *visitorImage;
@property (weak, nonatomic) IBOutlet UILabel *sbhomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sbvisitorLabel;
@property (weak, nonatomic) IBOutlet UILabel *clockLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeTimeOutLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorTimeOutLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLabel;
@property (weak, nonatomic) IBOutlet UILabel *togoLabel;
@property (weak, nonatomic) IBOutlet UILabel *ballonLabel;
@property (weak, nonatomic) IBOutlet UILabel *quarterLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumhomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumvisitorLabel;
@property (weak, nonatomic) IBOutlet UILabel *hq1Label;
@property (weak, nonatomic) IBOutlet UILabel *hq2Label;
@property (weak, nonatomic) IBOutlet UILabel *hq3Label;
@property (weak, nonatomic) IBOutlet UILabel *hq4Label;
@property (weak, nonatomic) IBOutlet UILabel *htotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *vq1Label;
@property (weak, nonatomic) IBOutlet UILabel *vq2Label;
@property (weak, nonatomic) IBOutlet UILabel *vq3Label;
@property (weak, nonatomic) IBOutlet UILabel *vq4Label;
@property (weak, nonatomic) IBOutlet UILabel *vtotalLabel;
@property (weak, nonatomic) IBOutlet UITableView *gamelogTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
- (IBAction)refreshButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *statsButton;
- (IBAction)statsButtonClicked:(id)sender;

@end
