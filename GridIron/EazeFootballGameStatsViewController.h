//
//  EazeFootballGameStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 1/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"

@interface EazeFootballGameStatsViewController : UIViewController

@property(nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UIImageView *homeImage;
@property (weak, nonatomic) IBOutlet UILabel *homeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *visitorImage;
@property (weak, nonatomic) IBOutlet UILabel *visitorLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorScore;
@property (weak, nonatomic) IBOutlet UILabel *homeScore;
@property (weak, nonatomic) IBOutlet UILabel *clockLabel;
- (IBAction)teamButtonClicked:(id)sender;
- (IBAction)passButtonClicked:(id)sender;
- (IBAction)receiverButtonClicked:(id)sender;
- (IBAction)rushingButtonClicked:(id)sender;
- (IBAction)defenseButtonClicked:(id)sender;
- (IBAction)kickerButtonClicked:(id)sender;
- (IBAction)returnerButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *passButton;
@property (weak, nonatomic) IBOutlet UIButton *receiverButton;
@property (weak, nonatomic) IBOutlet UIButton *rushButton;
@property (weak, nonatomic) IBOutlet UIButton *defenseButton;
@property (weak, nonatomic) IBOutlet UIButton *kickerButton;
@property (weak, nonatomic) IBOutlet UIButton *returnerButton;

@property (weak, nonatomic) IBOutlet UITableView *statTableView;
- (IBAction)refreshButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
- (IBAction)addButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *playerSelectContainer;
- (IBAction)playerSelected:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UIView *activityIndicator;

@end
