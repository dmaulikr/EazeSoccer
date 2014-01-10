//
//  SoccerLiveClockViewController.m
//  EazeSportz
//
//  Created by Gil on 11/5/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "SoccerLiveClockViewController.h"
#import "EazesportzAppDelegate.h"

@interface SoccerLiveClockViewController ()

@end

@implementation SoccerLiveClockViewController

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
    _periodTextView.keyboardType = UIKeyboardTypeNumberPad;
    _visitorCKTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorSavesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorShotsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _minutesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _secondsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorScoreTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    NSArray *gametime = [game.currentgametime componentsSeparatedByString:@":"];
    _minutesTextField.text = gametime[0];
    _secondsTextField.text = gametime[1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameSaved:) name:@"GameSavedNotification" object:nil];

    _clockLabel.text = game.currentgametime;
    _homeImageView.image = [currentSettings.team getImage:@"tiny"];
    
    if ([game.opponentpic isEqualToString:@"/opponentpics/tiny/missing.png"]) {
        _visitorImageView.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_availabe.png"], 1)];
    } else {
        NSURL * imageURL = [NSURL URLWithString:game.opponentpic];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        _visitorImageView.image = [UIImage imageWithData:imageData];
    }

    _hometeamLabel.text = currentSettings.team.mascot;
    _visitingTeamLabel.text = game.opponent_mascot;
    _homeScoreLabel.text = [game.homescore stringValue];
    _visitorScoreLabel.text = [game.opponentscore stringValue];
    _periodLabel.text = [game.period stringValue];
    _visitorShotsLabel.text = [game.socceroppsog stringValue];
    _visitorCKLabel.text = [game.socceroppck stringValue];
    _visitorSavesLabel.text = [game.socceroppsaves stringValue];
    
    _homeCKLabel.text = [NSString stringWithFormat:@"%d", [game soccerHomeCK]];
    _homeSavesLabel.text = [NSString stringWithFormat:@"%d", [game soccerHomeSaves]];
    _homeShotsLabel.text = [NSString stringWithFormat:@"%d", [game soccerHomeShots]];
}

- (IBAction)saveButtonClicked:(id)sender {
    game.opponentscore = [NSNumber numberWithInt:[_visitorScoreTextField.text intValue]];
    game.socceroppck = [NSNumber numberWithInt:[_visitorCKTextField.text intValue]];
    game.socceroppsaves = [NSNumber numberWithInt:[_visitorSavesTextField.text intValue]];
    game.socceroppsog = [NSNumber numberWithInt:[_visitorShotsTextField.text intValue]];
    game.period = [NSNumber numberWithInt:[_periodTextView.text intValue]];
    game.currentgametime = [NSString stringWithFormat:@"%@%@%@", _minutesTextField.text, @":", _secondsTextField.text];
   
    [game saveGameschedule];
}

- (void)gameSaved:(NSNotification *)notification {
    if (game.httperror.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Clock update saved!"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:game.httperror
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
    NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];

    if (myStringMatchesRegEx)
        return YES;
    else
        return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ((textField == _minutesTextField) || (textField == _secondsTextField))
        _clockLabel.text = [NSString stringWithFormat:@"%@%@%@", _minutesTextField.text, @":", _secondsTextField.text];
    else if (textField == _periodTextView)
        _periodLabel.text = _periodTextView.text;
    else if (textField == _visitorShotsTextField)
        _visitorShotsLabel.text = _visitorShotsTextField.text;
    else if (textField == _visitorScoreTextField)
        _visitorScoreLabel.text = _visitorScoreTextField.text;
    else if (textField == _visitorSavesTextField)
        _visitorSavesLabel.text = _visitorSavesTextField.text;
    else if (textField == _visitorCKTextField)
        _visitorCKLabel.text = _visitorCKTextField.text;
}

@end
