//
//  LiveStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 11/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "LiveStatsViewController.h"
#import "EazesportzAppDelegate.h"
#import "SoccerPlayerStatsViewController.h"
#import "GameScheduleViewController.h"

@interface LiveStatsViewController ()

@end

@implementation LiveStatsViewController {
    GameScheduleViewController *gameController;
    SoccerPlayerStatsViewController *soccerStatsController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.saveButton, self.refreshButton, self.clockButton, self.gameButton, nil];
    
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _gameContainer.hidden = YES;
    
    if ([currentSettings.sport.name isEqualToString:@"Soccer"]) {
        _soccerContainer.hidden = NO;
    }
}

- (IBAction)selectGameLiveStats:(UIStoryboardSegue *)segue {
    if (gameController.thegame) {
        if ([currentSettings.sport.name isEqualToString:@"Soccer"]) {
            soccerStatsController.game = gameController.thegame;
            [soccerStatsController viewWillAppear:YES];
        }
    }
    _gameContainer.hidden = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GameSelectSegue"]) {
        gameController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"SoccerPlayerStatsSegue"]) {
        soccerStatsController = segue.destinationViewController;
    }
}

- (IBAction)saveButtonClicked:(id)sender {
}

- (IBAction)refreshButtonClicked:(id)sender {
}

- (IBAction)clockButtonClicked:(id)sender {
}

- (IBAction)gameButtonClicked:(id)sender {
    _gameContainer.hidden = NO;
}

@end
