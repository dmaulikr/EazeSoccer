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
    
    _homescoreLabel.layer.cornerRadius = 4;
    _visitorscoreLabel.layer.cornerRadius = 4;
    _selectDateButton.layer.cornerRadius = 6;
    _selectDateButton.backgroundColor = [UIColor greenColor];
    _homeScoreTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorScoreTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [_scrollView addGestureRecognizer:singleTap];    
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:_scrollView];
    [self.view endEditing:YES];
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
        _gameDateTextField.text = game.startdate;
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
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSURL *url = [NSURL URLWithString:[sportzServerInit updateGame:currentSettings.team.teamid Game:game.id
                                                    Token:currentSettings.user.authtoken]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        NSArray *datetime = [[formatter stringFromDate:pickerDate] componentsSeparatedByString:@" "];
        NSArray *time = [[datetime objectAtIndex:1] componentsSeparatedByString:@":"];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        NSNumber *boolNumber = [NSNumber numberWithBool:[_leagueSwitch isOn]];
        
        NSDictionary *gamedict = [[NSDictionary alloc] initWithObjectsAndKeys:[_opponentTextField text], @"opponent",
                                  _mascotTextField.text, @"opponent_mascot", [_locationTextField text], @"location",
                                  [_eventTextField text], @"event", [formatter stringFromDate:pickerDate], @"gamedate",
                                  [time objectAtIndex:0], @"starttime(4i)", [time objectAtIndex:1], @"starttime(5i)",
                                  [_homeawayTextField text], @"homeaway", _homeScoreTextField.text, @"homescore",
                                  _visitorScoreTextField.text, @"opponentscore", [boolNumber stringValue], @"league", nil];
        
        NSMutableDictionary *jsonDict =  [[NSMutableDictionary alloc] init];
        [jsonDict setValue:gamedict forKey:@"gameschedule"];
        NSError *jsonSerializationError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
        
        if (!jsonSerializationError) {
            NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"Serialized JSON: %@", serJson);
        } else {
            NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
        }
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        
        if (!game) {
            [request setHTTPMethod:@"POST"];
        } else {
            [request setHTTPMethod:@"PUT"];
        }
        
        [request setHTTPBody:jsonData];
        
        //Capturing server response
        NSURLResponse* response;
        NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&jsonSerializationError];
        NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:&jsonSerializationError];
        NSLog(@"%@", serverData);
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([httpResponse statusCode] == 200) {
            if (!game) {
                _deleteButton.enabled = YES;
                _deleteButton.hidden = NO;
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Game Updated!"
                                 delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem Creating Game Data"
                                                            message:[NSString stringWithFormat:@"%d", [httpResponse statusCode]]
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
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
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
        if ([currentSettings deleteGame:game]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
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
        if (![findSiteController.sport.id isEqualToString:currentSettings.sport.id]) {
            _findTeamContainer.hidden = NO;
            teamSelectController.sport = findSiteController.sport;
            [teamSelectController viewWillAppear:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You cannot select your team as an opponent!"
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
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

