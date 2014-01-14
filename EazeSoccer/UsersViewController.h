//
//  UsersViewController.h
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/5/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"

@interface UsersViewController : UIViewController

@property(nonatomic, strong) User *user;
@property(nonatomic, strong) NSMutableArray *users;

@property (weak, nonatomic) IBOutlet UITableView *usertableView;
- (IBAction)searchButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *userSearchContainer;

- (IBAction)selectSearchUserTable:(UIStoryboardSegue *)segue;
- (IBAction)segmentButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentButton;
@end
