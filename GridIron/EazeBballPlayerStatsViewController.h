//
//  EazeBballPlayerStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 1/22/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

#import "Athlete.h"

@interface EazeBballPlayerStatsViewController : UIViewController

@property(nonatomic, strong) Athlete *player;

@property (weak, nonatomic) IBOutlet UITableView *playerStatsTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statSelector;
- (IBAction)statSelectorButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *adBannerContainer;
@end
