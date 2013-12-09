//
//  EazesportzDefenseStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 11/29/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzDefenseStatsViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzFootballDefenseTotalsViewController.h"

@interface EazesportzDefenseStatsViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzDefenseStatsViewController {
    FootballDefenseStats *originalStat, *stat;
    
    BOOL touchdown, safety, interception;
    UITextField *lastTextField;
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
    self.title = @"Defensive Statistics";
    
    _returnyardsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _minutesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _secondsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _quarterTextField.keyboardType = UIKeyboardTypeNumberPad;
    
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
    
    touchdown = safety = interception = NO;
    
    _playerImageView.image = [player getImage:@"tiny"];
    _playerNumbeLabel.text = [player.number stringValue];
    _playerNameLabel.text = player.logname;
    
    [self toggleTimeQuarterFields:NO];
    
    stat = [player findFootballDefenseStat:game.id];
    
    if (stat.football_defense_id.length > 0)
        originalStat = [stat copy];
    else {
        originalStat = nil;
        stat.athlete_id = player.athleteid;
        stat.gameschedule_id = game.id;
    }
    
    if ([stat.assists intValue] > 0)
        _tacklesLabel.text = [NSString stringWithFormat:@"%01f", ([stat.tackles floatValue] + ([stat.assists floatValue]/2))];
    else
        _tacklesLabel.text = [stat.tackles stringValue];
    
    _assistsLabel.text = [stat.assists stringValue];
    
    if ([stat.sackassist intValue] > 0)
        _sacksLabel.text = [NSString stringWithFormat:@"%.01f", ([stat.sacks floatValue] + ([stat.sackassist floatValue]/2))];
    else
        _sacksLabel.text = [stat.sacks stringValue];
    
    _tdLabel.text = [stat.td stringValue];
    _retYardsLabel.text = [stat.int_yards stringValue];
    _safetylabel.text = [stat.safety stringValue];
    _passdefendedlabel.text = [stat.pass_defended stringValue];
    _fumbleRecoverecLabel.text = [stat.fumbles_recovered stringValue];
    _intLabel.text = [stat.interceptions stringValue];
    _sackassistLabel.text = [stat.sackassist stringValue];
    
    _returnyardsTextField.hidden = YES;
 }

