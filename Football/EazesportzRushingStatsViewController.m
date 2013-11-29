//
//  EazesportzRushingStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 11/26/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzRushingStatsViewController.h"
#import "EazesportzAppDelegate.h"

@interface EazesportzRushingStatsViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzRushingStatsViewController {
    FootballRushingStat *originalStat, *stat;
    
    BOOL touchdown, twopointconv;
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
    self.title = @"Rushing Statistics";
    
    _rushyardsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _quarterTextField.keyboardType = UIKeyboardTypeNumberPad;
    _minutesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _secondsTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _quarterTextField.hidden = YES;
    _quarterLabel.hidden = YES;
    _timeofscoreLabel.hidden = YES;
    _minutesTextField.hidden = YES;
    _secondsTextField.hidden = YES;
    _colonLabel.hidden = YES;
    _rushyardsTextField.hidden = YES;
    
    _playerImageView.image = [player getImage:@"tiny"];
    _playerNameLabel.text = player.logname;
    _playerNumberLabel.text = [player.number stringValue];
    
    stat = [player findFootballRushingStat:game.id];
    
    if (stat.football_rushing_id.length > 0)
        originalStat = [stat copy];
    else {
        originalStat = nil;
        stat.athlete_id = player.athleteid;
        stat.gameschedule_id = game.id;
    }
    _attemptLabel.text = [stat.attempts stringValue];
    _yardsLabel.text = [stat.yards stringValue];
    _averageLabel.text = [NSString stringWithFormat:@"%.02f", [stat.average floatValue]];
    _tdLabel.text = [stat.td stringValue];
    _fumbleLabel.text = [stat.fumbles stringValue];
    _fumbleLostLabel.text = [stat.fumbles_lost stringValue];
    _twopointLabel.text = [stat.twopointconv stringValue];
    _quarterTextField.text = [game.period stringValue];
    _fdLabel.text = [stat.firstdowns stringValue];
    _longestLabel.text = [stat.longest stringValue];
//    _theview.hidden = NO;
    
    NSLog(@"X origin %f Y origin %f width%f height%f", _theview.frame.origin.x, _theview.frame.origin.y, _theview.frame.size.height, _theview.frame.size.width);
}

