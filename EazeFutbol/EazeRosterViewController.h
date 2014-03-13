//
//  EazeRosterViewViewController.h
//  EazeSportz
//
//  Created by Gil on 11/12/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "PlayerSelectionViewController.h"

#import <iAd/iAd.h>

@interface EazeRosterViewController : PlayerSelectionViewController
@property (weak, nonatomic) IBOutlet UITableView *rosterTableView;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *coachesButton;

@end
