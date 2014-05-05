//
//  EazeBasketballScoringStatsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/5/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazeBasketballScoringStatsViewController.h"
#import "EazesportzAppDelegate.h"
#import "BasketballStats.h"
#import "EazeBballPlayerStatsViewController.h"
#import "EazeBasketballOtherStatsViewController.h"

@interface EazeBasketballScoringStatsViewController ()

@end

@implementation EazeBasketballScoringStatsViewController {
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
    
    [_playerImageView setClipsToBounds:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = player.numberLogname;
    addstats = YES;
    
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"])
        _playerImageView.image = [currentSettings getRosterThumbImage:player];
    else
        _playerImageView.image = [currentSettings getRosterMediumImage:player];
    
    self.title = player.numberLogname;
    stats = [player findBasketballGameStatEntries:game.id];
    [self populateStatLabels];
}

- (void)populateStatLabels {
    _fieldGoalAttemptLabel.text = [stats.twoattempt stringValue];
    _fieldGoalMadeLabel.text = [stats.twomade stringValue];
    
    if ([stats.twomade intValue] > 0)
        _fieldGoalPercentageLabel.text = [NSString stringWithFormat:@"%.02f", [stats.twomade floatValue] / [stats.twoattempt floatValue]];
    else
        _fieldGoalPercentageLabel.text = @"0.0";
    
    _threePointFGALabel.text = [stats.threeattempt stringValue];
    _threePointFGMLabel.text = [stats.threemade stringValue];
    
    if ([stats.threemade intValue] > 0)
        _threePointFGPLabel.text = [NSString stringWithFormat:@"%.02f", [stats.threemade floatValue] / [stats.threeattempt floatValue]];
    else
        _threePointFGPLabel.text = @"0.0";
    
    _FTALabel.text = [stats.ftattempt stringValue];
    _FTMMadeLabel.text = [stats.ftmade stringValue];
    
    if ([stats.ftmade intValue] > 0)
        _FTPLabel.text = [NSString stringWithFormat:@"%.02f", [stats.ftmade floatValue] / [stats.ftattempt floatValue]];
    else
        _FTPLabel.text = @"0.0";
    
    _totalPointsLabel.text = [NSString stringWithFormat:@"%d", ([stats.threemade intValue] * 3) + ([stats.twomade intValue] * 2) + [stats.ftmade intValue]];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TotalStatsSegue"]) {
        EazeBballPlayerStatsViewController *destController = segue.destinationViewController;
        destController.player = player;
    } else if ([segue.identifier isEqualToString:@"OtherBasketballStatsSegue"]) {
        EazeBasketballOtherStatsViewController *destController = segue.destinationViewController;
        destController.player = player;
        destController.game = game;
    }
}


- (IBAction)saveBarButtonClicked:(id)sender {
    [stats saveScoringStats];
    [player updateBasketballGameStats:stats];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Stats updated!" delegate:nil cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)fgaButtonClicked:(id)sender {
    if (addstats) {
        stats.twoattempt = [NSNumber numberWithInt:[stats.twoattempt intValue] + 1];
    } else if ([stats.twoattempt intValue] > 0) {
        stats.twoattempt = [NSNumber numberWithInt:[stats.twoattempt intValue] + 1];
    }
    
    [self populateStatLabels];
}

- (IBAction)fgmButtonClicked:(id)sender {
    if (addstats) {
        stats.twomade = [NSNumber numberWithInt:[stats.twomade intValue] + 1];
        stats.twoattempt = [NSNumber numberWithInt:[stats.twoattempt intValue] + 1];
    } else if ([stats.twomade intValue] > 0) {
        stats.twomade = [NSNumber numberWithInt:[stats.twomade intValue] - 1];
        stats.twoattempt = [NSNumber numberWithInt:[stats.twoattempt intValue] - 1];
    }
    
    [self populateStatLabels];
}

- (IBAction)threefgaButtonClicked:(id)sender {
    if (addstats) {
        stats.threeattempt = [NSNumber numberWithInt:[stats.threeattempt intValue] + 1];
    } else if ([stats.threeattempt intValue] > 0) {
        stats.threeattempt = [NSNumber numberWithInt:[stats.threeattempt intValue] - 1];
    }
    
    [self populateStatLabels];
}

- (IBAction)threefgmButtonClicked:(id)sender {
    if (addstats) {
        stats.threemade = [NSNumber numberWithInt:[stats.threemade intValue] + 1];
        stats.threeattempt = [NSNumber numberWithInt:[stats.threeattempt intValue] + 1];
    } else if ([stats.threemade intValue] > 0) {
        stats.threemade = [NSNumber numberWithInt:[stats.threemade intValue] - 1];
        stats.threeattempt = [NSNumber numberWithInt:[stats.threeattempt intValue] - 1];
    }
    
    [self populateStatLabels];
}

- (IBAction)ftaButtonClicked:(id)sender {
    if (addstats) {
        stats.ftattempt = [NSNumber numberWithInt:[stats.ftattempt intValue] + 1];
    } else if ([stats.ftattempt intValue] > 0) {
        stats.ftattempt = [NSNumber numberWithInt:[stats.ftattempt intValue] - 1];
    }
    
    [self populateStatLabels];
}

- (IBAction)ftmButtonClicked:(id)sender {
    if (addstats) {
        stats.ftmade = [NSNumber numberWithInt:[stats.ftmade intValue] + 1];
        stats.ftattempt = [NSNumber numberWithInt:[stats.ftattempt intValue] + 1];
    } else if ([stats.ftmade intValue] > 0) {
        stats.ftmade = [NSNumber numberWithInt:[stats.ftmade intValue] - 1];
        stats.ftattempt = [NSNumber numberWithInt:[stats.ftattempt intValue] - 1];
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

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