- (IBAction)attemptButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rushing Attempt"  message:@"Update Rushing Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Attempt", @"Delete Attempt", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)fumbleButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fumble"  message:@"Update Fumble Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Fumble", @"Delete Fumble", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)fumblelostButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fumble Lost"  message:@"Update Fumbles Lost Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Fumble Lost", @"Delete Fumble Lost", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)tdButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TD"  message:@"Update Touchdown Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add TD", @"Delete TD", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)twopointButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"2PT"  message:@"Update Two Point Conversion Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add 2PT", @"Delete 2PT", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)submitButtonClicked:(id)sender {
    
    if (((touchdown) || (twopointconv)) && ((_minutesTextField.text.length == 0) || (_secondsTextField.text.length == 0))) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Please enter time of score" delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
    
    if (([_minutesTextField.text intValue] > 15) || ([_secondsTextField.text intValue] > 60)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Invalid minutes or seconds entry" delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
    
    if ((touchdown) || (twopointconv))
        [stat saveStats];
    
    stat.yards = [NSNumber numberWithInt:[_rushyardsTextField.text intValue] + [stat.yards intValue]];
    
    if ([_rushyardsTextField.text intValue] > [stat.longest intValue])
        stat.longest = [NSNumber numberWithInt:[_rushyardsTextField.text intValue]];
    
    if ([stat.attempts intValue] > 0)
        stat.average = [NSNumber numberWithFloat:[stat.yards floatValue] / [stat.attempts floatValue]];
    
    [player updateFootballRushingGameStats:stat];
    
    if ((_minutesTextField.text.length > 0) && (_quarterTextField.text.length > 0)) {
        Gamelogs *gamelog = [[Gamelogs alloc] init];
        gamelog.gameschedule_id = game.id;
        gamelog.period = _quarterTextField.text;
        gamelog.time = [NSString stringWithFormat:@"%@%@%@", _minutesTextField.text, @":", _secondsTextField.text];
        gamelog.player = player.athleteid;
        gamelog.yards = [NSNumber numberWithInt:[_rushyardsTextField.text intValue]];
        
        gamelog.logentry = @"yard run";
        
        if (touchdown) {
            gamelog.score = @"TD";
            touchdown = NO;
        } else {
            gamelog.score = @"2P";
            twopointconv = NO;
        }
        
        [game updateGamelog:gamelog];
        [game saveGameschedule];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Add Attempt"]) {
        stat.attempts = [NSNumber numberWithInt:[stat.attempts intValue] + 1];
        _attemptLabel.text = [stat.attempts stringValue];
        _rushyardsTextField.hidden = NO;
    } else if (([title isEqualToString:@"Delete Attempt"]) && ([stat.attempts intValue] > 0)) {
        stat.attempts = [NSNumber numberWithInt:[stat.attempts intValue] - 1];
        _attemptLabel.text = [stat.attempts stringValue];
        _rushyardsTextField.hidden = YES;
        _rushyardsTextField.text = @"";
    } else if ([title isEqualToString:@"Add Fumble"]) {
        stat.fumbles = [NSNumber numberWithInt:[stat.fumbles intValue] + 1];
        _fumbleLabel.text = [stat.fumbles stringValue];
    } else if (([title isEqualToString:@"Delete Fumble"]) && ([stat.fumbles intValue] > 0)) {
        stat.fumbles = [NSNumber numberWithInt:[stat.fumbles intValue] - 1];
        _fumbleLabel.text = [stat.fumbles stringValue];
    } else if ([title isEqualToString:@"Add Fumble Lost"]) {
        stat.fumbles_lost = [NSNumber numberWithInt:[stat.fumbles_lost intValue] + 1];
        _fumbleLostLabel.text = [stat.fumbles stringValue];
    } else if (([title isEqualToString:@"Delete Fumble Lost"]) && ([stat.fumbles intValue] > 0)) {
        stat.fumbles_lost = [NSNumber numberWithInt:[stat.fumbles_lost intValue] - 1];
        _fumbleLostLabel.text = [stat.fumbles stringValue];
    } else if ([title isEqualToString:@"Add TD"]) {
        stat.td = [NSNumber numberWithInt:[stat.td intValue] + 1];
        _tdLabel.text = [stat.td stringValue];
        touchdown = YES;
        twopointconv = NO;
        _minutesTextField.hidden = NO;
        _minutesTextField.enabled = YES;
        _secondsTextField.hidden = NO;
        _secondsTextField.enabled = YES;
        _colonLabel.hidden = NO;
        _quarterTextField.hidden = NO;
        _quarterTextField.enabled = YES;
        _quarterLabel.hidden = NO;
        _timeofscoreLabel.hidden = NO;
    } else if (([title isEqualToString:@"Delete TD"]) && ([stat.td intValue] > 0)) {
        if (touchdown) {
            stat.td = [NSNumber numberWithInt:[stat.td intValue] - 1];
            _tdLabel.text = [stat.td stringValue];
            touchdown = NO;
            _minutesTextField.hidden = YES;
            _minutesTextField.enabled = NO;
            _minutesTextField.text = @"";
            _secondsTextField.hidden = YES;
            _secondsTextField.enabled = NO;
            _secondsTextField.text = @"";
            _colonLabel.hidden = YES;
            _quarterTextField.hidden = YES;
            _quarterTextField.enabled = NO;
            _quarterTextField.text = @"";
            _quarterLabel.hidden = YES;
            _timeofscoreLabel.hidden = YES;
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"No valid TD added. \n If you want to remove a score, delete the game log. The score will be removed automatically." delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else if ([title isEqualToString:@"Add 2PT"]) {
        stat.twopointconv = [NSNumber numberWithInt:[stat.twopointconv intValue] + 1];
        _twopointLabel.text = [stat.twopointconv stringValue];
        twopointconv = YES;
        touchdown = NO;
        _minutesTextField.hidden = NO;
        _minutesTextField.enabled = YES;
        _secondsTextField.hidden = NO;
        _secondsTextField.enabled = YES;
        _colonLabel.hidden = NO;
        _quarterTextField.hidden = NO;
        _quarterTextField.enabled = YES;
        _quarterLabel.hidden = NO;
        _timeofscoreLabel.hidden = NO;
    } else if (([title isEqualToString:@"Delete TD"]) && ([stat.twopointconv intValue] > 0)) {
        if (twopointconv) {
            stat.twopointconv = [NSNumber numberWithInt:[stat.twopointconv intValue] - 1];
            _twopointLabel.text = [stat.twopointconv stringValue];
            twopointconv = NO;
            _minutesTextField.hidden = YES;
            _minutesTextField.enabled = NO;
            _minutesTextField.text = @"";
            _secondsTextField.hidden = YES;
            _secondsTextField.enabled = NO;
            _secondsTextField.text = @"";
            _colonLabel.hidden = YES;
            _quarterTextField.hidden = YES;
            _quarterTextField.enabled = NO;
            _quarterTextField.text = @"";
            _quarterLabel.hidden = YES;
            _timeofscoreLabel.hidden = YES;
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"No valid two point conversion added. \n If you want to remove a score, delete the game log. The score will be removed automatically." delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _rushyardsTextField)
        _yardsLabel.text = _rushyardsTextField.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _rushyardsTextField) {
        NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        if (myStringMatchesRegEx) {
            
            if (textField == _rushyardsTextField) {
                return (newLength > 3) ? NO : YES;
            } else
                return NO;
        } else
            return  NO;
        
    } else if (textField == _quarterTextField) {
        NSString *validRegEx =@"^[1-4.]*$"; //change this regular expression as your requirement
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        if (myStringMatchesRegEx)
            return (newLength > 1) ? NO : YES;
        else
            return NO;
    } else if ((textField == _minutesTextField) || (textField == _secondsTextField)) {
        NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        if (myStringMatchesRegEx)
            return (newLength > 2) ? NO : YES;
        else
            return NO;
    } else
        return YES;
}

- (IBAction)cancelButtonClicked:(id)sender {
    if (originalStat != nil)
        [player updateFootballRushingGameStats:originalStat];
}

@end
