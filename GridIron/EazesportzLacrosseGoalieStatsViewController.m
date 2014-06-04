//
//  EazesportzLacrosseGoalieStatsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/2/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzLacrosseGoalieStatsViewController.h"
#import "EazesportzAppDelegate.h"

@interface EazesportzLacrosseGoalieStatsViewController ()

@end

@implementation EazesportzLacrosseGoalieStatsViewController {
    NSArray *periodarray;
    Lacrosstat *stats;
}

@synthesize game;
@synthesize visitingPlayer;
@synthesize player;

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
    _savesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _decisionsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _minutesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _goalsagainstTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    periodarray = [[currentSettings.sport.lacrosse_periods allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[currentSettings.sport.lacrosse_periods objectForKey:obj1] compare:[currentSettings.sport.lacrosse_periods objectForKey:obj2]];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _pickerView.hidden = YES;
    
    if (visitingPlayer) {
        stats = [visitingPlayer findLacrossStat:game];
        _playerLabel.text = visitingPlayer.numberlogname;
    } else {
        stats = [player findLacrosstat:game];
        _playerLabel.text = player.numberLogname;
    }
    
    _decisionsTextField.text = @"0";
    _goalsagainstTextField.text = @"0";
    _savesTextField.text = @"0";
    _minutesTextField.text = @"0";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveButtonClicked:(id)sender {
    if (_periodTextField.text.length > 0) {
        LacrossGoalstat *goalstat;
        
        if ([stats hasGoalieStatPeriod:[NSNumber numberWithInt:[_periodTextField.text intValue]]]) {
            goalstat = [stats.goalstats objectAtIndex:[_periodTextField.text intValue] - 1];
        } else {
            goalstat = [[LacrossGoalstat alloc] init];
            goalstat.period = [NSNumber numberWithInt:[_periodTextField.text intValue]];
            goalstat.lacrosstat_id = stats.lacrosstat_id;
            
            if (visitingPlayer)
                goalstat.visitor_roster_id = visitingPlayer.visitor_roster_id;
            else
                goalstat.athlete_id = player.athleteid;
            
            [stats.goalstats addObject:goalstat];
        }
        
        goalstat.minutesplayed = [NSNumber numberWithInt:[_minutesTextField.text intValue]];
        goalstat.goals_allowed = [NSNumber numberWithInt:[_goalsagainstTextField.text intValue]];
        goalstat.saves = [NSNumber numberWithInt:[_savesTextField.text intValue]];
        [goalstat save:currentSettings.sport Team:currentSettings.team Game:game User:currentSettings.user];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// Method to define the numberOfRows in a component using the array.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component {
    return periodarray.count;
}

// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [periodarray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _periodTextField.text = [periodarray objectAtIndex:row];
    _pickerView.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _periodTextField) {
        [_pickerView reloadAllComponents];
        _pickerView.hidden = NO;
        [textField resignFirstResponder];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField != _periodTextField) {
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

@end
