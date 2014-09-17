//
//  EazesportzHockeyPlayerStatsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 9/14/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzHockeyPlayerStatsViewController.h"

#import "EazesportzAppDelegate.h"

@interface EazesportzHockeyPlayerStatsViewController ()

@end

@implementation EazesportzHockeyPlayerStatsViewController {
    HockeyStat *stats;
    HockeyPlayerStat *playerstats;
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
    
    stats = [player findHockeyStat:game];
    _periodSegmentedControl.selectedSegmentIndex = [game.period intValue];
    playerstats = [stats findPlayerStat:[NSNumber numberWithInt:[game.period intValue]]];
    _shotsTextField.text = [playerstats.shots stringValue];
    _blockedShotsTextField.text = [playerstats.blockedshots stringValue];
    _plusminusTextField.text = [playerstats.plusminus stringValue];
    _hitsTextField.text = [playerstats.hits stringValue];
    _faceoffwonTextField.text = [playerstats.faceoffwon stringValue];
    _faceofflostTextField.text = [playerstats.faceofflost stringValue];
    
    NSArray *timearray = [playerstats.timeonice componentsSeparatedByString:@":"];
    _timeoniceMinutesTextField.text = timearray[0];
    _timeoniceSecondsTimeTextField.text = timearray[1];
}

- (IBAction)periodSegmentedControlClicked:(id)sender {
    playerstats = [stats findPlayerStat:[NSNumber numberWithLong:(_periodSegmentedControl.selectedSegmentIndex + 1)]];
}

- (IBAction)submitButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statSaved:) name:@"HockeyStatNotification" object:nil];
    playerstats.shots = [NSNumber numberWithInt:[_shotsTextField.text intValue]];
    playerstats.blockedshots = [NSNumber numberWithInt:[_blockedShotsTextField.text intValue]];
    playerstats.hits = [NSNumber numberWithInt:[_hitsTextField.text intValue]];
    playerstats.plusminus = [NSNumber numberWithInt:[_plusminusTextField.text intValue]];
    playerstats.faceoffwon = [NSNumber numberWithInt:[_faceoffwonTextField.text intValue]];
    playerstats.faceofflost = [NSNumber numberWithInt:[_faceofflostTextField.text intValue]];
    playerstats.timeonice = [_timeoniceMinutesTextField.text stringByAppendingFormat:@":%@", _timeoniceSecondsTimeTextField.text];
    playerstats.period = [NSNumber numberWithLong:_periodSegmentedControl.selectedSegmentIndex + 1];
    [[player findHockeyStat:game] savePlayerStat:game.id PlayerStat:playerstats];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = @"";
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

@end
