//
//  UpdateSoccerTotalsViewController.m
//  EazeSportz
//
//  Created by Gil on 11/5/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "UpdateSoccerTotalsViewController.h"

@interface UpdateSoccerTotalsViewController ()

@end

@implementation UpdateSoccerTotalsViewController

@synthesize soccerstats;
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
    
    _minutesPlayedTextField.text = [soccerstats.minutesplayed stringValue];
    _goalsTextField.text = [soccerstats.goals stringValue];
    _shotsTextField.text = [soccerstats.shotstaken stringValue];
    _assistsTextField.text = [soccerstats.assists stringValue];
    _stealsTextField.text = [soccerstats.steals stringValue];
    _goalsagainstTextField.text = [soccerstats.goalsagainst stringValue];
    _savesTextField.text = [soccerstats.goalssaved stringValue];
    _cornerkickTextField.text = [soccerstats.cornerkicks stringValue];
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
    }
}

@end