- (IBAction)tackleButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tackles"  message:@"Update Tackle Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Tackle", @"Delete Tackle", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)assistButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Assists"  message:@"Update Tackle Assists Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Assist", @"Delete Assist", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)sackButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sacks"  message:@"Update Sack Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Sack", @"Delete Sack", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)intButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Interception"  message:@"Update Interception Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Interception", @"Delete Interception", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)passdefendedButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Passes Defended"  message:@"Update Passes Defended Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Pass Defended", @"Delete Pass Defended", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)fumblerecoveredButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fumbles Recovered"  message:@"Update Fumbles Recovered Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Fumble Recovered", @"Delete Fumble Recovered", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)tdButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TD"  message:@"Update TD Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add TD", @"Delete TD", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)safetyButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Safety"  message:@"Update Safety Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Safety", @"Delete Safety", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)submitButtonClicked:(id)sender {
    if ((touchdown) && (safety)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Cannot have both touchdown and safety" delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
    
    if (((touchdown) || (safety)) && ((_minutesTextField.text.length == 0) || (_secondsTextField.text.length == 0))) {
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
    
    if ((touchdown) || (safety))
        [stat saveStats];
    
    stat.int_yards = [NSNumber numberWithInt:[_returnyardsTextField.text intValue] + [stat.int_yards intValue]];
    
    if ([_returnyardsTextField.text intValue] > [stat.int_long intValue])
        stat.int_long = [NSNumber numberWithInt:[_returnyardsTextField.text intValue]];
        
    [player updateFootballDefenseGameStats:stat];
    
    if ((_minutesTextField.text.length > 0) && (_quarterTextField.text.length > 0)) {
        Gamelogs *gamelog = [[Gamelogs alloc] init];
        gamelog.football_defense_id = stat.football_defense_id;
        gamelog.gameschedule_id = game.id;
        
        switch ([_quarterTextField.text intValue]) {
            case 1:
                gamelog.period = @"Q1";
                break;
                
            case 2:
                gamelog.period = @"Q2";
                break;
                
            case 3:
                gamelog.period = @"Q3";
                break;
                
            default:
                gamelog.period = @"Q4";
                break;
        }
        
        gamelog.time = [NSString stringWithFormat:@"%@%@%@", _minutesTextField.text, @":", _secondsTextField.text];
        gamelog.player = player.athleteid;
        gamelog.yards = [NSNumber numberWithInt:[_returnyardsTextField.text intValue]];
        
        if (touchdown) {
            if (interception)
                gamelog.logentry = @"yard interception return";
            else
                gamelog.logentry = @"yard fumble return";
            
            gamelog.score = @"TD";
            touchdown = NO;
        } else {
            gamelog.score = @"2P";
            safety = NO;
        }
        
        [game updateGamelog:gamelog];
        [game saveGameschedule];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonClicked:(id)sender {
    if (originalStat != nil)
        [player updateFootballDefenseGameStats:originalStat];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _returnyardsTextField)
        _retYardsLabel.text = _returnyardsTextField.text;
    
    lastTextField = textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _returnyardsTextField) {
        NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        if (myStringMatchesRegEx) {
            
            if (textField == _returnyardsTextField) {
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Add Tackle"]) {
        stat.tackles = [NSNumber numberWithInt:[stat.tackles intValue] + 1];
        
        if ([stat.assists intValue] > 0)
            _tacklesLabel.text = [NSString stringWithFormat:@"%.01f", [stat.tackles floatValue] + ([stat.assists floatValue]/2)];
        else
            _tacklesLabel.text = [stat.tackles stringValue];
        
    } else if (([title isEqualToString:@"Delete Tackle"]) && ([stat.tackles intValue] > 0)) {
        stat.tackles = [NSNumber numberWithInt:[stat.tackles intValue] - 1];
        _tacklesLabel.text = [stat.tackles stringValue];
    } else if ([title isEqualToString:@"Add Assist"]) {
        stat.assists = [NSNumber numberWithInt:[stat.assists intValue] + 1];
        _assistsLabel.text = [stat.assists stringValue];
        _tacklesLabel.text = [NSString stringWithFormat:@"%.01f", ([stat.tackles floatValue] + ([stat.assists floatValue]/2))];
    } else if (([title isEqualToString:@"Delete Assist"]) && ([stat.assists intValue] > 0)) {
        stat.assists = [NSNumber numberWithInt:[stat.assists intValue] - 1];
        
        if ([stat.assists intValue] > 0)
            _tacklesLabel.text = [NSString stringWithFormat:@"%.01f", ([stat.tackles floatValue] + ([stat.assists floatValue]/2))];
        else
            _tacklesLabel.text = [stat.tackles stringValue];

        _assistsLabel.text = [stat.assists stringValue];
    } else if ([title isEqualToString:@"Add Sack"]) {
        stat.sacks = [NSNumber numberWithInt:[stat.sacks intValue] + 1];
        
        if ([stat.sackassist intValue] > 0)
            _sacksLabel.text = [NSString stringWithFormat:@"%.01f", [stat.sacks floatValue] + ([stat.sackassist floatValue]/2)];
        else
             _sacksLabel.text = [stat.assists stringValue];
        
        _sacksLabel.text = [stat.sacks stringValue];
    } else if (([title isEqualToString:@"Delete Sack"]) && ([stat.sacks intValue] > 0)){
        stat.sacks = [NSNumber numberWithInt:[stat.sacks intValue] - 1];
        _sacksLabel.text = [stat.assists stringValue];
    } else if ([title isEqualToString:@"Add Interception"]) {
        stat.interceptions = [NSNumber numberWithInt:[stat.interceptions intValue] + 1];
        _intLabel.text = [stat.interceptions stringValue];
        interception = YES;
        [self interceptionFields:YES];
    } else if (([title isEqualToString:@"Delete Interception"]) && ([stat.interceptions intValue] > 0)){
        stat.interceptions = [NSNumber numberWithInt:[stat.interceptions intValue] - 1];
        _intLabel.text = [stat.interceptions stringValue];
        interception = NO;
        [self interceptionFields:NO];
    } else if ([title isEqualToString:@"Add Pass Defended"]) {
        stat.pass_defended = [NSNumber numberWithInt:[stat.pass_defended intValue] + 1];
        _passdefendedlabel.text = [stat.pass_defended stringValue];
    } else if (([title isEqualToString:@"Delete Pass Defended"]) && ([stat.pass_defended intValue] > 0)){
        stat.pass_defended = [NSNumber numberWithInt:[stat.pass_defended intValue] - 1];
        _passdefendedlabel.text = [stat.pass_defended stringValue];
    } else if ([title isEqualToString:@"Add Fumble Recovered"]) {
        stat.fumbles_recovered = [NSNumber numberWithInt:[stat.fumbles_recovered intValue] + 1];
        _fumbleRecoverecLabel.text = [stat.fumbles_recovered stringValue];
    } else if (([title isEqualToString:@"Delete Fumble Recovered"]) && ([stat.fumbles_recovered intValue] > 0)){
        stat.fumbles_recovered = [NSNumber numberWithInt:[stat.fumbles_recovered intValue] - 1];
        _fumbleRecoverecLabel.text = [stat.fumbles_recovered stringValue];
    } else if ([title isEqualToString:@"Add TD"]) {
        stat.td = [NSNumber numberWithInt:[stat.td intValue] + 1];
        _tdLabel.text = [stat.td stringValue];
        [self toggleTimeQuarterFields:YES];
        touchdown = YES;
    } else if (([title isEqualToString:@"Delete TD"]) && ([stat.td intValue] > 0)){
        stat.td = [NSNumber numberWithInt:[stat.td intValue] - 1];
        _tdLabel.text = [stat.td stringValue];
        [self toggleTimeQuarterFields:NO];
        touchdown = NO;
    } else if ([title isEqualToString:@"Add Safety"]) {
        stat.safety = [NSNumber numberWithInt:[stat.safety intValue] + 1];
        _safetylabel.text = [stat.safety stringValue];
        [self toggleTimeQuarterFields:YES];
        safety = YES;
    } else if (([title isEqualToString:@"Delete Safety"]) && ([stat.safety intValue] > 0)){
        stat.safety = [NSNumber numberWithInt:[stat.safety intValue] - 1];
        _safetylabel.text = [stat.safety stringValue];
        [self toggleTimeQuarterFields:NO];
        safety = NO;
    } else if ([title isEqualToString:@"Add Sack Assist"]) {
        stat.sackassist = [NSNumber numberWithInt:[stat.sackassist intValue] + 1];
        _sackassistLabel.text = [stat.sackassist stringValue];
        _sacksLabel.text = [NSString stringWithFormat:@"%.01f", ([stat.sacks floatValue] + ([stat.sackassist floatValue]/2))];
    } else if (([title isEqualToString:@"Delete Sack Assist"]) && ([stat.sackassist intValue] > 0)){
        stat.sackassist = [NSNumber numberWithInt:[stat.sackassist intValue] - 1];
        _sackassistLabel.text = [stat.sackassist stringValue];
        
        if ([stat.sackassist intValue] > 0)
            _sacksLabel.text = [NSString stringWithFormat:@"%.01f", ([stat.sacks floatValue] + ([stat.sackassist floatValue]/2))];
        else
            _sacksLabel.text = [stat.sacks stringValue];
    }
}

- (void)toggleTimeQuarterFields:(BOOL)On {
    if (On) {
        _quarterTextField.hidden = NO;
        _quarterLabel.hidden = NO;
        _timeofscoreLabel.hidden = NO;
        _minutesTextField.hidden = NO;
        _secondsTextField.hidden = NO;
        _colonLabel.hidden = NO;
        _returnyardsLabel.hidden = NO;
        
        _quarterTextField.enabled = YES;
        _minutesTextField.enabled = YES;
        _secondsTextField.enabled = YES;
        _returnyardsTextField.enabled = YES;
    } else {
        _quarterTextField.hidden = YES;
        _quarterLabel.hidden = YES;
        _timeofscoreLabel.hidden = YES;
        _minutesTextField.hidden = YES;
        _secondsTextField.hidden = YES;
        _colonLabel.hidden = YES;
        _returnyardsLabel.hidden = YES;
        
        _quarterTextField.enabled = NO;
        _minutesTextField.enabled = NO;
        _secondsTextField.enabled = NO;
        _returnyardsTextField.enabled = NO;
    }
}

- (void)interceptionFields:(BOOL)interception {
    if (interception) {
        _returnyardsLabel.hidden = NO;
        _returnyardsTextField.enabled = YES;
    } else {
        _returnyardsLabel.hidden = YES;
        _returnyardsTextField.enabled = NO;
    }
}

- (IBAction)sackAssistsButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sack Assist"  message:@"Update Sack Assists Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Sack Assist", @"Delete Sack Assist", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TotalsDefenseSegue"]) {
        EazesportzFootballDefenseTotalsViewController *destController = segue.destinationViewController;
        destController.player = player;
        destController.game = game;
    }
    
    [lastTextField resignFirstResponder];
}

@end
