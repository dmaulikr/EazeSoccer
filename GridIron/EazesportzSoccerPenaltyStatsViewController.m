//
//  EazesportzSoccerPenaltyStatsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/11/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzSoccerPenaltyStatsViewController.h"

#import "EazesportzAppDelegate.h"

@interface EazesportzSoccerPenaltyStatsViewController ()

@end

@implementation EazesportzSoccerPenaltyStatsViewController {
    VisitorRoster *visitingplayer;
    Athlete *player;
    NSString *pickertype;
    NSArray *yellowarray, *redarray;
    NSString *yellowcard, *redcard;
}

@synthesize game;
@synthesize visitor;
@synthesize penalty;

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
    
    _minutesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _secondsTextField.keyboardType = UIKeyboardTypeNumberPad;
    pickertype = @"player";
    yellowarray = [currentSettings.sport.soccer_yellowcard allKeys];
    redarray = [currentSettings.sport.soccer_redcard allKeys];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _pickerView.hidden = YES;
    [_periodSegmentedControl setSelectedSegmentIndex:[game.period intValue] - 1];
    
    if (penalty) {
        if (visitor) {
            visitingplayer = [[currentSettings findVisitingTeam:game.soccer_game.visiting_team_id] findAthlete:penalty.athlete_id];
            player = nil;
            _playerTextField.text = visitingplayer.logname;
        } else {
            player = [currentSettings findAthlete:penalty.athlete_id];
            visitingplayer = nil;
            _playerTextField.text = player.logname;
        }
        
        if ([penalty.card isEqualToString:@"Y"]) {
            _yellowcardTextField.text = [currentSettings.sport.soccer_yellowcard objectForKey:penalty.infraction];
            _redcardTextField.text = @"";
        } else {
            _yellowcardTextField.text = @"";
            _redcardTextField.text = [currentSettings.sport.soccer_redcard objectForKey:penalty.infraction];
        }

        NSArray *timearray = [penalty.gametime componentsSeparatedByString:@":"];
        
        if (timearray.count > 0) {
            _minutesTextField.text = [timearray objectAtIndex:0];
            _secondsTextField.text = [timearray objectAtIndex:1];
        } else {
            _minutesTextField.text = @"00";
            _secondsTextField.text = @"00";
        }
        
        _deleteButton.hidden = NO;
        _deleteButton.enabled = YES;
    } else {
        _playerTextField.text = @"";
        _minutesTextField.text = @"00";
        _secondsTextField.text = @"00";
        _yellowcardTextField.text = @"";
        _redcardTextField.text = @"";
        _deleteButton.hidden = YES;
        _deleteButton.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _pickerView.delegate = nil;
    _pickerView.dataSource = nil;
}

- (IBAction)periodSegmentedControlClicked:(id)sender {
}

- (IBAction)submitButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statSaved:) name:@"SoccerStatNotification" object:nil];
    
    if (((player) || (visitingplayer)) && ((redcard.length > 0) || (yellowcard.length > 0))) {
        SoccerStat *soccerstat;
        
        if (visitor)
            soccerstat = [visitingplayer getSoccerGameStat:game.soccer_game.soccer_game_id];
        else
            soccerstat = [player getSoccerGameStat:game.soccer_game.soccer_game_id];
        
        if (!penalty) {
            penalty = [[SoccerPenalty alloc] init];

            if (visitor) {
                penalty.visitor_roster_id = visitingplayer.visitor_roster_id;
                penalty.soccer_stat_id = soccerstat.soccer_stat_id;
            } else {
                penalty.athlete_id = player.athleteid;
                penalty.soccer_stat_id = soccerstat.soccer_stat_id;
            }
        }
        
        penalty.gametime = [_minutesTextField.text stringByAppendingFormat:@":%@", _secondsTextField.text];
        penalty.period = [NSNumber numberWithLong:_periodSegmentedControl.selectedSegmentIndex + 1];
        penalty.card = (yellowcard.length > 0) ? @"Y" : @"R";
        penalty.infraction = (yellowcard.length > 0) ? yellowcard : redcard;        
        [soccerstat savePenaltyStat:game.id PenaltyStat:penalty];
    }
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// Method to define the numberOfRows in a component using the array.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component {
    if ([pickertype isEqualToString:@"player"]) {
        if (visitor)
            return [currentSettings findVisitingTeam:game.soccer_game.visiting_team_id].visitor_roster.count;
        else
            return currentSettings.roster.count;
    } else if ([pickertype isEqualToString:@"yellowcard"]) {
        return currentSettings.sport.soccer_yellowcard.count;
    } else {
        return  currentSettings.sport.soccer_redcard.count;
    }
}

// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickertype isEqualToString:@"player"]) {
        if (visitor)
            return [[[currentSettings findVisitingTeam:game.soccer_game.visiting_team_id].visitor_roster objectAtIndex:row] numberLogname];
        else
            return [[currentSettings.roster objectAtIndex:row] numberLogname];
    } else if ([pickertype isEqualToString:@"yellowcard"]) {
        return [yellowarray objectAtIndex:row];
    } else {
        return [redarray objectAtIndex:row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickertype isEqualToString:@"player"]) {
        if (visitor) {
            visitingplayer = [[currentSettings findVisitingTeam:game.soccer_game.visiting_team_id].visitor_roster objectAtIndex:row];
            
            _playerTextField.text = visitingplayer.numberlogname;
        } else {
            player = [currentSettings.roster objectAtIndex:row];
            _playerTextField.text = player.numberLogname;
        }
    } else if ([pickertype isEqualToString:@"yellowcard"]) {
        _yellowcardTextField.text = [yellowarray objectAtIndex:row];
        yellowcard = [currentSettings.sport.soccer_yellowcard objectForKey:[yellowarray objectAtIndex:row]];
    } else {
        _redcardTextField.text = [redarray objectAtIndex:row];
        redcard = [currentSettings.sport.soccer_redcard objectForKey:[redarray objectAtIndex:row]];
    }
    
    _pickerView.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _yellowcardTextField) {
        _redcardTextField.text = @"";
        redcard = @"";
        pickertype = @"yellowcard";
    } else if (textField == _redcardTextField) {
        _yellowcardTextField.text = @"";
        yellowcard = @"";
        pickertype = @"redcard";
    } else if ((textField == _minutesTextField) || (textField == _secondsTextField))
        textField.text = @"";
    else
        pickertype = @"player";
    
    if ((textField == _playerTextField) || (textField == _yellowcardTextField) || (textField == _redcardTextField)) {
        [_pickerView reloadAllComponents];
        _pickerView.hidden = NO;
        [textField resignFirstResponder];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ((textField == _minutesTextField) || (textField == _secondsTextField)) {
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)deleteButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statSaved:) name:@"SoccerStatNotification" object:nil];
    SoccerStat * stat = [player getSoccerGameStat:game.soccer_game.soccer_game_id];
    [stat deletePenaltyStat:game.id PenaltyStat:penalty];
}

@end
