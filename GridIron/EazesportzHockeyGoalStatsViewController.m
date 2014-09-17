//
//  EazesportzHockeyGoalStatsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 9/15/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzHockeyGoalStatsViewController.h"

@interface EazesportzHockeyGoalStatsViewController ()

@end

@implementation EazesportzHockeyGoalStatsViewController {
    HockeyGoalStat *stats;
}

@synthesize game;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _periodSegmentedControl.selectedSegmentIndex = [game.period intValue];
    [self getGoalieStats];
}

- (void)getGoalieStats {
    NSNumber *period = [NSNumber numberWithInteger:_periodSegmentedControl.selectedSegmentIndex - 1];
    
    stats = [[player findHockeyStat:game] findGoalStat:period];
    _savesTextField.text = [stats.saves stringValue];
    _goalsallowedTextField.text = [stats.goals_allowed stringValue];
    _minutesTextField.text = [stats.minutes_played stringValue];
}

- (IBAction)periodSegmentedControlClicked:(id)sender {
    [self getGoalieStats];
}

- (IBAction)submitButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statSaved:) name:@"HockeyStatNotification" object:nil];
    stats.saves = [NSNumber numberWithInt:[_savesTextField.text intValue]];
    stats.goals_allowed = [NSNumber numberWithInt:[_goalsallowedTextField.text intValue]];
    stats.minutes_played = [NSNumber numberWithInt:[_minutesTextField.text intValue]];
    stats.period = [NSNumber numberWithLong:_periodSegmentedControl.selectedSegmentIndex + 1];
    [[player findHockeyStat:game] saveGoalStat:game.id GoalStat:stats];
}

- (void)statSaved:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Stat Saved" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error saving stats" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

@end
