//
//  EazesportzSoccerPlayerStatsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/11/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzSoccerPlayerStatsViewController.h"

@interface EazesportzSoccerPlayerStatsViewController ()

@end

@implementation EazesportzSoccerPlayerStatsViewController

@synthesize game;
@synthesize player;
@synthesize visitor;

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
    
    [_periodSegmentedControl setSelectedSegmentIndex:[game.period intValue] - 1];
    
    [self getPlayerStats];
}

- (void)getPlayerStats {
    NSNumber *period = [NSNumber numberWithInteger:_periodSegmentedControl.selectedSegmentIndex - 1];
    
    SoccerPlayerStat *stats = [[player getSoccerGameStat:game.soccer_game.soccer_game_id] findPlayerStat:period];
    _shotsTextField.text = [stats.shots stringValue];
    _cornerkickTextField.text = [stats.cornerkicks stringValue];
    _stealsTextField.text = [stats.steals stringValue];
    _foulsTextField.text = [stats.fouls stringValue];
}

- (IBAction)periodSegmentedControlClicked:(id)sender {
    [self getPlayerStats];
}

- (IBAction)submitButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statSaved:) name:@"SoccerPlayerStatNotification" object:nil];
    [[player getSoccerGameStat:game.soccer_game.soccer_game_id] save:game.id StatType:@"playerstat"
                                                              Period:[NSNumber numberWithInteger:_periodSegmentedControl.selectedSegmentIndex - 1]];
}

- (void)statSaved:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Stat Saved" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error saving stats" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
