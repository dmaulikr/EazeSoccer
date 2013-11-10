//
//  BasketballStatsViewController.h
//  EazeSportz
//
//  Created by Gil on 11/8/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameSchedule.h"
#import "Athlete.h"

@interface BasketballStatsViewController : UIViewController

@property(nonatomic, strong) GameSchedule *game;
@property(nonatomic, strong) Athlete *athlete;

@property (weak, nonatomic) IBOutlet UITableView *basketballTableView;
- (IBAction)saveButtonClicked:(id)sender;

-(IBAction)liveBasketballPlayerStats:(UIStoryboardSegue *)segue;
-(IBAction)updateTotalBasketballStats:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UIView *basketballLiveStatsContainer;

@end
