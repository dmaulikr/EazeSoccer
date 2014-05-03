//
//  EazeFootballPlayerStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 1/21/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

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
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *adBannerContainer;

- (IBAction)passBarButtonClicked:(id)sender;
- (IBAction)rushBarButtonClicked:(id)sender;
- (IBAction)recBarButtonClicked:(id)sender;
- (IBAction)defBarButtonClicked:(id)sender;
- (IBAction)retBarButtonClicked:(id)sender;

- (IBAction)kickBarButtonClicked:(id)sender;
@end
