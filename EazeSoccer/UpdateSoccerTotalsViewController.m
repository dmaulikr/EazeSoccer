//
//  UpdateSoccerTotalsViewController.m
//  EazeSportz
//
//  Created by Gil on 11/5/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "UpdateSoccerTotalsViewController.h"

#import "EazesportzAppDelegate.h"
#import "EazeSoccerStatsViewController.h"

@interface UpdateSoccerTotalsViewController ()

@end

@implementation UpdateSoccerTotalsViewController

@synthesize soccerstats;
@synthesize player;
@synthesize game;

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
    _goalsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _goalsagainstTextField.keyboardType = UIKeyboardTypeNumberPad;
    _shotsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _assistsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _minutesPlayedTextField.keyboardType = UIKeyboardTypeNumberPad;
    _stealsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _savesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _cornerkickTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _playerImage.image = [currentSettings getRosterThumbImage:player];
    soccerstats = [player findSoccerGameStats:game.id];
    
    _minutesPlayedTextField.text = [soccerstats.minutesplayed stringValue];
    _goalsTextField.text = [soccerstats.goals stringValue];
    _shotsTextField.text = [soccerstats.shotstaken stringValue];
    _assistsTextField.text = [soccerstats.assists stringValue];
    _stealsTextField.text = [soccerstats.steals stringValue];
    _goalsagainstTextField.text = [soccerstats.goalsagainst stringValue];
    _savesTextField.text = [soccerstats.goalssaved stringValue];
    _cornerkickTextField.text = [soccerstats.cornerkicks stringValue];
    
    _pointsLabel.text = [NSString stringWithFormat:@"%d", ([soccerstats.goals intValue] * 2) + [soccerstats.assists intValue]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (_submitButton.touchInside) {
        soccerstats.minutesplayed = [NSNumber numberWithInt:[_minutesPlayedTextField.text intValue]];
        soccerstats.goals = [NSNumber numberWithInt:[_goalsTextField.text intValue]];
        soccerstats.goalsagainst = [NSNumber numberWithInt:[_goalsagainstTextField.text intValue]];
        soccerstats.goalssaved = [NSNumber numberWithInt:[_savesTextField.text intValue]];
        soccerstats.assists = [NSNumber numberWithInt:[_assistsTextField.text intValue]];
        soccerstats.steals = [NSNumber numberWithInt:[_stealsTextField.text intValue]];
        soccerstats.shotstaken = [NSNumber numberWithInt:[_shotsTextField.text intValue]];
        soccerstats.cornerkicks = [NSNumber numberWithInt:[_cornerkickTextField.text intValue]];
    } else if ([segue.identifier isEqualToString:@"SoccerTotalsSegue"]) {
        EazeSoccerStatsViewController *destController = segue.destinationViewController;
        destController.athlete = player;
    }
}

- (IBAction)saveBarButtonClicked:(id)sender {
    soccerstats.minutesplayed = [NSNumber numberWithInt:[_minutesPlayedTextField.text intValue]];
    soccerstats.goals = [NSNumber numberWithInt:[_goalsTextField.text intValue]];
    soccerstats.goalsagainst = [NSNumber numberWithInt:[_goalsagainstTextField.text intValue]];
    soccerstats.goalssaved = [NSNumber numberWithInt:[_savesTextField.text intValue]];
    soccerstats.assists = [NSNumber numberWithInt:[_assistsTextField.text intValue]];
    soccerstats.steals = [NSNumber numberWithInt:[_stealsTextField.text intValue]];
    soccerstats.shotstaken = [NSNumber numberWithInt:[_shotsTextField.text intValue]];
    soccerstats.cornerkicks = [NSNumber numberWithInt:[_cornerkickTextField.text intValue]];
    
    [soccerstats saveStats];
    [player updateSoccerGameStats:soccerstats];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Soccer stats updated!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
    NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
    
    if (myStringMatchesRegEx) {
        return YES;
    } else
        return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textFied {
    textFied.text = @"";
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
