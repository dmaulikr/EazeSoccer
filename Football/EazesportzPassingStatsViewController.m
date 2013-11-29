//
//  EazesportzPassingStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 11/22/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzPassingStatsViewController.h"
#import "EazesportzAppDelegate.h"
#import "PlayerSelectionViewController.h"
#import "Gamelogs.h"

@interface EazesportzPassingStatsViewController () <UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation EazesportzPassingStatsViewController {
    FootballPassingStat *originalStat, *stat;
    Athlete *receiver;
    FootballReceivingStat *recstats;
    NSMutableArray *minsArray, *secsArray;
    NSString *gameminutes;
    
    BOOL touchdown, twopoint, removecompletion;
    
    PlayerSelectionViewController *playerSelectionController;
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
    self.title = @"Passing Statistics";
    _completionYardsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _sackyardslostTextField.keyboardType = UIKeyboardTypeNumberPad;
    
//    _receiverTextField.inputView = _playerContainer.inputView;
    minsArray = [[NSMutableArray alloc] init];
    secsArray = [[NSMutableArray alloc] init];
    NSString *strVal = [[NSString alloc] init];
    gameminutes = @"";
    
    for (int i = 0; i < 16; i++) {
        strVal = [NSString stringWithFormat:@"%d", i];
        [minsArray addObject:strVal];
    }
    for(int i=0; i<60; i++){
        strVal = [NSString stringWithFormat:@"%d", i];
        //create arrays with 0-60 secs/mins
        [secsArray addObject:strVal];
    }
//    quarters = [[NSMutableArray alloc] initWithObjects:@"Q1", @"Q2", @"Q3", @"Q4", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    recstats = nil;
    [_receverFumbleLostSwitch setOn:NO];
    [_receiverFumbleSwitch setOn:NO];
    _receiverFumbleSwitch.hidden = YES;
    _receverFumbleLostSwitch.hidden = YES;
    
    _playerContainer.hidden = YES;
    _quarterPicker.hidden = YES;
    _timeofscorePicker.hidden = YES;
    
    touchdown = NO;
    
    stat = [player findFootballPassingStat:game.id];
    
    _receiverTextField.enabled = NO;
    _receiverTextField.hidden = YES;
    _completionYardsTextField.hidden = YES;
    _completionYardsTextField.enabled = NO;
    
    _quarterTextField.enabled = NO;
    _quarterTextField.hidden = YES;
    _quarterTextField.text = [game.period stringValue];
    
    _timeTextField.enabled = NO;
    _timeTextField.hidden = YES;
    _receiverLabel.hidden = YES;
    _receiverFumbleLabel.hidden = YES;
    _receiverFumbleLostLabel.hidden = YES;
    _compyardsLabel.hidden = YES;
    _quarterLabel.hidden = YES;
    _timeofscoreLabel.hidden = YES;
    _sackyardslostTextField.hidden = YES;
    
    if (stat.football_passing_id.length > 0)
        originalStat = [stat copy];
    else {
        originalStat = nil;
        stat.athlete_id = player.athleteid;
        stat.gameschedule_id = game.id;
    }

    _playerImageView.image = [player getImage:@"tiny"];
    _playerNumberLabel.text = [player.number stringValue];
    _playerNameLabel.text = player.logname;
    _attemptsLabel.text = [stat.attempts stringValue];
    _completionLabel.text = [stat.completions stringValue];
    _compercentageLabel.text = [stat.comp_percentage stringValue];
    _yardsLabel.text = [stat.yards stringValue];
    _tdlabel.text = [stat.td stringValue];
    _interceptionLabel.text = [stat.interceptions stringValue];
    _sacksLabel.text = [stat.sacks stringValue];
    _firstdownsLabel.text = [stat.firstdowns stringValue];
    _lostLabel.text = [stat.yards_lost stringValue];
    _twopointLabel.text = [stat.twopointconv stringValue];
}

- (IBAction)totalsButtonClicked:(id)sender {
}

