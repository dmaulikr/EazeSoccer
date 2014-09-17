//
//  EazesportzHockeyPenaltyStatsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 9/16/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzHockeyPenaltyStatsViewController.h"

#import "EazesportzAppDelegate.h"

@interface EazesportzHockeyPenaltyStatsViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation EazesportzHockeyPenaltyStatsViewController {
    NSString *pickertype;
    
    Athlete *player;
    NSArray *penaltyarray;
}

@synthesize game;
@synthesize penaltystat;

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
    
    penaltyarray = [[NSArray alloc] initWithArray:[game.hockey_game.hockey_penalties allKeys]];
    
    _playerPickerView.hidden = YES;
    _playerPickerView.dataSource = self;
    _playerPickerView.delegate = self;
    pickertype = @"Player";
    
    [_periodSegmentedControl setSelectedSegmentIndex:[game.period intValue] - 1];
    
    if (penaltystat) {
        player = [currentSettings findAthlete:penaltystat.athlete_id];
        _playerTextField.text = player.logname;
        _penaltyTextField.text = [game.hockey_game.hockey_penalties allKeysForObject:penaltystat.infraction][0];
        
        NSArray *timearray = [penaltystat.gametime componentsSeparatedByString:@":"];
        
        if (timearray.count > 0) {
            _minutesTextField.text = [timearray objectAtIndex:0];
            _secondsTextField.text = [timearray objectAtIndex:1];
        } else {
            _minutesTextField.text = @"00";
            _secondsTextField.text = @"00";
        }
        
        timearray = [penaltystat.penaltytime componentsSeparatedByString:@":"];
        
        if (timearray.count > 0) {
            _penaltyTimeMinutesTextField.text = timearray[0];
            _penaltyTimeSecondsTextField.text = timearray[1];
        } else {
            _penaltyTimeMinutesTextField.text = @"0";
            _penaltyTimeSecondsTextField.text = @"00";
        }
        
        _deleteButton.hidden = NO;
        _deleteButton.enabled = YES;
    } else {
        _playerTextField.text = @"";
        _penaltyTimeMinutesTextField.text = @"0";
        _penaltyTimeSecondsTextField.text = @"00";
        _minutesTextField.text = @"00";
        _secondsTextField.text = @"00";
        _deleteButton.hidden = YES;
        _deleteButton.enabled = NO;
        player = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _playerPickerView.delegate = nil;
    _playerPickerView.dataSource = nil;
}

- (IBAction)deleteButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statSaved:) name:@"HockeyStatNotification" object:nil];
    HockeyStat *stat = [player findHockeyStat:game];
    [stat deletePenaltyStat:game.id PenaltyStat:penaltystat];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ((textField == _minutesTextField) || (textField == _secondsTextField) ||
        (textField == _penaltyTimeMinutesTextField) || (textField == _penaltyTimeSecondsTextField)) {
        NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        if (myStringMatchesRegEx)
            return YES;
        else
            return NO;
    } else
        return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = @"";
    
    if (textField == _playerTextField) {
        pickertype = @"Player";
        [_playerPickerView reloadAllComponents];
        _playerPickerView.hidden = NO;
        [textField resignFirstResponder];
    } else if (textField == _penaltyTextField) {
        pickertype = @"Penalty";
        [_playerPickerView reloadAllComponents];
        _playerPickerView.hidden = NO;
        [textField resignFirstResponder];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// Method to define the numberOfRows in a component using the array.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component {
    if ([pickertype isEqualToString:@"Player"]) {
        return currentSettings.roster.count;
    } else {
        return game.hockey_game.hockey_penalties.count;
    }
}

// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickertype isEqualToString:@"Player"])
        return [[currentSettings.roster objectAtIndex:row] numberLogname];
    else
        return [penaltyarray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickertype isEqualToString:@"Player"]) {
        player = [currentSettings.roster objectAtIndex:row];
        _playerTextField.text = player.numberLogname;
        penaltystat.athlete_id = player.athleteid;
    } else if ([pickertype isEqualToString:@"Penalty"]){
        _penaltyTextField.text = [penaltyarray objectAtIndex:row];
        penaltystat.infraction = [game.hockey_game.hockey_penalties objectForKey:[penaltyarray objectAtIndex:row]];
    }
    
    _playerPickerView.hidden = YES;
}

- (IBAction)periodSegmentedControlClicked:(id)sender {
}

- (IBAction)submitButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statSaved:) name:@"HockeyStatNotification" object:nil];
    HockeyStat *stat;
    
    stat = [player findHockeyStat:game];
    
    if (!penaltystat) {
        penaltystat = [[HockeyPenalty alloc] init];
        
        penaltystat.athlete_id = player.athleteid;
        penaltystat.hockey_stat_id = stat.hockey_stat_id;
    }
    
//    penaltystat.infraction = _penaltyTextField.text;
    penaltystat.penaltytime = [_penaltyTimeMinutesTextField.text stringByAppendingFormat:@":%@", _penaltyTimeSecondsTextField.text];
    penaltystat.gametime = [_minutesTextField.text stringByAppendingFormat:@":%@", _secondsTextField.text];
    penaltystat.period = [NSNumber numberWithLong:_periodSegmentedControl.selectedSegmentIndex + 1];
    [stat savePenaltyStat:game.id PenaltyStat:penaltystat];
}

- (void)statSaved:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Stat Updated" delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error saving stats" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
