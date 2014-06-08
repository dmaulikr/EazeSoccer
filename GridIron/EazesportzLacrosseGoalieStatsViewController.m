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
    LacrossGoalstat *goaliestats;
    int selectedPeriod;
}

@synthesize game;
@synthesize visitingPlayer;
@synthesize player;
@synthesize lacrosstat;

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
    
    _saveImage.hidden = YES;
    
    if (visitingPlayer) {
        stats = [visitingPlayer findLacrossStat:game];
        _goalieNavigationItem.title = visitingPlayer.numberlogname;
    } else {
        stats = [player findLacrosstat:game];
        _goalieNavigationItem.title = player.numberLogname;
    }
    
    _decisionsTextField.text = @"0";
    _goalsagainstTextField.text = @"0";
    _savesTextField.text = @"0";
    _minutesTextField.text = @"0";
    
    [_periodSegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
}

- (IBAction)saveButtonClicked:(id)sender {
    goaliestats.dirty = YES;
    goaliestats.minutesplayed = [NSNumber numberWithInt:[_minutesTextField.text intValue]];
    goaliestats.goals_allowed = [NSNumber numberWithInt:[_goalsagainstTextField.text intValue]];
    goaliestats.saves = [NSNumber numberWithInt:[_savesTextField.text intValue]];
    [stats save:currentSettings.sport Game:game User:currentSettings.user];
    _saveImage.hidden = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
    NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
    
    if (myStringMatchesRegEx)
        return YES;
    else
        return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _saveImage.hidden = YES;
}

- (IBAction)savesStepperClicked:(id)sender {
    _saveImage.hidden = YES;
    _savesTextField.text = [NSString stringWithFormat:@"%d", (int)_savesStepper.value];
}

- (IBAction)goalsagainstStepperClicked:(id)sender {
    _saveImage.hidden = YES;
    _goalsagainstTextField.text = [NSString stringWithFormat:@"%d", (int)_goalsagainstStepper.value];
}

- (IBAction)decisionsStepperClicked:(id)sender {
}

- (IBAction)minutesplayedStepperClicked:(id)sender {
    _saveImage.hidden = YES;
    _minutesTextField.text = [NSString stringWithFormat:@"%d", (int)_minutesplayedStepper.value];
}

- (IBAction)periodSegmentedControlClicked:(id)sender {
    switch (_periodSegmentedControl.selectedSegmentIndex) {
        case 0:
            selectedPeriod = 1;
            break;
            
        case 1:
            selectedPeriod = 2;
            break;
            
        case 2:
            selectedPeriod = 3;
            break;
            
        case 3:
            selectedPeriod = 4;
            break;
            
        default:
            selectedPeriod = 5;
            break;
    }
    
    [self populatePlayerStats];
}

- (void)populatePlayerStats {
    if ([stats hasGoalieStatPeriod:[NSNumber numberWithInt:selectedPeriod]]) {
        goaliestats = [stats.goalstats objectAtIndex:selectedPeriod - 1];
    } else {
        goaliestats = [[LacrossGoalstat alloc] init];
        goaliestats.period = [NSNumber numberWithInt:selectedPeriod];
        goaliestats.lacrosstat_id = stats.lacrosstat_id;
        
        if (visitingPlayer)
            goaliestats.visitor_roster_id = visitingPlayer.visitor_roster_id;
        else
            goaliestats.athlete_id = player.athleteid;
        
        [stats.goalstats addObject:goaliestats];
    }
    
    _savesTextField.text = [goaliestats.saves stringValue];
    _minutesTextField.text = [goaliestats.minutesplayed stringValue];
    _goalsagainstTextField.text = [goaliestats.goals_allowed stringValue];
}

@end
