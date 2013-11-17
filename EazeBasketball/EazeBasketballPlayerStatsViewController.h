//
//  PlayerStatsViewController.h
//  Eazebasketball
//
//  Created by Gil on 10/2/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

#import "GameSchedule.h"
#import "Athlete.h"

@interface EazeBasketballPlayerStatsViewController : UIViewController

@property(nonatomic, strong) GameSchedule *game;
@property(nonatomic, strong) Athlete *player;

@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *poistionLabel;
@property (weak, nonatomic) IBOutlet UILabel *FGALabel;
@property (weak, nonatomic) IBOutlet UILabel *fgmLabel;
@property (weak, nonatomic) IBOutlet UILabel *fgpLabel;
@property (weak, nonatomic) IBOutlet UILabel *threefgaLabel;
@property (weak, nonatomic) IBOutlet UILabel *threefgmLabel;
@property (weak, nonatomic) IBOutlet UILabel *threefgpLabel;
@property (weak, nonatomic) IBOutlet UILabel *ftaLabel;
@property (weak, nonatomic) IBOutlet UILabel *ftmLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *foulsLabel;
@property (weak, nonatomic) IBOutlet UILabel *assistsLabel;
@property (weak, nonatomic) IBOutlet UILabel *stealLabel;
@property (weak, nonatomic) IBOutlet UILabel *blocksLabel;
@property (weak, nonatomic) IBOutlet UILabel *offrebLabel;
@property (weak, nonatomic) IBOutlet UILabel *defrebLabel;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *ftpLabel;
- (IBAction)totalsButtonClicked:(id)sender;
@end
