//
//  EazesportzWaterPoloGoalieStatsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/23/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzWaterPoloGoalieStatsViewController.h"

@interface EazesportzWaterPoloGoalieStatsViewController ()

@end

@implementation EazesportzWaterPoloGoalieStatsViewController {
    WaterPoloGoalstat *stats;
}

@synthesize game;
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
    
    _saveTextField.keyboardType = UIKeyboardTypeNumberPad;
    _allowedTextField.keyboardType = UIKeyboardTypeNumberPad;
    _minutesplayedTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_periodSegmentedControl setSelectedSegmentIndex:[game.period intValue] - 1];
    
    [self getGoalieStats];
}

- (void)getGoalieStats {
    NSNumber *period = [NSNumber numberWithInteger:_periodSegmentedControl.selectedSegmentIndex - 1];
    
    stats = [[player findWaterPoloStat:game] findGoalStat:period];
    _saveTextField.text = [stats.saves stringValue];
    _allowedTextField.text = [stats.goals_allowed stringValue];
    _minutesplayedTextField.text = [stats.minutes_played stringValue];
}

- (IBAction)periodSegmentedControlClicked:(id)sender {
    [self getGoalieStats];
}

- (IBAction)submitButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statSaved:) name:@"SoccerStatNotification" object:nil];
    stats.saves = [NSNumber numberWithInt:[_saveTextField.text intValue]];
    stats.goals_allowed = [NSNumber numberWithInt:[_allowedTextField.text intValue]];
    stats.minutes_played = [NSNumber numberWithInt:[_minutesplayedTextField.text intValue]];
    stats.period = [NSNumber numberWithLong:_periodSegmentedControl.selectedSegmentIndex + 1];
    [[player findWaterPoloStat:game] saveGoalStat:game.id GoalStat:stats];
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
    if ((textField == _allowedTextField) || (textField == _saveTextField) || (_minutesplayedTextField)) {
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
