//
//  EazesportzPunterStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 12/1/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzPunterStatsViewController.h"
#import "FootballPunterStats.h"
#import "EazesportzFootballPunterTotalsViewController.h"
#import "EazesportzAppDelegate.h"

@interface EazesportzPunterStatsViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzPunterStatsViewController {
    FootballPunterStats *stat, *originalstat;
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
    self.title = @"Punter Statistics";
    
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
    
    stat = [player findFootballPunterStat:game.id];
    if (stat.football_punter_id.length > 0)
        originalstat = [stat copy];
    else {
        originalstat = nil;
    }
    
    _playerImage.image = [currentSettings getRosterTinyImage:player];
    _playerNumberLabel.text = [player.number stringValue];
    _playerNameLabel.text = player.logname;
    
    _yardsLabel.text = [stat.punts_yards stringValue];
    _puntsLabel.text = [stat.punts stringValue];
    _longLabel.text = [stat.punts_long stringValue];
    _blockedLabel.text = [stat.punts_blocked stringValue];
}

- (IBAction)puntButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Punt"  message:@"Update Punter Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Punt", @"Delete Punt", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)blockedButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Punt Blocked"  message:@"Update Punt Blocked Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Punt Blocked", @"Delete Punt Blocked", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)submitButtonClicked:(id)sender {
    if (_yardsTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"No yards entry for punt length" delegate:self
                                              cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
    [player updateFootballPunterGameStats:stat];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonClicked:(id)sender {
    if (originalstat != nil)
        [player updateFootballPunterGameStats:originalstat];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Add Punt"]) {
        stat.punts = [NSNumber numberWithInt:[stat.punts intValue] + 1];
        _puntsLabel.text = [stat.punts stringValue];
    } else if (([title isEqualToString:@"Delete Punt"]) && ([stat.punts intValue] > 0)) {
        stat.punts = [NSNumber numberWithInt:[stat.punts intValue] - 1];
        _puntsLabel.text = [stat.punts stringValue];
    } else if ([title isEqualToString:@"Add Punt Blocked"]) {
        stat.punts_blocked = [NSNumber numberWithInt:[stat.punts_blocked intValue] + 1];
        _blockedLabel.text = [stat.punts_blocked stringValue];
    } else if (([title isEqualToString:@"Delete Punt Blocked"]) && ([stat.punts_blocked intValue] > 0)) {
        stat.punts_blocked = [NSNumber numberWithInt:[stat.punts_blocked intValue] - 1];
        _blockedLabel.text = [stat.punts_blocked stringValue];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _yardsTextField) {
        _yardsLabel.text = _yardsTextField.text;
        stat.punts_yards = [NSNumber numberWithInt:[stat.punts_yards intValue] + [_yardsTextField.text intValue]];
        
        if ([stat.punts_long intValue] < [_yardsTextField.text intValue])
            stat.punts_long = [NSNumber numberWithInt:[_yardsTextField.text intValue]];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _yardsTextField) {
        NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        if (myStringMatchesRegEx) {
            
            if (textField == _yardsTextField) {
                return (newLength > 3) ? NO : YES;
            } else
                return NO;
        } else
            return  NO;
    } else
        return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TotalsPunterSegue"]) {
        EazesportzFootballPunterTotalsViewController *destController = segue.destinationViewController;
        destController.player = player;
        destController.game = game;
    }
}

@end
