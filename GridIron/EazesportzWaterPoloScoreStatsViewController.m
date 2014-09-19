//
//  EazesportzWaterPoloScoreStatsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/22/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzWaterPoloScoreStatsViewController.h"
#import "EazesportzAppDelegate.h"
#import "VisitorRoster.h"

@interface EazesportzWaterPoloScoreStatsViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation EazesportzWaterPoloScoreStatsViewController {
    BOOL scoreplayer;
    VisitorRoster *visitingplayer, *assistvisiting;
    Athlete *player, *assistplayer;
}

@synthesize game;
@synthesize score;
@synthesize visitor;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    scoreplayer = YES;
    _pickerView.hidden = YES;
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    
    [_periodSegmentControl setSelectedSegmentIndex:[game.period intValue] - 1];
    
    if (score) {
        if (visitor) {
            visitingplayer = [[currentSettings findVisitingTeam:game.soccer_game.visiting_team_id] findAthlete:score.athlete_id];
            player = nil;
            _playerTextField.text = visitingplayer.logname;
            _assistsTextField.text = [[[currentSettings findVisitingTeam:game.soccer_game.visiting_team_id] findAthlete:score.assist] logname];
        } else {
            player = [currentSettings findAthlete:score.athlete_id];
            visitingplayer = nil;
            _playerTextField.text = player.logname;
            _assistsTextField.text = [[currentSettings findAthlete:score.assist] logname];
        }
        
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
        _assistsTextField.text = @"";
        _minutesTextField.text = @"00";
        _secondsTextField.text = @"00";
        _deleteButton.hidden = YES;
        _deleteButton.enabled = NO;
        assistplayer = player = nil;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _pickerView.delegate = nil;
    _pickerView.dataSource = nil;
}

- (IBAction)periodSegmentControlClicked:(id)sender {
}

- (IBAction)submitButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statSaved:) name:@"WaterpoloStatNotification" object:nil];
    WaterPoloStat *polostat;
    
    if (visitor) {
        polostat = [visitingplayer findWaterPoloStat:game];
    } else {
        polostat = [player findWaterPoloStat:game];
    }
    
    if (!score) {
        score = [[WaterPoloScoring alloc] init];
        
        if (visitor) {
            score.visitor_roster_id = visitingplayer.visitor_roster_id;
            score.waterpolo_scoring_id = polostat.waterpolo_stat_id;
        } else {
            score.athlete_id = player.athleteid;
            score.waterpolo_stat_id = polostat.waterpolo_stat_id;
        }
    }
    
    if ((_assistsTextField.text.length > 0) && (visitor))
        score.assist = assistvisiting.visitor_roster_id;
    else
        score.assist = assistplayer.athleteid;
    
    score.gametime = [_minutesTextField.text stringByAppendingFormat:@":%@", _secondsTextField.text];
    score.period = [NSNumber numberWithLong:_periodSegmentControl.selectedSegmentIndex + 1];
    [polostat saveScoreStat:game.id Score:score];
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
    if (visitor) {
        if (scoreplayer) {
            visitingplayer = [[currentSettings findVisitingTeam:game.soccer_game.visiting_team_id].visitor_roster objectAtIndex:row];
            _playerTextField.text = visitingplayer.numberlogname;
        } else {
            assistvisiting = [[currentSettings findVisitingTeam:game.soccer_game.visiting_team_id].visitor_roster objectAtIndex:row];
            _assistsTextField.text = visitingplayer.numberlogname;
        }
    } else {
        if (scoreplayer) {
            player = [currentSettings.roster objectAtIndex:row];
            _playerTextField.text = player.numberLogname;
        } else {
            assistplayer = [currentSettings.roster objectAtIndex:row];
            _assistsTextField.text = player.numberLogname;
        }
    }
    
    _pickerView.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _playerTextField)
        scoreplayer = YES;
    else if (textField == _assistsTextField)
        scoreplayer = NO;

    if ((textField == _playerTextField) || (textField == _assistsTextField)) {
        [_pickerView reloadAllComponents];
        _pickerView.hidden = NO;
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

- (IBAction)deleteButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statSaved:) name:@"WaterpoloStatNotification" object:nil];
    WaterPoloStat *stat = [player findWaterPoloStat:game];
    [stat deleteScoreStat:game.id Score:score];
}

@end
