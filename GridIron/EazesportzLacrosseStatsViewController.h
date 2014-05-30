//
//  EazesportzLacrosseStatsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/23/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EazesportzLacrosseStatsViewController : UIViewController

- (IBAction)playerButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *statsTableView;
- (IBAction)goalieButtonClicked:(id)sender;
@end
