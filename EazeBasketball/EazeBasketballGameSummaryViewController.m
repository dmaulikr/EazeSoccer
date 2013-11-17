//
//  EazeBasketballGameSummaryViewController.m
//  EazeSportz
//
//  Created by Gil on 11/16/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazeBasketballGameSummaryViewController.h"
#import "EazesportzAppDelegate.h"

@interface EazeBasketballGameSummaryViewController ()

@end

@implementation EazeBasketballGameSummaryViewController

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
    
    _gameclockLabel.text = game.currentgametime;
    _hometeamLabelText.text = currentSettings.team.mascot;
    _visitorLabelText.text = game.opponent_mascot;
    _hometeamImage.image = [currentSettings.team getImage:@"tiny"];
    _visitorTeamImage.image = [game opponentImage];
    _homefoulsLabel.text = [NSString stringWithFormat:@"%d", [game homeBasketballFouls]];
    _visitorFoulsLabel.text = [game.visitorfouls stringValue];
    
    if (game.homebonus)
        _homeBonusImage.hidden = NO;
    else
        _homeBonusImage.hidden = YES;
    
    if (game.visitorbonus)
        _visitorBonusImage.hidden = NO;
    else
        _visitorBonusImage.hidden = YES;
    
    _periodLabel.text = [game.period stringValue];
    _homeScoreLabel.text = [game.homescore stringValue];
    _visitorScoreLabel.text = [game.opponentscore stringValue];
    
    if ([game.possession isEqualToString:@"Home"]) {
        _homePossesionArrow.hidden = NO;
        _visitorPossessionArrow.hidden = YES;
    } else {
        _homePossesionArrow.hidden = YES;
        _visitorPossessionArrow.hidden = NO;
    }
}

- (IBAction)refreshButtonClicked:(id)sender {
    [currentSettings retrieveGame:game.id];
    [self viewWillAppear:YES];
}

@end
