//
//  EazesportzScheduleViewController.h
//  EazeSportz
//
//  Created by Gil on 1/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "GameScheduleViewController.h"

#import <iAd/iAd.h>

@interface EazesportzScheduleViewController : GameScheduleViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addGameButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editGameButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *standingsButton;
- (IBAction)editGameButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *adBannerContainer;
@end
