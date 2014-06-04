//
//  EazesportzLacrosseScoreEntryViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/28/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzLacrosseScoreEntryViewController.h"
#import "EazesportzAppDelegate.h"

@interface EazesportzLacrosseScoreEntryViewController ()

@end

@implementation EazesportzLacrosseScoreEntryViewController {
    VisitingTeam *visitors;
    Athlete *assistplayer;
    VisitorRoster *visitorassist;
    NSString *pickertype;
    NSArray *scorecodearray, *periodarray;
}

@synthesize game;
@synthesize visitingTeam;
@synthesize scorestat;
@synthesize athlete;
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
    scorecodearray = [currentSettings.sport.lacrosse_score_codes allKeys];
    
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
    
    if (scorestat) {
        NSArray *timearray = [scorestat.gametime componentsSeparatedByString:@":"];
        _minutesTextField.text = timearray[0];
        _secondsTextField.text = timearray[1];
        _periodTextField.text = [currentSettings.sport.lacrosse_periods objectForKey:[scorestat.period stringValue]];
        _scorecodeTextField.text = [currentSettings.sport.lacrosse_score_codes allKeysForObject:scorestat.scorecode][0];
        _playergoalTextField.text = visitingTeam ? [[visitors findAthlete:scorestat.visitor_roster_id] numberlogname]:
                                                    [[currentSettings findAthlete:scorestat.athlete_id] numberLogname];
        
        if (scorestat.assist.length > 0) {
            _playerassistTextField.text = visitingTeam ? [[visitors findAthlete:scorestat.visitor_roster_id] numberlogname] :
                                                [[currentSettings findAthlete:scorestat.athlete_id] numberLogname];
            
        }
        
        if (visitingTeam)
            visitor = [visitors findAthlete:scorestat.visitor_roster_id];
        else
            athlete = [currentSettings findAthlete:scorestat.athlete_id];
    } else
        scorestat = [[LacrossScoring alloc] init];
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

//Method to define how many columns/dials to show
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// Method to define the numberOfRows in a component using the array.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component {
    if ((visitingTeam) && (([pickertype isEqualToString:@"Player"]) || ([pickertype isEqualToString:@"Assist"]))) {
        return visitors.visitor_roster.count;
    } else if (([pickertype isEqualToString:@"Player"]) || ([pickertype isEqualToString:@"Assist"])) {
        return currentSettings.roster.count;
    } else if ([pickertype isEqualToString:@"Scorecode"]) {
        return scorecodearray.count;
    } else {
        return periodarray.count;
    }
}

// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ((visitingTeam) && (([pickertype isEqualToString:@"Player"]) || ([pickertype isEqualToString:@"Assist"])))
        return [[visitors.visitor_roster objectAtIndex:row] numberLogname];
    else if (([pickertype isEqualToString:@"Player"]) || ([pickertype isEqualToString:@"Assist"]))
        return [[currentSettings.roster objectAtIndex:row] numberLogname];
    else if ([pickertype isEqualToString:@"Scorecode"])
        return [scorecodearray objectAtIndex:row];
    else
        return [periodarray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickertype isEqualToString:@"Assist"]) {
        if (visitingTeam) {
            visitorassist = [visitors.visitor_roster objectAtIndex:row];
            _playerassistTextField.text = visitorassist.numberlogname;
            scorestat.assist = visitorassist.visitor_roster_id;
        } else {
            assistplayer = [currentSettings.roster objectAtIndex:row];
            _playerassistTextField.text = assistplayer.numberLogname;
            scorestat.assist = assistplayer.athleteid;
        }
    } else if ([pickertype isEqualToString:@"Player"]) {
        if (visitingTeam) {
            visitor = [visitors.visitor_roster objectAtIndex:row];
            _playergoalTextField.text = visitor.numberlogname;
            scorestat.visitor_roster_id = visitor.visitor_roster_id;
        } else {
            athlete = [currentSettings.roster objectAtIndex:row];
            _playergoalTextField.text = athlete.numberLogname;
            scorestat.athlete_id = athlete.athleteid;
        }
    } else if ([pickertype isEqualToString:@"Scorecode"]){
        _scorecodeTextField.text = [scorecodearray objectAtIndex:row];
        scorestat.scorecode = [currentSettings.sport.lacrosse_score_codes objectForKey:_scorecodeTextField.text];
    } else {
        _periodTextField.text = [periodarray objectAtIndex:row];
        scorestat.period = [NSNumber numberWithInt:[[currentSettings.sport.lacrosse_periods objectForKey:_periodTextField.text] intValue]];
    }
    
    _pickerView.hidden = YES;
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _playergoalTextField) {
        pickertype = @"Player";
        [_pickerView reloadAllComponents];
        _pickerView.hidden = NO;
        [textField resignFirstResponder];
    } else if (textField == _playerassistTextField) {
        pickertype = @"Assist";
        [_pickerView reloadAllComponents];
        _pickerView.hidden = NO;
        [textField resignFirstResponder];
    } else if (textField == _scorecodeTextField) {
        pickertype = @"Scorecode";
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

@end
