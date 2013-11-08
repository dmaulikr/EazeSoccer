//
//  EditBasketballGameViewController.m
//  Basketball Console
//
//  Created by Gilbert Zaldivar on 9/13/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "EditGameViewController.h"
#import "eazesportzAppDelegate.h"
#import "sportzServerInit.h"
#import "sportzCurrentSettings.h"
#import "FindEazesportzSiteViewController.h"
#import "TeamSelectViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface EditGameViewController () <UIAlertViewDelegate>

@end

@implementation EditGameViewController {
    NSDate *pickerDate;
    
    FindEazesportzSiteViewController *findSiteController;
    TeamSelectViewController *teamSelectController;
}

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
    self.view.backgroundColor = [UIColor clearColor];
    
    _selectDateButton.layer.cornerRadius = 6;
    _selectDateButton.backgroundColor = [UIColor greenColor];
    _homeScoreTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorScoreTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _homeLabel.hidden = YES;
    _visitorLabel.hidden = YES;
    _homeScoreTextField.hidden = YES;
    _visitorScoreTextField.hidden = YES;
    _homeScoreTextField.enabled = NO;
    _visitorScoreTextField.enabled = NO;
    _selectDateButton.hidden = YES;
    _selectDateButton.enabled = NO;
    _datePicker.hidden = YES;
    _datePicker.enabled = NO;
    _findsiteContainer.hidden = YES;
    _findTeamContainer.hidden = YES;
    
    if (game) {
        _opponentTextField.text = game.opponent;
        _mascotTextField.text = game.opponent_mascot;
        _homeawayTextField.text = game.homeaway;
        _locationTextField.text = game.location;
        _eventTextField.text = game.event;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *gamedate = [dateFormat dateFromString:game.startdate];
        [dateFormat setDateFormat:@"MM-dd-yyyy"];
        
        _gameDateTextField.text = [dateFormat stringFromDate:gamedate];
        
        _gameTimeTextField.text = game.starttime;
        _homeScoreTextField.text = _homescoreLabel.text = [[game homescore] stringValue];
        _visitorScoreTextField.text = _visitorscoreLabel.text = [[game opponentscore] stringValue];
        
        NSString *datestring = [game.startdate stringByAppendingString:@" "];
        datestring = [datestring stringByAppendingString:game.starttime];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mma"];
        pickerDate = [formatter dateFromString:datestring];
        
        if (game.leaguegame) {
            [_leagueSwitch setOn:YES];
        } else {
            [_leagueSwitch setOn:NO];
        }
    } else {
        _homescoreLabel.text = @"0";
        _visitorscoreLabel.text = @"0";
        _deleteButton.hidden = YES;
        _deleteButton.enabled = NO;
        _visitorScoreTextField.text = @"0";
        _homeScoreTextField.text = @"0";
        _opponentTextField.text = @"";
        _mascotTextField.text = @"";
        [_leagueSwitch setOn:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender {
    sender.text = @"";
    if ((sender == _gameDateTextField) || (sender == _gameTimeTextField)) {
        _datePicker.hidden = NO;
        _datePicker.enabled = YES;
        _selectDateButton.hidden = NO;
        _selectDateButton.enabled = YES;
        [sender resignFirstResponder];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _homeScoreTextField) {
        if (_homeScoreTextField.text.length == 0)
            _homeScoreTextField.text = @"0";
        else
            _homescoreLabel.text = _homeScoreTextField.text;
    } else if (textField == _visitorScoreTextField) {
        if (_visitorScoreTextField.text.length == 0)
            _visitorScoreTextField.text = @"0";
        else
            _visitorscoreLabel.text = _visitorScoreTextField.text;
    }
    [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ((textField == _homeScoreTextField) || (textField == _visitorScoreTextField)) {
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

- (IBAction)selectDateButtonClicked:(id)sender {
    //    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    pickerDate = [_datePicker date];
    //    NSString *selectionString = [[NSString alloc] initWithFormat:@"%@", [pickerDate descriptionWithLocale:usLocale]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy hh:mm:ss a"];
    NSArray *datetime = [[formatter stringFromDate:pickerDate] componentsSeparatedByString:@" "];
    _gameDateTextField.text = [datetime objectAtIndex:0];
    _gameTimeTextField.text = [datetime objectAtIndex:1];
    _gameTimeTextField.text = [_gameTimeTextField.text stringByAppendingString:[datetime objectAtIndex:2]];
    _datePicker.hidden = YES;
    _datePicker.enabled = NO;
    _selectDateButton.hidden = YES;
    _selectDateButton.enabled = NO;
    [_gameTimeTextField resignFirstResponder];
    [_gameDateTextField resignFirstResponder];
}

- (IBAction)submitButtonClicked:(id)sender {
    if ((_opponentTextField.text.length > 0) && (_locationTextField.text.length > 0) && (_homeawayTextField.text.length > 0) &&
        (_gameDateTextField.text.length > 0) && (_gameTimeTextField.text.length > 0)) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        NSArray *datetime = [[formatter stringFromDate:pickerDate] componentsSeparatedByString:@" "];
//        NSArray *time = [[datetime objectAtIndex:1] componentsSeparatedByString:@":"];
//        [formatter setDateFormat:@"yyyy-MM-dd"];
        [formatter setDateFormat:@"HH:mm"];
        NSString *timedata = [formatter stringFromDate:pickerDate];

        if (!game)
            game = [[GameSchedule alloc] init];
        
        game.startdate = datetime[0];
        game.starttime = timedata;
        game.opponent = _opponentTextField.text;
        game.opponent_mascot = _mascotTextField.text;
        game.location = _locationTextField.text;
        game.event = _eventTextField.text;
        game.homeaway = _homeawayTextField.text;
        game.homescore = [NSNumber numberWithInt:[_homeScoreTextField.text intValue]];
        game.opponentscore = [NSNumber numberWithInt:[_visitorScoreTextField.text intValue]];
        game.leaguegame = [_leagueSwitch isOn];
        
        if (teamSelectController.team ) {
             game.opponentpic = teamSelectController.team.team_logo;
        }
        
        if ([game saveGameschedule]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem Creating Game Data"
                                                            message:[game httperror]
                                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                              message:@"Game entry must include Opponent, Location, Home/Away, Start Date and Start Time"
                              delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (IBAction)deleteButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You are about delete the game. All data will be lost!"
                                                   delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:@"Cancel", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)scoreButtonClicked:(id)sender {
    _visitorLabel.hidden = NO;
    _visitorScoreTextField.hidden = NO;
    _visitorScoreTextField.enabled = YES;
    _homeLabel.hidden = NO;
    _homeScoreTextField.hidden = NO;
    _homeScoreTextField.enabled = YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"]) {
        if (![game initDeleteGame]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (IBAction)searchEazesportzButtonClicked:(id)sender {
    _findsiteContainer.hidden = NO;
    [findSiteController viewWillAppear:YES];
}

- (IBAction)findsiteSelected:(UIStoryboardSegue *)segue {
    _findsiteContainer.hidden = YES;
    
    if (findSiteController.sport) {
//        if (![findSiteController.sport.id isEqualToString:currentSettings.sport.id]) {
            _findTeamContainer.hidden = NO;
            teamSelectController.sport = findSiteController.sport;
            [teamSelectController viewWillAppear:YES];
/*        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You cannot select your team as an opponent!"
                                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        } */
    } 
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FindSiteSelectSegue"]) {
        findSiteController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"TeamSelectSegue"]) {
        teamSelectController = segue.destinationViewController;
    }
}

- (IBAction)findteamSelected:(UIStoryboardSegue *)segue {
    _findTeamContainer.hidden = YES;
    
    if (teamSelectController.team) {
        _opponentTextField.text = teamSelectController.team.title;
        _mascotTextField.text = teamSelectController.team.mascot;
    }
}

@end

