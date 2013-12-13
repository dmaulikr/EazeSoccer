//
//  EazesportzBasketballNonScoreStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 12/12/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzBasketballNonScoreStatsViewController.h"

@interface EazesportzBasketballNonScoreStatsViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzBasketballNonScoreStatsViewController {
    BasketballStats *originalStats;
}

@synthesize stats;
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
    
    stats = [player findBasketballGameStatEntries:game.id];
    originalStats = [stats copy];
    
    _foulLabel.text = [NSString stringWithFormat:@"%d", [stats.fouls intValue]];
    _blockLabel.text = [NSString stringWithFormat:@"%d", [stats.blocks intValue]];
    _stealLabel.text = [NSString stringWithFormat:@"%d", [stats.steals intValue]];
    _offrbLabel.text = [NSString stringWithFormat:@"%d", [stats.offrebound intValue]];
    _defrbLabel.text = [NSString stringWithFormat:@"%d", [stats.defrebound intValue]];
    _assistsLabel.text = [NSString stringWithFormat:@"%d", [stats.assists intValue]];
    _turnoversLabel.text = [stats.turnovers stringValue];
}

- (IBAction)foulButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Foul" message:@"" delegate:self cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add Foul", @"Remove Foul", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)stealButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Steal" message:@"" delegate:self cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add Steal", @"Remove Steal", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)assistButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Assist" message:@"" delegate:self cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add Assist", @"Remove Assist", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)offReboundButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offensive Rebound" message:@"" delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add Offensive Rebound", @"Remove Offensive Rebound", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)defReboundButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Defensive Rebound" message:@"" delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add Defensive Rebound", @"Remove Defensive Rebound", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)blocksButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Blocks" message:@"" delegate:self cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add Block", @"Remove Block", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)turnoverButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Turnover" message:@"" delegate:self cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add Turnover", @"Remove Turnover", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Add Foul"]) {
        stats.fouls = [NSNumber numberWithInt:[stats.fouls intValue] + 1];
        _foulLabel.text = [stats.fouls stringValue];
    } else if (([title isEqualToString:@"Remove Foul"]) && ([stats.fouls intValue] > 0)) {
        stats.fouls = [NSNumber numberWithInt:[stats.fouls intValue] - 1];
        _foulLabel.text = [stats.fouls stringValue];
    } else if ([title isEqualToString:@"Add Steal"]) {
        stats.steals = [NSNumber numberWithInt:[stats.steals intValue] + 1];
        _stealLabel.text = [stats.steals stringValue];
    } else if (([title isEqualToString:@"Remove Steal"]) && ([stats.steals intValue] > 0)) {
        stats.steals = [NSNumber numberWithInt:[stats.steals intValue] - 1];
        _stealLabel.text = [stats.steals stringValue];
    } else if ([title isEqualToString:@"Add Block"]) {
        stats.blocks = [NSNumber numberWithInt:[stats.blocks intValue] + 1];
        _blockLabel.text = [stats.blocks stringValue];
    } else if (([title isEqualToString:@"Remove Block"]) && ([stats.blocks intValue] > 0)) {
        stats.blocks = [NSNumber numberWithInt:[stats.blocks intValue] - 1];
        _blockLabel.text = [stats.blocks stringValue];
    } else if ([title isEqualToString:@"Add Offensive Rebound"] ) {
        stats.offrebound = [NSNumber numberWithInt:[stats.offrebound intValue] + 1];
        _offrbLabel.text = [stats.offrebound stringValue];
    } else if (([title isEqualToString:@"Remove Offensive Rebound"]) && ([stats.offrebound intValue] > 0)) {
        stats.offrebound = [NSNumber numberWithInt:[stats.offrebound intValue] - 1];
        _offrbLabel.text = [stats.offrebound stringValue];
    } else if ([title isEqualToString:@"Add Defensive Rebound"] ) {
        stats.defrebound = [NSNumber numberWithInt:[stats.defrebound intValue] + 1];
        _defrbLabel.text = [stats.defrebound stringValue];
    } else if (([title isEqualToString:@"Remove Defensive Rebound"]) && ([stats.defrebound intValue] > 0)) {
        stats.defrebound = [NSNumber numberWithInt:[stats.defrebound intValue] - 1];
        _defrbLabel.text = [stats.defrebound stringValue];
    } else if ([title isEqualToString:@"Add Assist"]) {
        stats.assists = [NSNumber numberWithInt:[stats.assists intValue] + 1];
        _assistsLabel.text = [stats.assists stringValue];
    } else if (([title isEqualToString:@"Remove Assist"]) && ([stats.assists intValue] > 0)) {
        stats.assists = [NSNumber numberWithInt:[stats.assists intValue] -1 ];
        _assistsLabel.text = [stats.assists stringValue];
    }  else if ([title isEqualToString:@"Add Turnover"]) {
        stats.turnovers = [NSNumber numberWithInt:[stats.turnovers intValue] + 1];
        _turnoversLabel.text = [stats.assists stringValue];
    } else if (([title isEqualToString:@"Remove Turnover"]) && ([stats.turnovers intValue] > 0)) {
        stats.turnovers = [NSNumber numberWithInt:[stats.turnovers intValue] -1 ];
        _turnoversLabel.text = [stats.turnovers stringValue];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (!_submitButton.touchInside) {
        stats = originalStats;
    }
}

@end
