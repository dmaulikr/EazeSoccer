//
//  EazesportzLacrossePenaltyViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/29/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzLacrossePenaltyViewController.h"

#import "EazesportzAppDelegate.h"

@interface EazesportzLacrossePenaltyViewController ()

@end

@implementation EazesportzLacrossePenaltyViewController {
    NSArray *periodarray;
    NSString *pickertype;
    VisitingTeam *visitors;
}

@synthesize game;
@synthesize visitingTeam;
@synthesize penatlyStat;
@synthesize player;
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
    periodarray = [[currentSettings.sport.lacrosse_periods allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[currentSettings.sport.lacrosse_periods objectForKey:obj1] compare:[currentSettings.sport.lacrosse_periods objectForKey:obj2]];
    }];
    
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
    
    visitors = [currentSettings findVisitingTeam:game.lacross_game.visiting_team_id];
    _pickerView.hidden = YES;
    pickertype = @"Player";
    
    if (penatlyStat) {
        if ([penatlyStat.type isEqualToString:@"T"])
            _technicalFoulTextField.text = penatlyStat.infraction;
        else
            _personalFoulTextField.text = penatlyStat.infraction;
        
        _periodTextField.text = [penatlyStat.period stringValue];
        NSArray *timearray = [penatlyStat.gametime componentsSeparatedByString:@":"];
        _minutesTextField.text = timearray[0];
        _secondsTextField.text = timearray[1];
        
        if (penatlyStat.athlete_id)
            _playerTextField.text = [[currentSettings findAthlete:penatlyStat.athlete_id] numberLogname];
        else
            _playerTextField.text = [[visitors findAthlete:penatlyStat.visitor_roster_id] numberlogname];
    } else {
        penatlyStat = [[LacrossPenalty alloc] init];
    }
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _playerTextField) {
        pickertype = @"Player";
        [_pickerView reloadAllComponents];
        _pickerView.hidden = NO;
        [textField resignFirstResponder];
    } else if (textField == _personalFoulTextField) {
        pickertype = @"Personal";
        [_pickerView reloadAllComponents];
        _pickerView.hidden = NO;
        [textField resignFirstResponder];
    } else if (textField == _technicalFoulTextField) {
        pickertype = @"Technical";
        [_pickerView reloadAllComponents];
        _pickerView.hidden = NO;
        [textField resignFirstResponder];
    } else if (textField == _periodTextField) {
        pickertype = @"Period";
        [_pickerView reloadAllComponents];
        _pickerView.hidden = NO;
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
    if ((visitingTeam) && ([pickertype isEqualToString:@"Player"])) {
        return visitors.visitor_roster.count;
    } else if ([pickertype isEqualToString:@"Player"]) {
        return currentSettings.roster.count;
    } else if ([pickertype isEqualToString:@"Period"]) {
        return periodarray.count;
    } else if ([pickertype isEqualToString:@"Personal"]) {
        return  currentSettings.sport.lacrosse_personal_fouls.count;
    } else {
        return currentSettings.sport.lacrosse_technical_fouls.count;
    }
}

// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ((visitingTeam) && ([pickertype isEqualToString:@"Player"]))
        return [[visitors.visitor_roster objectAtIndex:row] numberLogname];
    else if ([pickertype isEqualToString:@"Player"])
        return [[currentSettings.roster objectAtIndex:row] numberLogname];
    else if ([pickertype isEqualToString:@"Period"])
        return [periodarray objectAtIndex:row];
    else if ([pickertype isEqualToString:@"Personal"])
        return [currentSettings.sport.lacrosse_personal_fouls objectAtIndex:row];
    else
        return [currentSettings.sport.lacrosse_technical_fouls objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickertype isEqualToString:@"Player"]) {
        if (visitingTeam) {
            visitor = [visitors.visitor_roster objectAtIndex:row];
            _playerTextField.text = visitor.numberlogname;
            penatlyStat.visitor_roster_id = visitor.visitor_roster_id;
        } else {
            player = [currentSettings.roster objectAtIndex:row];
            _playerTextField.text = player.numberLogname;
            penatlyStat.athlete_id = player.athleteid;
        }
    } else if ([pickertype isEqualToString:@"Personal"]){
        _personalFoulTextField.text = [currentSettings.sport.lacrosse_personal_fouls objectAtIndex:row];
        penatlyStat.infraction = [currentSettings.sport.lacrosse_personal_fouls objectAtIndex:row];
        penatlyStat.type = @"P";
        _technicalFoulTextField.text = @"";
    } else if ([pickertype isEqualToString:@"Technical"]) {
        _technicalFoulTextField.text = [currentSettings.sport.lacrosse_technical_fouls objectAtIndex:row];
        penatlyStat.infraction = [currentSettings.sport.lacrosse_technical_fouls objectAtIndex:row];
        penatlyStat.type = @"T";
        _personalFoulTextField.text = @"";
    } else {
        _periodTextField.text = [periodarray objectAtIndex:row];
        penatlyStat.period = [currentSettings.sport.lacrosse_periods objectForKey:_periodTextField.text];
    }
    
    _pickerView.hidden = YES;
}

@end