- (IBAction)attemptButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pass Attempt"  message:@"Update Pass Attempt Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Attempt", @"Delete Attempt", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)completionButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Completion"  message:@"Update Completion Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Completion", @"Remove Completion", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)interceptionButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Interception"  message:@"Update Interception Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Interception", @"Delete Interception", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)sackButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sack"  message:@"Update Sack Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Sack", @"Delete Sack", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)firstdownsButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Downs"  message:@"Update First Down Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add First Down", @"Delete First Down", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)tdButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Touchdown"  message:@"Update Touchdown Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add TD", @"Delete TD", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)twopointButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Two Point Conversion"  message:@"Update Two Point Conversion Stats" delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add 2PT", @"Delete 2PT", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)submitButtonClicked:(id)sender {
    if (((touchdown) || (twopoint)) && (_receiverTextField.text.length == 0)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Please enter a reciever" delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
    
    if ((_completionYardsTextField.text.length == 0) && (_receiverTextField.text.length > 0)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Please enter completion yards" delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
    
    if (_completionYardsTextField.text.length > 0) {
        recstats.yards = [NSNumber numberWithInt:[recstats.yards intValue] + [_completionYardsTextField.text intValue]];
        stat.yards = [NSNumber numberWithInt:[stat.yards intValue] + [_completionYardsTextField.text intValue]];
    }
    
    if (_sackyardslostTextField.text.length > 0)
        stat.yards_lost = [NSNumber numberWithInt:[stat.yards_lost intValue] + [_sackyardslostTextField.text intValue]];
    
    stat.comp_percentage = [NSNumber numberWithFloat:([stat.completions floatValue] / [stat.attempts floatValue])];
    
    if ((touchdown) || (twopoint))
        [stat saveStats];
    
    [player updateFootballPassingGameStats:stat];
    
    if (recstats) {
        recstats.average = [NSNumber numberWithFloat:([recstats.yards floatValue] / [recstats.receptions floatValue])];
        
        if ((touchdown) || (twopoint))
            [recstats saveStats];
        
        [receiver updateFootballReceivingGameStats:recstats];
    }
    
    if ((_timeTextField.text.length > 0) && (_quarterTextField.text.length > 0)) {
        Gamelogs *gamelog = [[Gamelogs alloc] init];
        gamelog.gameschedule_id = game.id;
        gamelog.period = _quarterTextField.text;
        gamelog.time = _timeTextField.text;
        gamelog.player = player.athleteid;
        gamelog.yards = [NSNumber numberWithInt:[_completionYardsTextField.text intValue]];
        gamelog.football_passing_id = stat.football_passing_id;
        
        if (_receiverTextField.text.length > 0)
            gamelog.assistplayer = [[playerSelectionController player] athleteid];
        
        gamelog.logentry = @"yard pass to";
        
        if ((_timeTextField.text.length > 0) && (touchdown))
            gamelog.score = @"TD";
        else if (_timeTextField.text.length > 0)
            gamelog.score = @"2P";
        
//        gamelog.logentrytext = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@", gamelog.period, @":", gamelog.time, @" - ",  player.logname, @" ",
//                                [gamelog.yards stringValue], @" ", gamelog.logentry, @" ", receiver.logname, @" - ", gamelog.score];
        [game updateGamelog:gamelog];
        [game saveGameschedule];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonClicked:(id)sender {
    if (originalStat != nil)
        [player updateFootballPassingGameStats:originalStat];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Add Attempt"]) {
        stat.attempts = [NSNumber numberWithInt:[stat.attempts intValue] + 1];
        _attemptsLabel.text = [stat.attempts stringValue];
    } else if (([title isEqualToString:@"Delete Attempt"]) && ([stat.attempts intValue] > 0)) {
        stat.attempts = [NSNumber numberWithInt:[stat.attempts intValue] - 1];
        _attemptsLabel.text = [stat.attempts stringValue];
    } else if ([title isEqualToString:@"Add Interception"]) {
        stat.interceptions = [NSNumber numberWithInt:[stat.interceptions intValue] + 1];
        _interceptionLabel.text = [stat.interceptions stringValue];
    } else if (([title isEqualToString:@"Delete Interception"]) && ([stat.interceptions intValue] > 0)) {
        stat.interceptions = [NSNumber numberWithInt:[stat.interceptions intValue] - 1];
        _interceptionLabel.text = [stat.interceptions stringValue];
    } else if ([title isEqualToString:@"Add Completion"]) {
        _playerContainer.hidden = NO;
     } else if (([title isEqualToString:@"Remove Completion"]) && ([stat.completions intValue] > 0)) {
        _playerContainer.hidden = NO;
        removecompletion = YES;
    } else if ([title isEqualToString:@"Add Sack"]) {
        stat.sacks = [NSNumber numberWithInt:[stat.sacks intValue] + 1];
        _sacksLabel.text = [stat.sacks stringValue];
        _sackyardslostTextField.hidden = NO;
    } else if (([title isEqualToString:@"Delete Sack"]) && ([stat.sacks intValue] > 0)) {
        stat.sacks = [NSNumber numberWithInt:[stat.sacks intValue] - 1];
        _sacksLabel.text = [stat.sacks stringValue];
        _sackyardslostTextField.hidden = YES;
    } else if ([title isEqualToString:@"Add First Down"]) {
        stat.firstdowns = [NSNumber numberWithInt:[stat.firstdowns intValue] + 1];
        _firstdownsLabel.text = [stat.firstdowns stringValue];
    } else if (([title isEqualToString:@"Delete First Down"]) && ([stat.firstdowns intValue] > 0)) {
        stat.firstdowns = [NSNumber numberWithInt:[stat.firstdowns intValue] - 1];
        _firstdownsLabel.text = [stat.firstdowns stringValue];
    } else if ([title isEqualToString:@"Add TD"]) {
        if (_receiverTextField.text.length > 0) {
            stat.td = [NSNumber numberWithInt:[stat.td intValue] + 1];
            _tdlabel.text = [stat.td stringValue];
            _timeTextField.hidden = NO;
            _timeTextField.enabled = YES;
            _quarterTextField.hidden = NO;
            _quarterTextField.enabled = YES;
            _quarterLabel.hidden = NO;
            _timeofscoreLabel.hidden = NO;
            touchdown = YES;
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Need to designate receiver before adding a TD!" delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else if (([title isEqualToString:@"Delete TD"]) && ([stat.td intValue] > 0)) {
        if (touchdown) {
            stat.td = [NSNumber numberWithInt:[stat.td intValue] - 1];
            _tdlabel.text = [stat.td stringValue];
            _timeTextField.hidden = YES;
            _timeTextField.enabled = NO;
            _timeTextField.text = @"";
            _quarterTextField.hidden = YES;
            _quarterTextField.enabled = NO;
            _quarterTextField.text = @"";
            _quarterLabel.hidden = YES;
            _timeofscoreLabel.hidden = YES;
            touchdown = NO;
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"No valid TD added. \n If you want to remove a score, delete the game log. The score will be removed from the QB and receiver simultaneously." delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else if ([title isEqualToString:@"Add 2PT"]) {
        if (_receiverTextField.text.length > 0) {
            stat.td = [NSNumber numberWithInt:[stat.td intValue] + 1];
            _tdlabel.text = [stat.td stringValue];
            _timeTextField.hidden = NO;
            _timeTextField.enabled = YES;
            _quarterTextField.hidden = NO;
            _quarterTextField.enabled = YES;
            _quarterLabel.hidden = NO;
            _timeofscoreLabel.hidden = NO;
            twopoint = YES;
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Need to designate receiver before adding a Two Pont conversion!"
                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else if (([title isEqualToString:@"Delete 2PT"]) && ([stat.td intValue] > 0)) {
        if (twopoint) {
            stat.td = [NSNumber numberWithInt:[stat.td intValue] - 1];
            _tdlabel.text = [stat.td stringValue];
            _timeTextField.hidden = YES;
            _timeTextField.enabled = NO;
            _timeTextField.text = @"";
            _quarterTextField.hidden = YES;
            _quarterTextField.enabled = NO;
            _quarterTextField.text = @"";
            _quarterLabel.hidden = YES;
            _timeofscoreLabel.hidden = YES;
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"No valid Two Point conversion added. \n If you want to remove a score, delete the game log. The score will be removed from the QB and receiver simultaneously." delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayerSelectSegue"]) {
        playerSelectionController = segue.destinationViewController;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _receiverTextField) {
        [textField resignFirstResponder];
        _playerContainer.hidden = NO;
//    } else if (textField == _quarterTextField) {
//        _quarterTextField.text = @"";
//        _quarterPicker.hidden = NO;
//        [_quarterTextField resignFirstResponder];
    } else if (textField == _timeTextField) {
        _timeofscorePicker.hidden = NO;
        _timeTextField.text = @"";
        [_timeTextField resignFirstResponder];
    }
}

- (IBAction)selectPassingReceiverPlayer:(UIStoryboardSegue *)segue {
    _playerContainer.hidden = YES;
    
    if (playerSelectionController.player) {
        if (removecompletion) {
            removecompletion = NO;
            
            recstats = nil;
            receiver = nil;
            
            stat.completions = [NSNumber numberWithInt:[stat.completions intValue] - 1];
            stat.attempts = [NSNumber numberWithInt:[stat.attempts intValue] - 1];
            
            _completionLabel.text = [stat.completions stringValue];
            _attemptsLabel.text = [stat.attempts stringValue];
            
            _receiverTextField.hidden = YES;
            _receiverTextField.text = @"";
            _completionYardsTextField.enabled = NO;
            _completionYardsTextField.hidden = YES;
            _completionYardsTextField.text = @"";
            _receiverLabel.hidden = YES;
            _receiverFumbleLabel.hidden = YES;
            _receiverFumbleLostLabel.hidden = YES;
            _compyardsLabel.hidden = YES;
            _receverFumbleLostSwitch.hidden = YES;
            _receiverFumbleSwitch.hidden = YES;
            
            if ((touchdown) || (twopoint)) {
                if (touchdown) {
                    stat.td = [NSNumber numberWithInt:[stat.td intValue] - 1];
                    touchdown = NO;
                } else {
                    stat.twopointconv = [NSNumber numberWithInt:[stat.twopointconv intValue] - 1];
                    twopoint = NO;
                }
                
                _quarterLabel.hidden = YES;
                _quarterTextField.hidden = YES;
                _quarterTextField.text = @"";
                _timeofscoreLabel.hidden = YES;
                _timeTextField.hidden = YES;
                _timeTextField.text = @"";
            }
        } else {
            receiver = [currentSettings findAthlete:playerSelectionController.player.athleteid];
            recstats = [receiver findFootballReceivingStat:game.id];
            
            if (recstats.gameschedule_id.length == 0) {
                
            }
                
            recstats.receptions = [NSNumber numberWithInteger:[recstats.receptions intValue] + 1];

            stat.completions = [NSNumber numberWithInt:[stat.completions intValue] + 1];
            stat.attempts = [NSNumber numberWithInt:[stat.attempts intValue] + 1];
            
            _completionLabel.text = [stat.completions stringValue];
            _attemptsLabel.text = [stat.attempts stringValue];
            
            _receiverTextField.hidden = NO;
            _completionYardsTextField.enabled = YES;
            _completionYardsTextField.hidden = NO;
            _receiverLabel.hidden = NO;
            _receiverFumbleLabel.hidden = NO;
            _receiverFumbleLostLabel.hidden = NO;
            _compyardsLabel.hidden = NO;
            _receiverFumbleSwitch.hidden = NO;
            _receverFumbleLostSwitch.hidden = NO;
            _receiverTextField.text = playerSelectionController.player.full_name;
        }
    }
}

//Method to define how many columns/dials to show
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == _quarterPicker)
        return 1;
    else
        return 2;
}

// Method to define the numberOfRows in a component using the array.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component {
//    if (pickerView == _quarterPicker) {
//        return [quarters count];
//    } else
    if (pickerView == _timeofscorePicker) {
        switch (component) {
            case 0:
                return [minsArray count];
                break;
                
            default:
                return [secsArray count];
                break;
        }
    }
    return 0;
}

// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    if (pickerView == _quarterPicker) {
//        return [quarters objectAtIndex:row];
//    } else
    if (pickerView == _timeofscorePicker) {
        switch (component) {
            case 0:
                return [minsArray objectAtIndex:row];
                break;
                
            default:
                return [secsArray objectAtIndex:row];
                break;
        }
    }
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    int seconds;
    
    if (pickerView == _timeofscorePicker) {
        switch (component) {
            case 0:
                gameminutes = [minsArray objectAtIndex:row];
                break;
            case 1:
                seconds = [[secsArray objectAtIndex:row] intValue];
                NSString *newsecs;
                NSString *newmins;
                int minutes = [gameminutes intValue];
                
                if ((seconds >= 0) && (seconds <= 9)) {
                    newsecs = @"0";
                    newsecs = [newsecs stringByAppendingString:[NSString stringWithFormat:@"%d", seconds]];
                } else
                    newsecs = [NSString stringWithFormat:@"%d", seconds];
                
                if ((minutes >= 0) && (minutes <= 9)) {
                    newmins = @"0";
                    newmins = [newmins stringByAppendingString:gameminutes];
                } else
                    newmins = gameminutes;
                
                NSString *gametime = newmins;
                gametime = [gametime stringByAppendingString:@":"];
                gametime = [gametime stringByAppendingString:newsecs];
                [_timeTextField setText:gametime];
                _timeofscorePicker.hidden = YES;
                
                break;
        }
//    } else if (pickerView == _quarterPicker) {
//        [_quarterTextField setText:[quarters objectAtIndex:row]];
//        _quarterPicker.hidden = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ((textField == _completionYardsTextField) || (textField == _sackyardslostTextField)) {
        NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        if (myStringMatchesRegEx)
            
            if ((textField == _completionYardsTextField) || (textField == _sackyardslostTextField)) {
                return (newLength > 2) ? NO : YES;
            } else {
                return (newLength > 1) ? NO : YES;
            }
        else
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
    } else
        return YES;
}


@end
