//
//  EazesportzReturnerStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 11/30/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzReturnerStatsViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzFootballReturnerTotalsViewController.h"

@interface EazesportzReturnerStatsViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzReturnerStatsViewController {
    FootballReturnerStats *stat, *originalstat;
    
    BOOL kotd, puntreturntd;
    
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
    self.title = @"Return Statistics";
    
    _returnYardsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _quarterTextField.keyboardType = UIKeyboardTypeNumberPad;
    _minutesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _secondsTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    _returnYardsTextField.hidden = YES;
    _returnYardsLabel.hidden = YES;
    
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
    
    kotd = puntreturntd = NO;
    _kickoffReturnButton.enabled = YES;
    _puntReturnButton.enabled = YES;
    
    [self toggleTimeQuarterFields:NO];
    
    stat = [player findFootballReturnerStat:game.id];
    if (stat.football_returner_id.length > 0)
        originalstat = [stat copy];
    else {
        originalstat = nil;
    }
    
    _playerImage.image = [player getImage:@"tiny"];
    _playerNumberLabel.text = [player.number stringValue];
    _playerNameLabel.text = player.logname;
    
    _koreturnsLabel.text = [stat.koreturn stringValue];
    _koreturnyardsLabel.text = [stat.koyards stringValue];
    _kotdLabel.text = [stat.kotd stringValue];
    _kolongLabel.text = [stat.kolong stringValue];
    
    _puntreturnlongLabel.text = [stat.punt_returnlong stringValue];
    _puntreturnsLabel.text = [stat.punt_return stringValue];
    _puntreturntdLabel.text = [stat.punt_returntd stringValue];
    _puntreturnyardsLabel.text = [stat.punt_returnyards stringValue];
}

