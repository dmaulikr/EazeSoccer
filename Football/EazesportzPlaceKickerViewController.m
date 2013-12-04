//
//  EazesportzPlaceKickerViewController.m
//  EazeSportz
//
//  Created by Gil on 11/30/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzPlaceKickerViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzFootballPlaceKickerTotalsViewController.h"

@interface EazesportzPlaceKickerViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzPlaceKickerViewController {
    FootballPlaceKickerStats *stat, *originalStat;
    
    BOOL xp, fg;
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
    self.title = @"Place Kicker Statistics";
    
    _fgyardsTextField.keyboardType = UIKeyboardTypeNumberPad;
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
    
    xp = fg = NO;
    
    [self toggleTimeQuarterFields:NO FG:YES];
    
    stat = [player findFootballPlaceKickerStat:game.id];
    if (stat.football_place_kicker_id.length > 0)
        originalStat = [stat copy];
    else {
        originalStat = nil;
    }
    
    _playerImage.image = [player getImage:@"tiny"];
    _playerNumberLabel.text = [player.number stringValue];
    _playerNameLabel.text = player.logname;
    
    _fgaLabel.text = [stat.fgattempts stringValue];
    _fgmLabel.text = [stat.fgmade stringValue];
    _blockedLabel.text = [stat.fgblocked stringValue];
    _longLabel.text = [stat.fglong stringValue];
    
    _xpaLabel.text = [stat.xpattempts stringValue];
    _xpmLabel.text = [stat.xpmade stringValue];
    _xpblockedLabel.text = [stat.xpblocked stringValue];
}

