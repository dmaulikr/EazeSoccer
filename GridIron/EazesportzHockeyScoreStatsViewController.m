//
//  EazesportzHockeyScoreStatsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 9/15/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzHockeyScoreStatsViewController.h"

#import "EazesportzAppDelegate.h"

@interface EazesportzHockeyScoreStatsViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation EazesportzHockeyScoreStatsViewController {
    BOOL scoreplayer;
    Athlete *assistplayer, *player;
}

@synthesize game;
@synthesize score;

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
    scoreplayer = YES;
    _playerPicker.hidden = YES;
    _playerPicker.dataSource = self;
    _playerPicker.delegate = self;
    
    [_periodSegmentedControl setSelectedSegmentIndex:[game.period intValue] - 1];
    
    if (score) {
        player = [currentSettings findAthlete:score.athlete_id];
        _playerTextField.text = player.logname;
        _assistTextField.text = [[currentSettings findAthlete:score.assist] logname];
        
        NSArray *timearray = [score.gametime componentsSeparatedByString:@":"];
        
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
        _assistTextField.text = @"";
        _minutesTextField.text = @"00";
        _secondsTextField.text = @"00";
        _deleteButton.hidden = YES;
        _deleteButton.enabled = NO;
        assistplayer = player = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _playerPicker.delegate = nil;
    _playerPicker.dataSource = nil;
}

- (IBAction)submitButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statSaved:) name:@"HockeyStatNotification" object:nil];
    HockeyStat *stat;
    
    stat = [player findHockeyStat:game];
    
    if (!score) {
        score = [[HockeyScoring alloc] init];
        
        score.athlete_id = player.athleteid;
        score.hockey_stat_id = stat.hockey_stat_id;
    }
    
    score.assist = assistplayer.athleteid;
    score.gametime = [_minutesTextField.text stringByAppendingFormat:@":%@", _secondsTextField.text];
    score.period = [NSNumber numberWithLong:_periodSegmentedControl.selectedSegmentIndex + 1];
    [stat saveScoreStat:game.id Score:score];
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

- (IBAction)deleteButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statSaved:) name:@"HockeyStatNotification" object:nil];
    HockeyStat *stat = [player findHockeyStat:game];
    [stat deleteScoreStat:game.id Score:score];
}

- (IBAction)periodSegmentedControlClicked:(id)sender {
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// Method to define the numberOfRows in a component using the array.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component {
    return currentSettings.roster.count;
}

// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[currentSettings.roster objectAtIndex:row] numberLogname];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (scoreplayer) {
        player = [currentSettings.roster objectAtIndex:row];
        _playerTextField.text = player.numberLogname;
    } else {
        assistplayer = [currentSettings.roster objectAtIndex:row];
        _assistTextField.text = player.numberLogname;
    }
    
    _playerPicker.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _playerTextField)
        scoreplayer = YES;
    else if (textField == _assistTextField)
        scoreplayer = NO;
    
    if ((textField == _playerTextField) || (textField == _assistTextField)) {
        [_playerPicker reloadAllComponents];
        _playerPicker.hidden = NO;
        [textField resignFirstResponder];
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

@end
