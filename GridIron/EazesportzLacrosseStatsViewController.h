//
//  EazesportzLacrosseStatsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/23/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameSchedule.h"

@interface EazesportzLacrosseStatsViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;

- (IBAction)playerButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *statsTableView;
- (IBAction)goalieButtonClicked:(id)sender;
- (IBAction)homeButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *visitorButton;
- (IBAction)visitorButtonClicked:(id)sender;

- (IBAction)lacrosseShotsAdded:(UIStoryboardSegue *)segue;
- (IBAction)lacrossePlayerStatsAdded:(UIStoryboardSegue *)segue;
- (IBAction)lacrosseGoalieStatsAdded:(UIStoryboardSegue *)segue;

@property (weak, nonatomic) IBOutlet UIView *shotsContainer;

@property (weak, nonatomic) IBOutlet UIView *playerstatsContainer;
@property (weak, nonatomic) IBOutlet UIView *goaliestatsContainer;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshBarButton;
- (IBAction)refreshBarButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *scoreButton;

- (IBAction)scoreButtonClicked:(id)sender;

- (IBAction)lacrossSaveGoalieStat:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;
- (IBAction)saveBarButtonClicked:(id)sender;

@end