- (IBAction)fgaButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Field Goal Attempt"  message:@"Update Field Goal Attempt Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add FGA", @"Delete FGA", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)fgmButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Field Goal Made"  message:@"Update Field Goal Made Attempt Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add FGM", @"Delete FGM", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)fgblockedButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Field Goal Blocked"  message:@"Update Field Goal Blocked Attempt Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add FG Blocked", @"Delete FG Blocked", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)xpaButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Extra Point Attempt"  message:@"Update Extra Point Attempt Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add XP Attempt", @"Delete XP Attempt", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)xpblockedButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Field Extra Point Blocked"  message:@"Update Extra Point Blocked Attempt Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add XP Blocked", @"Delete XP Blocked", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)xpmButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Extra Point Made"  message:@"Update Extra Point Made Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add XP Made", @"Delete XP Made", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)submitButtonClicked:(id)sender {
    if ((fg) && (xp)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Cannot have both Field Goal and Extra Point" delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
    
    if (((fg) || (xp)) && ((_minutesTextField.text.length == 0) || (_secondsTextField.text.length == 0))) {
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
    
    if ((fg) || (xp))
        [stat saveStats];
    
    if ([_fgyardsTextField.text intValue] > [stat.fglong intValue])
        stat.fglong = [NSNumber numberWithInt:[_fgyardsTextField.text intValue]];
    
    [player updateFootballPlaceKickerGameStats:stat];
    
    if ((_minutesTextField.text.length > 0) && (_quarterTextField.text.length > 0)) {
        Gamelogs *gamelog = [[Gamelogs alloc] init];
        gamelog.football_place_kicker_id = stat.football_place_kicker_id;
        gamelog.gameschedule_id = game.id;
        gamelog.period = _quarterTextField.text;
        gamelog.time = [NSString stringWithFormat:@"%@%@%@", _minutesTextField.text, @":", _secondsTextField.text];
        gamelog.player = player.athleteid;
        
        gamelog.logentry = player.logname;
        
        if (fg) {
            gamelog.score = @"TD";
            gamelog.yards = [NSNumber numberWithInt:[_fgyardsTextField.text intValue]];
            fg = NO;
        } else {
            gamelog.score = @"XP";
            xp = NO;
        }
        
        [game updateGamelog:gamelog];
        [game saveGameschedule];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonClicked:(id)sender {
    if (originalStat != nil)
        [player updateFootballPlaceKickerGameStats:originalStat];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Add FGA"]) {
        stat.fgattempts = [NSNumber numberWithInt:[stat.fgattempts intValue] + 1];
        _fgaLabel.text = [stat.fgattempts stringValue];
    } else if (([title isEqualToString:@"Delete FGA"]) && ([stat.fgattempts intValue] > 0)) {
        stat.fgattempts = [NSNumber numberWithInt:[stat.fgattempts intValue] - 1];
        _fgaLabel.text = [stat.fgattempts stringValue];
    } else if ([title isEqualToString:@"Add FGM"]) {
        stat.fgmade = [NSNumber numberWithInt:[stat.fgattempts intValue] + 1];
        _fgmLabel.text = [stat.fgmade stringValue];
        [self toggleTimeQuarterFields:YES FG:YES];
        fg = YES;
    } else if (([title isEqualToString:@"Delete FGM"]) && ([stat.fgmade intValue] > 0)) {
        stat.fgmade = [NSNumber numberWithInt:[stat.fgmade intValue] - 1];
        _fgmLabel.text = [stat.fgmade stringValue];
        [self toggleTimeQuarterFields:NO FG:YES];
    } else if ([title isEqualToString:@"Add FG Blocked"]) {
        stat.fgblocked = [NSNumber numberWithInt:[stat.fgblocked intValue] + 1];
        _blockedLabel.text = [stat.fgblocked stringValue];
    } else if (([title isEqualToString:@"Delete FG Blocked"]) && ([stat.fgblocked intValue] > 0)) {
        stat.fgblocked = [NSNumber numberWithInt:[stat.fgblocked intValue] - 1];
        _blockedLabel.text = [stat.fgblocked stringValue];
    } else if ([title isEqualToString:@"Add XP Attempt"]) {
        stat.xpattempts = [NSNumber numberWithInt:[stat.xpattempts intValue] + 1];
        _xpaLabel.text = [stat.xpattempts stringValue];
    } else if (([title isEqualToString:@"Delete XP Attempt"]) && ([stat.xpattempts intValue] > 0)) {
        stat.xpattempts = [NSNumber numberWithInt:[stat.xpattempts intValue] - 1];
        _xpaLabel.text = [stat.xpattempts stringValue];
    } else if ([title isEqualToString:@"Add XP Made"]) {
        stat.xpmade = [NSNumber numberWithInt:[stat.xpmade intValue] + 1];
        _xpmLabel.text = [stat.xpmade stringValue];
        xp = YES;
        [self toggleTimeQuarterFields:YES FG:NO];
    } else if (([title isEqualToString:@"Delete XP Made"]) && ([stat.xpmade intValue] > 0)) {
        stat.xpmade = [NSNumber numberWithInt:[stat.xpmade intValue] - 1];
        _xpmLabel.text = [stat.xpmade stringValue];
        [self toggleTimeQuarterFields:NO FG:NO];
    } else if ([title isEqualToString:@"Add XP Blocked"]) {
        stat.xpblocked = [NSNumber numberWithInt:[stat.xpblocked intValue] + 1];
        _xpblockedLabel.text = [stat.xpblocked stringValue];
    } else if (([title isEqualToString:@"Delete XP Blocked"]) && ([stat.xpblocked intValue] > 0)) {
        stat.xpblocked = [NSNumber numberWithInt:[stat.xpblocked intValue] - 1];
        _xpblockedLabel.text = [stat.xpblocked stringValue];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _fgyardsTextField) {
        _fgyardsLabel.text = _fgyardsTextField.text;
        
        if ([stat.fglong intValue] < [_fgyardsTextField.text intValue])
            stat.fglong = [NSNumber numberWithInt:[_fgyardsTextField.text intValue]];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _fgyardsTextField) {
        NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        if (myStringMatchesRegEx) {
            
            if (textField == _fgyardsTextField) {
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

- (void)toggleTimeQuarterFields:(BOOL)On FG:(BOOL)fieldgoal {
    if (On) {
        _quarterTextField.hidden = NO;
        _quarterLabel.hidden = NO;
        _timeofscoreLabel.hidden = NO;
        _minutesTextField.hidden = NO;
        _secondsTextField.hidden = NO;
        _colonLabel.hidden = NO;
        
        if (fieldgoal) {
            _fgyardsTextField.hidden = NO;
            _fgyardsTextField.enabled = YES;
        }
        
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
        
        if (fieldgoal) {
            _fgyardsTextField.hidden = YES;
            _fgyardsTextField.enabled = NO;
        }
        
        _quarterTextField.enabled = NO;
        _minutesTextField.enabled = NO;
        _secondsTextField.enabled = NO;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TotalsPlaceKickerSegue"]) {
        EazesportzPlaceKickerViewController *destController = segue.destinationViewController;
        destController.player = player;
        destController.game = game;
    }
}

@end
