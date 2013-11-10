//
//  ShotChartViewController.m
//  Basketball Console
//
//  Created by Gilbert Zaldivar on 9/17/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "LiveBasketballStatsViewController.h"
#import "EazesportzAppDelegate.h"
#import "BasketballStats.h"

#import <QuartzCore/QuartzCore.h>

@interface LiveBasketballStatsViewController ()

@end

@implementation LiveBasketballStatsViewController {
    int twofgm, twofga, threefgm, threefga, ftmade, fta, fouls, assists;
    int steals, blocks, offrebound, defrebound;
    float twofgpct, threefgpct, ftpct;
    
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
    
    _totalPointsLabel.text = [NSString stringWithFormat:@"%d", ([stats.twomade intValue] * 2) + ([stats.threemade intValue] * 3) + [stats.ftmade intValue]];

    if ([stats.ftmade intValue] > 0)
        _FTPLabel.text = [NSString stringWithFormat:@"%.02f", (float)[stats.ftmade intValue] / (float)[stats.ftattempt intValue]];
    else
        _FTPLabel.text = @"0.00";

    _FTMMadeLabel.text = [NSString stringWithFormat:@"%d", [stats.ftmade intValue]];
    _FTALabel.text = [NSString stringWithFormat:@"%d", [stats.ftattempt intValue]];
    
    if ([stats.threemade intValue] > 0)
        _threePointFGPLabel.text = [NSString stringWithFormat:@"%.02f", (float)[stats.threemade intValue] / (float)[stats.threeattempt intValue]];
    else
        _threePointFGPLabel.text = @"0.00";
    
    _threePointFGMLabel.text = [NSString stringWithFormat:@"%d", [stats.threemade intValue]];
    _threePointFGALabel.text = [NSString stringWithFormat:@"%d", [stats.threeattempt intValue]];
    _fieldGoalAttemptLabel.text = [NSString stringWithFormat:@"%d", [stats.twoattempt intValue]];
    _fieldGoalMadeLabel.text = [NSString stringWithFormat:@"%d", [stats.twomade intValue]];
    
    if ([stats.twomade intValue] > 0)
        _fieldGoalPercentageLabel.text = [NSString stringWithFormat:@"%.02f", (float)[stats.twomade intValue] / (float)[stats.twoattempt intValue]];
    else
        _fieldGoalPercentageLabel.text = @"0.00";
    
    _foulLabel.text = [NSString stringWithFormat:@"%d", [stats.fouls intValue]];
    _blockLabel.text = [NSString stringWithFormat:@"%d", [stats.blocks intValue]];
    _stealLabel.text = [NSString stringWithFormat:@"%d", [stats.steals intValue]];
    _offrbLabel.text = [NSString stringWithFormat:@"%d", [stats.offrebound intValue]];
    _defrbLabel.text = [NSString stringWithFormat:@"%d", [stats.defrebound intValue]];
    _assistsLabel.text = [NSString stringWithFormat:@"%d", [stats.assists intValue]];
    
    twofga = [stats.twoattempt intValue];
    twofgm = [stats.twomade intValue];
    twofgpct = (float)[stats.twomade intValue] / (float)[stats.twoattempt intValue];
    threefga = [stats.threeattempt intValue];
    threefgm = [stats.threemade intValue];
    threefgpct = (float)[stats.threemade intValue] / (float)[stats.threeattempt intValue];
    fta = [stats.ftattempt intValue];
    ftmade = [stats.ftmade intValue];
    ftpct = (float)[stats.ftmade intValue] / (float)[stats.ftattempt intValue];
    fouls = [stats.fouls intValue];
    assists = [stats.assists intValue];
    steals = [stats.steals intValue];
    blocks = [stats.blocks intValue];
    offrebound = [stats.offrebound intValue];
    defrebound = [stats.defrebound intValue];
}

- (IBAction)threePointButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Three Point Attempt" message:@"" delegate:self cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"3FG Made", @"3FG Missed", @"-3FGM", @"-3FGA", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)twoPointButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Two Point Attempt" message:@"" delegate:self cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"FG Made", @"FG Missed", @"-FGM", @"-FGA", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)freeThrowButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Free Throw Attempt" message:@"" delegate:self cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"FT Made", @"FT Missed", @"-FTM", @"-FTA", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
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

