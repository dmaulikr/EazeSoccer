//
//  EazesportzWaterPoloGameSummaryViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/19/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzWaterPoloGameSummaryViewController.h"
#import "EazesportzAppDelegate.h"

@interface EazesportzWaterPoloGameSummaryViewController ()

@end

@implementation EazesportzWaterPoloGameSummaryViewController

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
    
    _homeImageView.image = [currentSettings.team getImage:@"tiny"];
    _visitorImageView.image = [game opponentImage:@"tiny"];
    [_homeButton setTitle:currentSettings.team.mascot forState:UIControlStateNormal];
    [_visitorButton setTitle:game.opponent_mascot forState:UIControlStateNormal];
    _homeScoreTextField.text = [game.water_polo_game.waterpolo_home_score stringValue];
    _visitorScoreTextField.text = [game.water_polo_game.waterpolo_visitor_score stringValue];
    _periodTextField.text = [game.period stringValue];
    _homeTimeOutsTextField.text = [game.water_polo_game.home_time_outs_left stringValue];
    _visitorTimeOutsTextField.text = [game.water_polo_game.visitor_time_outs_left stringValue];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)homeButtonClicked:(id)sender {
}

- (IBAction)visitorButtonClicked:(id)sender {
}

- (IBAction)saveBarButtonClicked:(id)sender {
}

- (IBAction)refreshBarButtonClicked:(id)sender {
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
