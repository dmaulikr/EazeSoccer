//
//  EazeSoccerPlayerStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 11/13/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazeSoccerPlayerStatsViewController.h"

@interface EazeSoccerPlayerStatsViewController ()

@end

@implementation EazeSoccerPlayerStatsViewController

@synthesize player;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    Soccer *stats;
    
    if ((player) && (game)) {
        stats = [player findSoccerGameStats:game.id];
        self.title = [NSString stringWithFormat:@"%@%@", @"vs ", game.opponent_mascot];
    } else {
        stats = [player soccerSeasonTotals];
        self.title = @"Season Totals";
    }
    
    _playerImage.image = [player getImage:@"tiny"];
    _playerName.text = player.full_name;
    _goalsLabel.text = [stats.goals stringValue];
    _assistsLabel.text = [stats.assists stringValue];
    _stealsLabel.text = [stats.steals stringValue];
    _ckLabel.text = [stats.cornerkicks stringValue];
    _shotsLabel.text = [stats.shotstaken stringValue];
    _pointsLabel.text = [NSString stringWithFormat:@"%d", ([stats.goals intValue] * 2) + [stats.assists intValue]];
    
    if ([player isSoccerGoalie]) {
        _minutesLabel.text = [stats.minutesplayed stringValue];
        _savesLabel.text = [stats.goalssaved stringValue];
        _golasAgainstLabel.text = [stats.goalsagainst stringValue];
    } else {
        _goalieLabel.hidden = YES;
        _savestitleLabel.hidden = YES;
        _gatitleLabel.hidden = YES;
        _minutestitleLabel.hidden = YES;
        _savesLabel.hidden = YES;
        _golasAgainstLabel.hidden = YES;
        _minutesLabel.hidden = YES;
    }
}

- (IBAction)totalsButtonClicked:(id)sender {
    game = nil;
    [self viewWillAppear:YES];
}

@end
