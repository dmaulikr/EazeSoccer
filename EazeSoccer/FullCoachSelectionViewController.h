//
//  FullCoachSelectionViewController.h
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/17/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "CoachSelectionViewController.h"

#import<iAd/iAd.h>

@interface FullCoachSelectionViewController : CoachSelectionViewController
@property (weak, nonatomic) IBOutlet UITableView *coachTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *teamButton;
- (IBAction)changeteamButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
- (IBAction)refreshButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *adBannerContainer;

@end
