//
//  EazesportzWaterPoloPlayerStatsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/22/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzWaterPoloPlayerStatsViewController.h"

@interface EazesportzWaterPoloPlayerStatsViewController ()

@end

@implementation EazesportzWaterPoloPlayerStatsViewController {
    WaterPoloPlayerstat *stats;
    UITextField *lastTextField;
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
    
    _shotsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _stealsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _foulsTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_periodSegmentedControl setSelectedSegmentIndex:[game.period intValue] - 1];
    
    [self getPlayerStats];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [lastTextField resignFirstResponder];
}

- (void)getPlayerStats {
    NSNumber *period = [NSNumber numberWithInteger:_periodSegmentedControl.selectedSegmentIndex + 1];
    
    stats = [[player findWaterPoloStat:game] findPlayerStat:period];
    _shotsTextField.text = [stats.shots stringValue];
    _stealsTextField.text = [stats.steals stringValue];
    _foulsTextField.text = [stats.fouls stringValue];
}

- (IBAction)periodSegmentedControlClicked:(id)sender {
    [self getPlayerStats];
}

- (IBAction)submitButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statSaved:) name:@"WaterpoloStatNotification" object:nil];
    stats.shots = [NSNumber numberWithInt:[_shotsTextField.text intValue]];
    stats.steals = [NSNumber numberWithInt:[_stealsTextField.text intValue]];
    stats.fouls = [NSNumber numberWithInt:[_foulsTextField.text intValue]];
    stats.period = [NSNumber numberWithLong:_periodSegmentedControl.selectedSegmentIndex + 1];
    [[player findWaterPoloStat:game] savePlayerStat:game.id PlayerStat:stats];
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
    if ((textField == _shotsTextField) || (_stealsTextField) ||
        (_foulsTextField)) {
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    lastTextField = textField;
}

@end