- (IBAction)kickoffreturnButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Kickoff Return"  message:@"Update Kickoff Return Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add KO Return", @"Delete KO Return", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)puntreturnButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Punt Return"  message:@"Update Punt Return Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Punt Return", @"Delete Punt Return", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)tdButtonClicked:(id)sender {
    if ((_kickoffReturnButton.enabled) || (_puntReturnButton.enabled)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TD Return"  message:@"Update TD Return Stats" delegate:self
                                              cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add TD Return", @"Delete TD Return", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"A kickoff or punt return must be selected before entering a TD" delegate:nil
                                              cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (IBAction)submitButtonClicked:(id)sender {
    if ((kotd) && (puntreturntd)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Cannot have both kickoff return TD and Punt Return TD" delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
    
    if (((kotd) || (puntreturntd)) && ((_minutesTextField.text.length == 0) || (_secondsTextField.text.length == 0))) {
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
    
    if ((kotd) || (puntreturntd))
        [stat saveStats];
    
    [player updateFootballReturnerGameStats:stat];
    
    if ((_minutesTextField.text.length > 0) && (_quarterTextField.text.length > 0)) {
        Gamelogs *gamelog = [[Gamelogs alloc] init];
        gamelog.football_returner_id = stat.football_returner_id;
        gamelog.gameschedule_id = game.id;
        gamelog.period = _quarterTextField.text;
        gamelog.time = [NSString stringWithFormat:@"%@%@%@", _minutesTextField.text, @":", _secondsTextField.text];
        gamelog.player = player.athleteid;
        
        gamelog.logentry = player.logname;
        
        if (kotd) {
            gamelog.score = @"TD";
            gamelog.yards = [NSNumber numberWithInt:[_returnYardsTextField.text intValue]];
            kotd = NO;
        } else {
            gamelog.score = @"TD";
            gamelog.yards = [NSNumber numberWithInt:[_returnYardsTextField.text intValue]];
            puntreturntd = NO;
        }
        
        [game updateGamelog:gamelog];
        [game saveGameschedule];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonClicked:(id)sender {
    if (originalstat != nil)
        [player updateFootballReturnerGameStats:originalstat];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Add KO Return"]) {
        stat.koreturn = [NSNumber numberWithInt:[stat.koreturn intValue] + 1];
        _koreturnsLabel.text = [stat.koreturn stringValue];
        _puntReturnButton.enabled = NO;
        _returnYardsLabel.hidden = NO;
        _returnYardsTextField.hidden = NO;
    } else if (([title isEqualToString:@"Delete KO Return"]) && ([stat.koreturn intValue] > 0)) {
        if (kotd) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Delete Kickoff TD before removing kickoff return" delegate:nil
                                                  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
            return;
        }
        stat.koreturn = [NSNumber numberWithInt:[stat.koreturn intValue] - 1];
        _koreturnsLabel.text = [stat.koreturn stringValue];
        _puntReturnButton.enabled = YES;
        _returnYardsTextField.hidden = YES;
        _returnYardsLabel.hidden = YES;
    } else if ([title isEqualToString:@"Add Punt Return"]) {
        stat.punt_return = [NSNumber numberWithInt:[stat.punt_return intValue] + 1];
        _puntreturnsLabel.text = [stat.punt_return stringValue];
        _kickoffReturnButton.enabled = NO;
        _returnYardsLabel.hidden = NO;
        _returnYardsTextField.hidden = NO;
    } else if (([title isEqualToString:@"Delete Punt Return"]) && ([stat.punt_return intValue] > 0)) {
        if (puntreturntd) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Delete Punt Return TD before removing kickoff return" delegate:nil
                                                  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
            return;
        }
        stat.punt_return = [NSNumber numberWithInt:[stat.punt_return intValue] - 1];
        _puntreturnsLabel.text = [stat.punt_return stringValue];
        _kickoffReturnButton.enabled = YES;
        _returnYardsTextField.hidden = YES;
        _returnYardsLabel.hidden = YES;
    } else if ([title isEqualToString:@"Add TD Return"]) {
        if (_kickoffReturnButton.enabled) {
            stat.kotd = [NSNumber numberWithInt:[stat.kotd intValue] + 1];
            _kotdLabel.text = [stat.kotd stringValue];
            kotd = YES;
        } else {
            stat.punt_returntd = [NSNumber numberWithInt:[stat.punt_returntd intValue] + 1];
            _puntreturntdLabel.text = [stat.punt_returntd stringValue];
            puntreturntd = YES;
        }
    } else if ([title isEqualToString:@"Delete TD Return"]) {
        if (kotd) {
            stat.kotd = [NSNumber numberWithInt:[stat.kotd intValue] - 1];
            _kotdLabel.text = [stat.kotd stringValue];
            kotd = NO;
        } else if (puntreturntd) {
            stat.punt_returntd = [NSNumber numberWithInt:[stat.punt_returntd intValue] - 1];
            _puntreturntdLabel.text = [stat.punt_returntd stringValue];
            puntreturntd = NO;
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _returnYardsTextField) {
        _returnYardsTextField.text = _returnYardsTextField.text;
        
        if (_kickoffReturnButton.enabled ) {
            if ([stat.kolong intValue] < [_returnYardsTextField.text intValue])
                stat.kolong = [NSNumber numberWithInt:[_returnYardsTextField.text intValue]];
        } else {
            if ([stat.punt_returnlong intValue] < [_returnYardsTextField.text intValue])
                stat.punt_returnlong = [NSNumber numberWithInt:[_returnYardsTextField.text intValue]];
        }
    }
    lastTextField = textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _returnYardsTextField) {
        NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        if (myStringMatchesRegEx) {
            
            if (textField == _returnYardsTextField) {
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

- (void)toggleTimeQuarterFields:(BOOL)On {
    if (On) {
        _quarterTextField.hidden = NO;
        _quarterLabel.hidden = NO;
        _timeofscoreLabel.hidden = NO;
        _minutesTextField.hidden = NO;
        _secondsTextField.hidden = NO;
        _colonLabel.hidden = NO;
        _quarterTextField.enabled = YES;
        _minutesTextField.enabled = YES;
        _secondsTextField.enabled = YES;
    } else {
        _quarterTextField.hidden = YES;
        _quarterLabel.hidden = YES;
        _timeofscoreLabel.hidden = YES;
        _minutesTextField.hidden = YES;
        _secondsTextField.hidden = YES;
        _colonLabel.hidden = YES;
        _quarterTextField.enabled = NO;
        _minutesTextField.enabled = NO;
        _secondsTextField.enabled = NO;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"TotalsReturnerSegue"]) {
        EazesportzFootballReturnerTotalsViewController *destController = segue.destinationViewController;
        destController.player = player;
        destController.game = game;
    }
    [lastTextField resignFirstResponder];
}

@end
