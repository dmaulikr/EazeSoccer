//
//  EazesportzLacrosseGameStatsViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/25/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EazesportzAppDelegate.h"

#import "GameSchedule.h"

@interface EazesportzLacrosseGameStatsViewController : UIViewController

@property (nonatomic, strong) GameSchedule *game;

@property (weak, nonatomic) IBOutlet UITableView *scoreLogTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sheetButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *statsButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *visitorBarButton;

- (IBAction)saveButtonClicked:(id)sender;
- (IBAction)scoreButtonClicked:(id)sender;
- (IBAction)penaltyButtonClicked:(id)sender;
- (IBAction)extramanButtonClicked:(id)sender;
- (IBAction)clearsButtonClicked:(id)sender;

- (IBAction)homeBarButtonClicked:(id)sender;
- (IBAction)visitorBarButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *penaltyContainer;

- (IBAction)saveLacrossePenalty:(UIStoryboardSegue *)segue;
- (IBAction)deleteLacrossePenalty:(UIStoryboardSegue *)segue;
- (IBAction)saveLacrosseExtraManFail:(UIStoryboardSegue *)segue;
- (IBAction)saveLacrosseClears:(UIStoryboardSegue *)segue;

@property (weak, nonatomic) IBOutlet UIView *extramanContainer;
@property (weak, nonatomic) IBOutlet UIView *clearContainer;

@end
