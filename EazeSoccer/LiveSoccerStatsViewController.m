//
//  LiveSoccerStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 11/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "LiveSoccerStatsViewController.h"

@interface LiveSoccerStatsViewController () <UIAlertViewDelegate>

@end

@implementation LiveSoccerStatsViewController {
    Soccer *originalStats;
}

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
    originalStats = [playerStats copy];
    _assistsLabel.text = [playerStats.assists stringValue];
    _goalLabel.text = [playerStats.goals stringValue];
    _shotsLabel.text = [playerStats.shotstaken stringValue];
    _stealsLabel.text = [playerStats.steals stringValue];
    _goalsAgainstLabel.text = [playerStats.goalsagainst stringValue];
    _savesLabel.text = [playerStats.goalssaved stringValue];
    _minutesPlayedTextField.text = [playerStats.minutesplayed stringValue];
    _cornerKickLabel.text = [playerStats.cornerkicks stringValue];
    [self updatePoints];
}

- (IBAction)goalButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Goal" message:@"" delegate:self cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Goal Made", @"Remove Goal", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)shotsButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shot" message:@"" delegate:self cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add Shot", @"Remove Shot", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)assistsButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Assist" message:@"" delegate:self cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add Assist", @"Remove Assist", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)stealButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Steal" message:@"" delegate:self cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add Steal", @"Remove Steal", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)savesButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saves" message:@"" delegate:self cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add Save", @"Remove Save", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)goalsAgainstButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Goals Against" message:@"" delegate:self cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add GA", @"Remove GA", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)submitButtonClicked:(id)sender {
    [player updateSoccerGameStats:playerStats];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Goal Made"]) {
        playerStats.goals = [NSNumber numberWithInt:[playerStats.goals intValue] + 1 ];
        _goalLabel.text = [playerStats.goals stringValue];
        playerStats.shotstaken = [NSNumber numberWithInt:[playerStats.shotstaken intValue] + 1];
        _shotsLabel.text = [playerStats.shotstaken stringValue];
        [self updatePoints];
    } else if (([title isEqualToString:@"Remove Goal"]) && ([playerStats.goals intValue] > 0)) {
        playerStats.goals = [NSNumber numberWithInt:[playerStats.goals intValue] - 1 ];
        _goalLabel.text = [playerStats.goals stringValue];
        playerStats.shotstaken = [NSNumber numberWithInt:[playerStats.shotstaken intValue] - 1];
        _shotsLabel.text = [playerStats.shotstaken stringValue];
        [self updatePoints];
    } else if ([title isEqualToString:@"Add Shot"]) {
        playerStats.shotstaken = [NSNumber numberWithInt:[playerStats.shotstaken intValue] + 1];
        _shotsLabel.text = [playerStats.shotstaken stringValue];
    } else if (([title isEqualToString:@"Remove Shot"]) && ([playerStats.shotstaken intValue] > 0)) {
        playerStats.shotstaken = [NSNumber numberWithInt:[playerStats.shotstaken intValue] - 1];
        _shotsLabel.text = [playerStats.shotstaken stringValue];
    } else if ([title isEqualToString:@"Add Assist"]) {
        playerStats.assists = [NSNumber numberWithInt:[playerStats.assists intValue] + 1];
        _assistsLabel.text = [playerStats.assists stringValue];
        [self updatePoints];
    } else if (([title isEqualToString:@"Remove Assist"]) && ([playerStats.assists intValue] > 0)) {
        playerStats.assists = [NSNumber numberWithInt:[playerStats.assists intValue] - 1];
        _assistsLabel.text = [playerStats.assists stringValue];
        [self updatePoints];
    } else if ([title isEqualToString:@"Add Steal"]) {
        playerStats.steals = [NSNumber numberWithInt:[playerStats.steals intValue] + 1];
        _stealsLabel.text = [playerStats.steals stringValue];
    } else if (([title isEqualToString:@"Remove Steal"]) && ([playerStats.steals intValue] > 0)) {
        playerStats.steals = [NSNumber numberWithInt:[playerStats.steals intValue] - 1];
        _stealsLabel.text = [playerStats.steals stringValue];
    } else if ([title isEqualToString:@"Add Save"]) {
        playerStats.goalssaved = [NSNumber numberWithInt:[playerStats.goalssaved intValue] + 1];
        _savesLabel.text = [playerStats.goalssaved stringValue];
    } else if (([title isEqualToString:@"Remove Save"]) && ([playerStats.goalssaved intValue] > 0)) {
        playerStats.goalssaved = [NSNumber numberWithInt:[playerStats.goalssaved intValue] - 1];
        _savesLabel.text = [playerStats.goalssaved stringValue];
    } else if ([title isEqualToString:@"Add GA"]) {
        playerStats.goalsagainst = [NSNumber numberWithInt:[playerStats.goalsagainst intValue] + 1];
        _goalsAgainstLabel.text = [playerStats.goalsagainst stringValue];
    } else if (([title isEqualToString:@"Remove GA"]) && ([playerStats.goalsagainst intValue] > 0)) {
        playerStats.goalsagainst = [NSNumber numberWithInt:[playerStats.goalsagainst intValue] - 1];
        _goalsAgainstLabel.text = [playerStats.goalsagainst stringValue];
    } else if ([title isEqualToString:@"Add C/K"]) {
        playerStats.cornerkicks = [NSNumber numberWithInt:[playerStats.cornerkicks intValue] + 1];
        _cornerKickLabel.text = [playerStats.cornerkicks stringValue];
    } else if (([title isEqualToString:@"Remove C/K"]) && ([playerStats.cornerkicks intValue] > 0)) {
        playerStats.cornerkicks = [NSNumber numberWithInt:[playerStats.cornerkicks intValue] - 1];
        _cornerKickLabel.text = [playerStats.cornerkicks stringValue];
    }
}

- (void)updatePoints {
    _pointsLabel.text = [NSString stringWithFormat:@"%d", ([playerStats.goals intValue] * 2) + [playerStats.assists intValue]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (!_submitButton.touchInside) {
        playerStats = [originalStats copy];
    }
}

- (IBAction)cornerKickButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Corner Kick" message:@"" delegate:self cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add C/K", @"Remove C/K", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}
@end
