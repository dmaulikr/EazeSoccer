//
//  EazeBasketballOtherStatsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/5/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazeBasketballOtherStatsViewController.h"
#import "EazesportzAppDelegate.h"
#import "BasketballStats.h"
#import "EazeBballPlayerStatsViewController.h"

@interface EazeBasketballOtherStatsViewController ()

@end

@implementation EazeBasketballOtherStatsViewController {
    BasketballStats *stats;
    
    BOOL addstats;
}

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
    
    addstats = YES;
    
    _playerImage.image = [currentSettings getRosterThumbImage:player];
    stats = [player findBasketballGameStatEntries:game.id];
    [self populateStatLabels];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TotalStatsSegue"]) {
        EazeBballPlayerStatsViewController *destController = segue.destinationViewController;
        destController.player = player;
    }
}

- (void)populateStatLabels {
    _personalFoulsLabel.text = [stats.fouls stringValue];
    _offensiveReboundLabel.text = [stats.offrebound stringValue];
    _defensiveReboundLabel.text = [stats.defrebound stringValue];
    _assistLabel.text = [stats.assists stringValue];
    _blocksLabel.text = [stats.blocks stringValue];
    _stealLabel.text = [stats.steals stringValue];
    _turnoversLabel.text = [stats.turnovers stringValue];
}

- (IBAction)foulsButtonClicked:(id)sender {
    if (addstats) {
        stats.fouls = [NSNumber numberWithInt:[stats.fouls intValue] + 1];
    } else if ([stats.fouls intValue] > 0) {
        stats.fouls = [NSNumber numberWithInt:[stats.fouls intValue] - 1];
    }
    
    [self populateStatLabels];
}

- (IBAction)offensiveReboundButtonClicked:(id)sender {
    if (addstats) {
        stats.offrebound = [NSNumber numberWithInt:[stats.offrebound intValue] + 1];
    } else if ([stats.offrebound intValue] > 0) {
        stats.offrebound = [NSNumber numberWithInt:[stats.offrebound intValue] - 1];
    }
    
    [self populateStatLabels];
}

- (IBAction)assistButtonClicked:(id)sender {
    if (addstats) {
        stats.assists = [NSNumber numberWithInt:[stats.assists intValue] + 1];
    } else if ([stats.assists intValue] > 0) {
        stats.assists = [NSNumber numberWithInt:[stats.assists intValue] - 1];
    }
    
    [self populateStatLabels];
}

- (IBAction)defensiveReboundButtonClicked:(id)sender {
    if (addstats) {
        stats.defrebound = [NSNumber numberWithInt:[stats.defrebound intValue] + 1];
    } else if ([stats.defrebound intValue] > 0) {
        stats.defrebound = [NSNumber numberWithInt:[stats.defrebound intValue] - 1];
    }
    
    [self populateStatLabels];
}

- (IBAction)stealsButtonClicked:(id)sender {
    if (addstats) {
        stats.steals = [NSNumber numberWithInt:[stats.steals intValue] + 1];
    } else if ([stats.steals intValue] > 0) {
        stats.steals = [NSNumber numberWithInt:[stats.steals intValue] - 1];
    }
    
    [self populateStatLabels];
}

- (IBAction)blocksButtonClicked:(id)sender {
    if (addstats) {
        stats.blocks = [NSNumber numberWithInt:[stats.blocks intValue] + 1];
    } else if ([stats.blocks intValue] > 0) {
        stats.blocks = [NSNumber numberWithInt:[stats.blocks intValue] - 1];
    }
    
    [self populateStatLabels];
}

- (IBAction)turnoversButtonClicked:(id)sender {
    if (addstats) {
        stats.turnovers = [NSNumber numberWithInt:[stats.turnovers intValue] + 1];
    } else if ([stats.turnovers intValue] > 0) {
        stats.turnovers = [NSNumber numberWithInt:[stats.turnovers intValue] - 1];
    }
    
    [self populateStatLabels];
}

- (IBAction)toggleButtonClicked:(id)sender {
    if (addstats) {
        addstats = NO;
        [_toggleButton setTitle:@"Add" forState:UIControlStateNormal];
    } else {
        addstats = YES;
        [_toggleButton setTitle:@"Subtract" forState:UIControlStateNormal];
    }
}

- (IBAction)saveBarButtonClicked:(id)sender {
    [stats saveOtherStats];
}

@end
