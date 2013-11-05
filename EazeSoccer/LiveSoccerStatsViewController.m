//
//  LiveSoccerStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 11/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "LiveSoccerStatsViewController.h"

@interface LiveSoccerStatsViewController ()

@end

@implementation LiveSoccerStatsViewController

@synthesize playerStats;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    playerStats = [player findSoccerGameStats:game.id];
}

- (IBAction)goalButtonClicked:(id)sender {
    playerStats.goals = [NSNumber numberWithInt:[playerStats.goals intValue] + 1 ];
    _goalLabel.text = [playerStats.goals stringValue];
}

- (IBAction)shotsButtonClicked:(id)sender {
    playerStats.shotstaken = [NSNumber numberWithInt:[playerStats.shotstaken intValue] + 1];
    _shotsLabel.text = [playerStats.shotstaken stringValue];
}

- (IBAction)assistsButtonClicked:(id)sender {
    playerStats.assists = [NSNumber numberWithInt:[playerStats.assists intValue] + 1];
    _assistsLabel.text = [playerStats.assists stringValue];
}

- (IBAction)stealButtonClicked:(id)sender {
}

- (IBAction)savesButtonClicked:(id)sender {
}
- (IBAction)golasAgainstButtonClicked:(id)sender {
}
- (IBAction)submitButtonClicked:(id)sender {
}

- (IBAction)updateTotalsButtonClicked:(id)sender {
}
@end
