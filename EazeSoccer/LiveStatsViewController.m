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
#import "sportzServerInit.h"
#import "SoccerLiveClockViewController.h"

@interface LiveStatsViewController ()

@end

@implementation LiveStatsViewController {
    GameScheduleViewController *gameController;
    SoccerPlayerStatsViewController *soccerStatsController;
    SoccerLiveClockViewController *soccerScoreboardController;
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
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.clockButton, self.gameButton, nil];
    
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
    _soccerClockContainer.hidden = YES;
    
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
        self.title = [NSString stringWithFormat:@"%@%@", @"Live Stats - vs. ", [gameController.thegame opponent]];
    }
    _gameContainer.hidden = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GameSelectSegue"]) {
        gameController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"SoccerPlayerStatsSegue"]) {
        soccerStatsController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"SoccerScoreboardSegue"]) {
        soccerScoreboardController = segue.destinationViewController;
    }
}

- (IBAction)clockButtonClicked:(id)sender {
    if (gameController.thegame) {
        if ([currentSettings.sport.name isEqualToString:@"Soccer"]) {
            soccerScoreboardController.game = gameController.thegame;
            [soccerScoreboardController viewWillAppear:YES];
            _soccerClockContainer.hidden = NO;
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Select a game first!"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (IBAction)gameButtonClicked:(id)sender {
    _gameContainer.hidden = NO;
}

- (IBAction)soccerClockClose:(UIStoryboardSegue *)segue {
    _soccerClockContainer.hidden = YES;
}

@end
