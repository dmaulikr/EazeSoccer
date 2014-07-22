//
//  EazesportzBasketballOtherStatsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"

@interface EazesportzBasketballOtherStatsViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UITableView *otherStatsTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;
- (IBAction)saveBarButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *infoBarButton;
- (IBAction)infoBarButtonClicked:(id)sender;
@end
