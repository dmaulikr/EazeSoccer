//
//  EazeFootballPlayerStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 1/21/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"

@interface EazeFootballPlayerStatsViewController : UIViewController

@property(nonatomic, strong) Athlete *player;

- (IBAction)passButtonClicked:(id)sender;
- (IBAction)rushButtonClicked:(id)sender;
- (IBAction)receiverButtonClicked:(id)sender;
- (IBAction)defenseButtonClicked:(id)sender;
- (IBAction)kickerButtonClicked:(id)sender;
- (IBAction)returnerButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *playerStatTableView;
- (IBAction)questionButtonClicked:(id)sender;
- (IBAction)infoButtonClicked:(id)sender;

@end
