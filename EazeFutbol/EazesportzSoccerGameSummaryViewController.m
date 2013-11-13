//
//  EazesportzSoccerGameSummaryViewController.m
//  EazeSportz
//
//  Created by Gil on 11/12/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzSoccerGameSummaryViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazeSoccerStatsViewController.h"

@interface EazesportzSoccerGameSummaryViewController ()

@end

@implementation EazesportzSoccerGameSummaryViewController

@synthesize game;

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
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshButton, self.statsButton, nil];
    
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _hometeamLabel.text = currentSettings.team.mascot;
    _homeimage.image = [currentSettings.team getImage:@"tiny"];
    _visitorteamLabel.text = game.opponent_mascot;
    _vsitorimage.image = [game opponentImage];
    _visitorscoreLabel.text = [game.opponentscore stringValue];
    _homescoreLabel.text = [game.homescore stringValue];
    _periodLabel.text = [game.period stringValue];
    _homeCkLabel.text = [NSString stringWithFormat:@"%d", [game soccerHomeCK]];
    _homeshotsLabel.text = [NSString stringWithFormat:@"%d", [game soccerHomeShots]];
    _homesavesLabel.text = [NSString stringWithFormat:@"%d", [game soccerHomeSaves]];
    _visitorsavesLabel.text = [game.socceroppsaves stringValue];
    _visitorshotsLabel.text = [game.socceroppsog stringValue];
    _visitorCKLabel.text = [game.socceroppck stringValue];
    _clockLabel.text = game.currentgametime;

}

- (IBAction)refreshButtonClicked:(id)sender {
    game = [currentSettings retrieveGame:game.id];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GameStatsSegue"]) {
        EazeSoccerStatsViewController *destController = segue.destinationViewController;
        destController.game = game;
    }
}

@end
