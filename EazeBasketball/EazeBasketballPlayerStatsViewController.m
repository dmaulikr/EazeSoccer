//
//  PlayerStatsViewController.m
//  Eazebasketball
//
//  Created by Gil on 10/2/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazeBasketballPlayerStatsViewController.h"
#import "BasketballStats.h"

@interface EazeBasketballPlayerStatsViewController ()

@end

@implementation EazeBasketballPlayerStatsViewController

@synthesize game;
@synthesize player;

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
    
    _playerImageView.image = [player getImage:@"thumb"];
    _playerNameLabel.text = player.full_name;
    _poistionLabel.text = player.position;
    
    BasketballStats *stats;
    
    if ((player) && (game)) {
        stats = [player findBasketballGameStatEntries:game.id];
        self.title = [NSString stringWithFormat:@"%@%@", @"vs ", game.opponent_mascot];
    } else {
        stats = [player basketballSeasonTotals];
        self.title = @"Season Totals";
    }

    if (stats) {
        _FGALabel.text = [stats.twoattempt stringValue];
        _fgmLabel.text = [stats.twomade stringValue];
        
         if ([stats.twomade intValue] > 0)
             _fgpLabel.text = [NSString stringWithFormat:@"%.02f", (float)[stats.twomade intValue] / (float)[stats.twoattempt intValue]];
         else
             _fgpLabel.text = @"0.00";
        
        _threefgaLabel.text = [stats.threeattempt stringValue];
        _threefgmLabel.text = [stats.threemade stringValue];
        
        if ([stats.threemade intValue] > 0)
            _threefgpLabel.text = [NSString stringWithFormat:@"%.02f", (float)[stats.threemade intValue] / (float)[stats.threeattempt intValue]];
        else
            _threefgpLabel.text = @"0.00";
        
        _ftaLabel.text = [stats.ftattempt stringValue];
        _ftmLabel.text = [stats.ftmade stringValue];

        if ([stats.ftmade intValue] > 0)
            _ftpLabel.text = [NSString stringWithFormat:@"%.02f", (float)[stats.ftmade intValue] / (float)[stats.ftattempt intValue]];
        else
            _ftpLabel.text = @"0.00";
        
        _totalLabel.text = [NSString stringWithFormat:@"%D",([stats.twomade intValue] * 2) + ([stats.threemade intValue] * 3) +
                                 [stats.ftmade intValue]];
        _assistsLabel.text = [stats.assists stringValue];
        _blocksLabel.text = [stats.blocks stringValue];
        _stealLabel.text = [stats.steals stringValue];
        _offrebLabel.text = [stats.offrebound stringValue];
        _defrebLabel.text = [stats.defrebound stringValue];
        _foulsLabel.text = [stats.fouls stringValue];
    } else {
        _FGALabel.text = @"0";
        _fgmLabel.text = @"0";
        _fgpLabel.text = @"0.0";
        _threefgaLabel.text = @"0";
        _threefgmLabel.text = @"0";
        _threefgpLabel.text = @"0.0";
        _ftaLabel.text = @"0";
        _ftmLabel.text = @"0";
        _ftpLabel.text = @"0.0";
        _foulsLabel.text = @"0";
        _stealLabel.text = @"0";
        _blocksLabel.text = @"0";
        _offrebLabel.text = @"0";
        _defrebLabel.text = @"0";
        _assistsLabel.text = @"0";
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    _bannerView.hidden = NO;
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    _bannerView.hidden = YES;
}

- (IBAction)totalsButtonClicked:(id)sender {
    game = nil;
    [self viewWillAppear:YES];
}

@end
