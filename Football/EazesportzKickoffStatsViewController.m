//
//  EazesportzKickoffStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 12/1/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzKickoffStatsViewController.h"
#import "EazesportzFootballKickerTotalsViewController.h"

@interface EazesportzKickoffStatsViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzKickoffStatsViewController {
    FootballKickerStats *stat, *originalstat;
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
    self.view.backgroundColor = [UIColor clearColor];
    self.title = @"Kicker Statistics";
    
    _yardsTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.totalsButton, nil];
    
    self.toolbar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    stat = [player findFootballKickerStat:game.id];
    if (stat.football_kicker_id.length > 0)
        originalstat = [stat copy];
    else {
        originalstat = nil;
    }
    
    _playerImage.image = [player getImage:@"tiny"];
    _playerNumberLabel.text = [player.number stringValue];
    _playerNameLabel.text = player.logname;
    
    [self computeReturnedStats];
    
    _kickoffsLabel.text = [stat.koattempts stringValue];
    _touchbacksLabel.text = [stat.kotouchbacks stringValue];
}

- (IBAction)kickoffButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Kickoff"  message:@"Update Kickoff Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Kickoff", @"Delete Kickoff", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)touchbackButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Touchback"  message:@"Update Touchback Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Touchback", @"Delete Touchback", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)submitButtonClicked:(id)sender {
    [player updateFootballKickerGameStats:stat];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonClicked:(id)sender {
    if (originalstat != nil)
        [player updateFootballKickerGameStats:originalstat];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Add Kickoff"]) {
        stat.koattempts = [NSNumber numberWithInt:[stat.koattempts intValue] + 1];
        _kickoffsLabel.text = [stat.koattempts stringValue];
        [self computeReturnedStats];
    } else if (([title isEqualToString:@"Delete Kickoff"]) && ([stat.koattempts intValue] > 0)) {
        stat.koattempts = [NSNumber numberWithInt:[stat.koattempts intValue] - 1];
        _kickoffsLabel.text = [stat.koattempts stringValue];
        [self computeReturnedStats];
    } else if ([title isEqualToString:@"Add Touchback"]) {
        stat.kotouchbacks = [NSNumber numberWithInt:[stat.kotouchbacks intValue] + 1];
        _touchbacksLabel.text = [stat.kotouchbacks stringValue];
        [self computeReturnedStats];
    } else if (([title isEqualToString:@"Delete Touchback"]) && ([stat.kotouchbacks intValue] > 0)) {
        stat.kotouchbacks = [NSNumber numberWithInt:[stat.kotouchbacks intValue] - 1];
        _touchbacksLabel.text = [stat.kotouchbacks stringValue];
        [self computeReturnedStats];
    }
}

- (void)computeReturnedStats {
    if ([stat.koattempts intValue] > 0)
        _returnedLabel.text = [[NSNumber numberWithInt:[stat.koattempts intValue] - [stat.kotouchbacks intValue]] stringValue];
    else
        _returnedLabel.text = [stat.koattempts stringValue];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TotalsKickerSegue"]) {
        EazesportzFootballKickerTotalsViewController *destController = segue.destinationViewController;
        destController.player = player;
        destController.game = game;
    }
}

@end
