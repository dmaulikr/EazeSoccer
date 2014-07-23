//
//  EazesportzSoccerSubStatsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/12/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzSoccerSubStatsViewController.h"
#import "EazesportzAppDelegate.h"

@interface EazesportzSoccerSubStatsViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation EazesportzSoccerSubStatsViewController {
    VisitorRoster *inVisitorPlayer, *outVisitorPlayer;
    Athlete *inPlayer, *outPlayer;
    BOOL playerin;
}

@synthesize game;
@synthesize visitor;
@synthesize subentry;

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
    playerin = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _pickerView.hidden = YES;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    [_periodSegmentedControl setSelectedSegmentIndex:[game.period intValue] - 1];
    
    if (subentry) {
        if (visitor) {
            _inplayerTextField.text = [[[currentSettings findVisitingTeam:game.soccer_game.visiting_team_id] findAthlete:subentry.inplayer] logname];
        } else {
            _inplayerTextField.text = [[currentSettings findAthlete:subentry.inplayer] logname];
        }
        
        if (visitor) {
            _outplayerTextField.text = [[[currentSettings findVisitingTeam:game.soccer_game.visiting_team_id] findAthlete:subentry.outplayer] logname];
        } else {
            _outplayerTextField.text = [[currentSettings findAthlete:subentry.outplayer] logname];
        }
        
        NSArray *timearray = [subentry.gametime componentsSeparatedByString:@":"];
        
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
        _inplayerTextField.text = @"";
        _outplayerTextField.text = @"";
        _minutesTextField.text = @"00";
        _secondsTextField.text = @"00";
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
    
    if (((inPlayer.athleteid.length > 0) && (outPlayer.athleteid.length > 0)) ||
        ((inVisitorPlayer.visitor_roster_id.length > 0) && (outVisitorPlayer.visitor_roster_id.length > 0))) {
        if (!subentry) {
            subentry = [[SoccerSubs alloc] init];
            subentry.soccer_game_id = game.soccer_game.soccer_game_id;
        }
        
        subentry.gametime = [_minutesTextField.text stringByAppendingFormat:@":%@", _secondsTextField.text];
        
        if (visitor) {
            subentry.inplayer = inVisitorPlayer.visitor_roster_id;
            subentry.outplayer = outVisitorPlayer.visitor_roster_id;
            subentry.home = NO;
        } else {
            subentry.inplayer = inPlayer.athleteid;
            subentry.outplayer = outPlayer.athleteid;
            subentry.home = YES;
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statSaved:) name:@"SoccerGameStatNotification" object:nil];
    [game.soccer_game saveSub:subentry];
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
    if (visitor)
        return [currentSettings findVisitingTeam:game.soccer_game.visiting_team_id].visitor_roster.count;
    else
        return currentSettings.roster.count;
}

// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (visitor)
        return [[[currentSettings findVisitingTeam:game.soccer_game.visiting_team_id].visitor_roster objectAtIndex:row] numberLogname];
    else
        return [[currentSettings.roster objectAtIndex:row] numberLogname];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ((visitor) && (playerin)) {
        inVisitorPlayer = [[currentSettings findVisitingTeam:game.soccer_game.soccer_game_id].visitor_roster objectAtIndex:row];
        _inplayerTextField.text = inVisitorPlayer.numberlogname;
    } else if ((visitor) && (!playerin)) {
        outVisitorPlayer = [[currentSettings findVisitingTeam:game.soccer_game.soccer_game_id].visitor_roster objectAtIndex:row];
        _inplayerTextField.text = outVisitorPlayer.numberlogname;
    } else if (playerin) {
        inPlayer = [currentSettings.roster objectAtIndex:row];
        _inplayerTextField.text = inPlayer.logname;
    } else {
        outPlayer = [currentSettings.roster objectAtIndex:row];
        _outplayerTextField.text = outPlayer.logname;
    }
    
    _pickerView.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ((textField == _inplayerTextField) || (textField == _outplayerTextField)) {
        [_pickerView reloadAllComponents];
        _pickerView.hidden = NO;
        [textField resignFirstResponder];
    }
    
    if (textField == _inplayerTextField) {
        playerin = YES;
    } else if (textField == _outplayerTextField) {
        playerin = NO;
    } else if ((textField == _minutesTextField) || (textField == _secondsTextField))
        textField.text = @"";
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statSaved:) name:@"SoccerGameStatNotification" object:nil];
    [game.soccer_game deleteSub:subentry];
}

@end