- (IBAction)savestatsButtonClicked:(id)sender {
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"FG Made"]) {
        twofgm++;
        twofga++;        
        twofgpct = (float)twofgm / (float)twofga;
        
        _fieldGoalMadeLabel.text = [NSString stringWithFormat: @"%d", twofgm];
        _fieldGoalAttemptLabel.text = [NSString stringWithFormat: @"%d", twofga];
        _fieldGoalPercentageLabel.text = [NSString stringWithFormat:@"%.02f", twofgpct];
        stats.twomade = [NSNumber numberWithInt:twofgm];
        stats.twoattempt = [NSNumber numberWithInt:twofga];
    } else if ([title isEqualToString:@"FG Missed"]) {
        twofga++;
        
        if (twofgm > 0)
            twofgpct = (float)twofgm / (float)twofga;
        else
            twofgpct = 0.0;
        
        _fieldGoalAttemptLabel.text = [NSString stringWithFormat: @"%d", twofga];
        _fieldGoalPercentageLabel.text = [NSString stringWithFormat:@"%.02f", twofgpct];
        stats.twoattempt = [NSNumber numberWithInt:twofga];
    } else if (([title isEqualToString:@"-FGM"]) && (twofgm > 0)) {
        twofgm--;
        twofga--;
        
        if (twofga > 0)
            twofgpct = (float)twofgm / (float)twofga;
        else
            twofgpct = 0.0;
        
        _fieldGoalMadeLabel.text = [NSString stringWithFormat: @"%d", twofgm];
        _fieldGoalAttemptLabel.text = [NSString stringWithFormat: @"%d", twofga];
        _fieldGoalPercentageLabel.text = [NSString stringWithFormat:@"%.02f", twofgpct];
        stats.twomade = [NSNumber numberWithInt:twofgm];
        stats.twoattempt = [NSNumber numberWithInt:twofga];
    } else if (([title isEqualToString:@"-FGA"]) && (twofga > 0)) {
        if (twofga == twofgm) {
            twofgm--;
            _fieldGoalMadeLabel.text = [NSString stringWithFormat: @"%d", twofgm];
        }
        
        twofga--;
        
        if (twofga > 0)
            twofgpct = (float)twofgm / (float)twofga;
        else
            twofgpct = 0.0;
        
        _fieldGoalAttemptLabel.text = [NSString stringWithFormat: @"%d", twofga];
        _fieldGoalPercentageLabel.text = [NSString stringWithFormat:@"%.02f", twofgpct];
        stats.twoattempt = [NSNumber numberWithInt:twofga];
    } else if ([title isEqualToString:@"3FG Made"]) {
        threefga++;
        threefgm++;
        threefgpct = (float)threefgm / (float)threefga;
        
        _threePointFGALabel.text = [NSString stringWithFormat:@"%d", threefga];
        _threePointFGMLabel.text = [NSString stringWithFormat:@"%d", threefgm];
        _threePointFGPLabel.text = [NSString stringWithFormat:@"%.02f", threefgpct];
        stats.threemade = [NSNumber numberWithInt:threefgm];
        stats.threeattempt = [NSNumber numberWithInt:threefga];
    } else if ([title isEqualToString:@"3FG Missed"]) {
        threefga++;
        
        if (threefgm > 0)
            threefgpct = (float)threefgm / (float)threefga;
        else
            threefgpct = 0.0;

        _threePointFGALabel.text = [NSString stringWithFormat:@"%d", threefga];
        _threePointFGPLabel.text = [NSString stringWithFormat:@"%.02f", threefgpct];
         stats.threeattempt = [NSNumber numberWithInt:threefga];
    } else if ([title isEqualToString:@"-3FGM"]) {
        threefga--;
        threefgm--;
        
        if (threefga > 0)
            threefgpct = (float)threefgm / (float)threefga;
        else
            threefgpct = 0.0;
        
        _threePointFGMLabel.text = [NSString stringWithFormat:@"%d", threefgm];
        _threePointFGALabel.text = [NSString stringWithFormat:@"%d", threefga];
        _threePointFGPLabel.text = [NSString stringWithFormat:@"%.02f", threefgpct];
        stats.threemade = [NSNumber numberWithInt:threefgm];
        stats.threeattempt = [NSNumber numberWithInt:threefga];
    } else if (([title isEqualToString:@"-3FGA"]) && (threefga > 0)) {
        if (threefga == threefgm) {
            threefgm--;
            _threePointFGMLabel.text = [NSString stringWithFormat: @"%d", threefgm];
        }
        
        threefga--;
        
        if (threefga > 0)
            threefgpct = (float)threefgm / (float)threefga;
        else
            threefgpct = 0.0;
        
        _threePointFGALabel.text = [NSString stringWithFormat:@"%d", threefga];
        _threePointFGPLabel.text = [NSString stringWithFormat:@"%.02f", threefgpct];
        stats.threeattempt = [NSNumber numberWithInt:threefga];
    } else if ([title isEqualToString:@"FT Made"]) {
        ftmade++;
        fta++;
        ftpct = (float)ftmade / (float)fta;
        
        _FTMMadeLabel.text = [NSString stringWithFormat:@"%d", ftmade];
        _FTALabel.text = [NSString stringWithFormat:@"%d", fta];
        _FTPLabel.text = [NSString stringWithFormat:@"%.02f", ftpct];
        stats.ftmade = [NSNumber numberWithInt:ftmade];
        stats.ftattempt = [NSNumber numberWithInt:fta];
    } else if ([title isEqualToString:@"FT Missed"]) {
        fta++;
        
        if (ftmade > 0)
            ftpct = (float)ftmade / (float)fta;
        else
            ftpct = 0.0;
        
        _FTALabel.text = [NSString stringWithFormat:@"%d", fta];
        _FTPLabel.text = [NSString stringWithFormat:@"%.02f", ftpct];
        stats.ftattempt = [NSNumber numberWithInt:fta];
    } else if (([title isEqualToString:@"-FTM"]) && (fta > 0)) {
        fta--;
        ftmade--;
        
        if (fta > 0)
            ftpct = (float)ftmade / (float)fta;
        else
            ftpct = 0.0;
        
        _FTMMadeLabel.text = [NSString stringWithFormat:@"%d", ftmade];
        _FTALabel.text = [NSString stringWithFormat:@"%d", fta];
        _FTPLabel.text = [NSString stringWithFormat:@"%.02f", ftpct];
        stats.ftmade = [NSNumber numberWithInt:ftmade];
        stats.ftattempt = [NSNumber numberWithInt:fta];
    } else if ([title isEqualToString:@"-FTA"]) {
        if (fta == ftmade) {
            ftmade--;
            _FTMMadeLabel.text = [NSString stringWithFormat:@"%d", ftmade];
        }
        
        fta--;
        
        if (fta > 0)
            ftpct = (float)ftmade / (float)fta;
        else
            ftpct = 0.0;
        
        _FTALabel.text = [NSString stringWithFormat:@"%d", fta];
        _FTPLabel.text = [NSString stringWithFormat:@"%0.2f", ftpct];
        stats.ftattempt = [NSNumber numberWithInt:fta];
    } else if ([title isEqualToString:@"Add Foul"]) {
        fouls++;
        _foulLabel.text = [NSString stringWithFormat:@"%d", fouls];
        stats.fouls = [NSNumber numberWithInt:fouls];
    } else if (([title isEqualToString:@"Remove Foul"]) && (fouls > 0)) {
        fouls--;
        _foulLabel.text = [NSString stringWithFormat:@"%d", fouls];
        stats.fouls = [NSNumber numberWithInt:fouls];
    } else if ([title isEqualToString:@"Add Steal"]) {
        steals++;
        _stealLabel.text = [NSString stringWithFormat:@"%d", steals];
        stats.steals = [NSNumber numberWithInt:steals];
    } else if (([title isEqualToString:@"Remove Steal"]) && (steals > 0)) {
        steals--;
        _stealLabel.text = [NSString stringWithFormat:@"%d", steals];
        stats.steals = [NSNumber numberWithInt:steals];
    } else if ([title isEqualToString:@"Add Block"]) {
        blocks++;
        _blockLabel.text = [NSString stringWithFormat:@"%d", blocks];
        stats.blocks = [NSNumber numberWithInt:blocks];
    } else if (([title isEqualToString:@"Remove Block"]) && (blocks > 0)) {
        blocks--;
        _blockLabel.text = [NSString stringWithFormat:@"%d", blocks];
        stats.blocks = [NSNumber numberWithInt:blocks];
    } else if ([title isEqualToString:@"Add Offensive Rebound"] ) {
        offrebound++;
        _offrbLabel.text = [NSString stringWithFormat:@"%d", offrebound];
        stats.offrebound = [NSNumber numberWithInt:offrebound];
    } else if (([title isEqualToString:@"Remove Offensive Rebound"]) && (offrebound > 0)) {
        offrebound--;
        _offrbLabel.text = [NSString stringWithFormat:@"%d", offrebound];
        stats.offrebound = [NSNumber numberWithInt:offrebound];
    } else if ([title isEqualToString:@"Add Defensive Rebound"] ) {
        defrebound++;
        _defrbLabel.text = [NSString stringWithFormat:@"%d", defrebound];
        stats.defrebound = [NSNumber numberWithInt:defrebound];
    } else if (([title isEqualToString:@"Remove Defensive Rebound"]) && (defrebound > 0)) {
        defrebound--;
        _defrbLabel.text = [NSString stringWithFormat:@"%d", defrebound];
        stats.defrebound = [NSNumber numberWithInt:defrebound];
    } else if ([title isEqualToString:@"Add Assist"]) {
        assists++;
        _assistsLabel.text = [NSString stringWithFormat:@"%d", assists];
        stats.assists = [NSNumber numberWithInt:assists];
    } else if (([title isEqualToString:@"Remove Assist"]) && (assists > 0)) {
        assists--;
        _assistsLabel.text = [NSString stringWithFormat:@"%d", assists];
        stats.assists = [NSNumber numberWithInt:assists];
    }
    
    _totalPointsLabel.text = [NSString stringWithFormat:@"%d", (twofgm *2) + (threefgm *3) + ftmade];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (!_savestatsButton.touchInside) {
        stats = originalStats;
    }
}

@end
