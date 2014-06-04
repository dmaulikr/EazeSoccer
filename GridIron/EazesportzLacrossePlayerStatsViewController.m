//
//  EazesportzLacrossePlayerStatsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/1/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzLacrossePlayerStatsViewController.h"
#import "EazesportzAppDelegate.h"

@interface EazesportzLacrossePlayerStatsViewController ()

@end

@implementation EazesportzLacrossePlayerStatsViewController {
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
    _groundBallTextField.keyboardType = UIKeyboardTypeNumberPad;
    _turnoverTextField.keyboardType = UIKeyboardTypeNumberPad;
    _causedTurnoverTextField.keyboardType = UIKeyboardTypeNumberPad;
    _stealsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _faceoffwonTextField.keyboardType = UIKeyboardTypeNumberPad;
    _faceofflostTextField.keyboardType = UIKeyboardTypeNumberPad;

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
    
    _groundBallTextField.text = @"0";
    _turnoverTextField.text = @"0";
    _causedTurnoverTextField.text = @"0";
    _stealsTextField.text = @"0";
    _faceoffwonTextField.text = @"0";
    _faceofflostTextField.text = @"0";
    _faceoffviolationTextField.text = @"0";
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
        LacrossPlayerStat *playerstat;
        
        if ([stats hasPlayerStatPeriod:[NSNumber numberWithInt:[_periodTextField.text intValue]]]) {
            playerstat = [stats.player_stats objectAtIndex:[_periodTextField.text intValue] - 1];
        } else {
            playerstat = [[LacrossPlayerStat alloc] init];
            playerstat.period = [NSNumber numberWithInt:[_periodTextField.text intValue]];
            playerstat.lacrosstat_id = stats.lacrosstat_id;
            
            if (visitingPlayer)
                playerstat.visitor_roster_id = visitingPlayer.visitor_roster_id;
            else
                playerstat.athlete_id = player.athleteid;
            
            [stats.player_stats addObject:playerstat];
        }
        
        playerstat.ground_ball = [NSNumber numberWithInt:[playerstat.ground_ball intValue] +
                                  [_groundBallTextField.text intValue]];
        playerstat.turnover =[NSNumber numberWithInt:[playerstat.turnover intValue] +
                              [_turnoverTextField.text intValue]];
        playerstat.caused_turnover =[NSNumber numberWithInt:[playerstat.caused_turnover intValue] +
                              [_causedTurnoverTextField.text intValue]];
        playerstat.steals =[NSNumber numberWithInt:[playerstat.steals intValue] +
                                     [_stealsTextField.text intValue]];
        playerstat.face_off_won =[NSNumber numberWithInt:[playerstat.face_off_won intValue] +
                                     [_faceoffwonTextField.text intValue]];
        playerstat.face_off_lost =[NSNumber numberWithInt:[playerstat.face_off_lost intValue] +
                                     [_faceofflostTextField.text intValue]];
        playerstat.face_off_violation =[NSNumber numberWithInt:[playerstat.face_off_violation intValue] +
                                     [_faceoffviolationTextField.text intValue]];
        [playerstat save:currentSettings.sport Team:currentSettings.team Game:game User:currentSettings.user];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Period required!" delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
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
