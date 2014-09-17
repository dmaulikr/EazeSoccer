//
//  EazesportzHockeyGameSummaryViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 9/11/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzHockeyGameSummaryViewController.h"

#import "EazesportzAppDelegate.h"
#import "EazesportzGetGame.h"
#import "EazesportzRetrievePlayers.h"
#import "EazesportzHockeyStatsViewController.h"

@interface EazesportzHockeyGameSummaryViewController ()

@end

@implementation EazesportzHockeyGameSummaryViewController {
    int period;
    EazesportzGetGame *getgame;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) {
        _homeImageView.image = [currentSettings.team getImage:@"tiny"];
        _visitorImageView.image = [game opponentImage:@"tiny"];
    } else {
        _homeImageView.image = [currentSettings.team getImage:@"thumb"];
        _visitorImageView.image = [game opponentImage:@"thumb"];
    }
    
    [_homeButton setTitle:currentSettings.team.mascot forState:UIControlStateNormal];
    [_visitorButton setTitle:game.opponent_mascot forState:UIControlStateNormal];
    
    _homeScoreTextField.text = [game.hockey_game.hockey_home_score stringValue];
    _visitorScoreTextField.text = [game.hockey_game.hockey_visitor_score stringValue];
    _periodTextField.text = [game.period stringValue];
    _homeTimeOutsTextField.text = [game.hockey_game.home_time_outs_left stringValue];
    _visitorTimeOutsTextField.text = [game.hockey_game.visitor_time_outs_left stringValue];
    
    _penaltyHomePlayerOneTextField.text = [game.hockey_game.home_penalty_one_number stringValue];
    _penaltyHomePlayerOneMinutesTextField.text = [game.hockey_game.home_penalty_one_minutes stringValue];
    _penaltyHomePlayerOneSecondsTextField.text = [game.hockey_game.home_penalty_one_seconds stringValue];
    _penaltyHomePlayerTwoTextField.text = [game.hockey_game.home_penalty_two_number stringValue];
    _penaltyHomePlayerTwoMinutesTextField.text = [game.hockey_game.home_penalty_two_minutes stringValue];
    _penaltyHomePlayerTwoSecondsTextField.text = [game.hockey_game.home_penalty_two_seconds stringValue];
    
    _penaltyVisitorPlayerOneTextField.text = [game.hockey_game.visitor_penalty_two_number stringValue];
    _penaltyVisitorPlayerOneMinutesTextField.text = [game.hockey_game.visitor_penalty_one_minutes stringValue];
    _penaltyVisitorPlayerOneSecondsTextField.text = [game.hockey_game.visitor_penalty_one_seconds stringValue];
    _penaltyVisitorPlayerTwoTextField.text = [game.hockey_game.visitor_penalty_two_number stringValue];
    _penaltyVisitorPlayerTwoMinutesTextField.text = [game.hockey_game.visitor_penalty_two_minutes stringValue];
    _penaltyVisitorPlayerTwoSecondsTextField.text = [game.hockey_game.visitor_penalty_two_seconds stringValue];
    
    _homeTeamSummaryLabel.text = currentSettings.team.mascot;
    _visitorTeamSummaryLabel.text = game.opponent_mascot;
    _homeTeamPeriodOneScoreLabel.text = [game.hockey_game.hockey_game_home_score_period1 stringValue];
    _homeTeamPeriodTwoScoreLabel.text = [game.hockey_game.hockey_game_home_score_period2 stringValue];
    _homeTeamPeriodThreeScoreLabel.text = [game.hockey_game.hockey_game_home_score_period3 stringValue];
    _homeTeamOvertimeScoreLabel.text = [game.hockey_game.hockey_game_home_score_overtime stringValue];
    _visitorTeamPeriodOneScoreLabel.text = [game.hockey_game.visitor_score_period1 stringValue];
    _visitorTeamPeriodTwoScoreLabel.text = [game.hockey_game.visitor_score_period2 stringValue];
    _visitorTeamPeriodThreeScoreLabel.text = [game.hockey_game.visitor_score_period3 stringValue];
    _visitorTeamOvertimeScoreLabel.text = [game.hockey_game.visitor_score_overtime stringValue];
    
    [self textFieldConfiguration:_minutesTextField];
    [self textFieldConfiguration:_secondsTextField];
    [self textFieldConfiguration:_homeScoreTextField];
    [self textFieldConfiguration:_secondsTextField];
    [self textFieldConfiguration:_periodTextField];
    [self textFieldConfiguration:_homeScoreTextField];
    [self textFieldConfiguration:_visitorScoreTextField];
    [self textFieldConfiguration:_penaltyHomePlayerOneTextField];
    [self textFieldConfiguration:_penaltyHomePlayerOneMinutesTextField];
    [self textFieldConfiguration:_penaltyHomePlayerOneSecondsTextField];
    [self textFieldConfiguration:_penaltyHomePlayerTwoTextField];
    [self textFieldConfiguration:_penaltyHomePlayerTwoMinutesTextField];
    [self textFieldConfiguration:_penaltyHomePlayerTwoSecondsTextField];
    [self textFieldConfiguration:_penaltyVisitorPlayerOneTextField];
    [self textFieldConfiguration:_penaltyVisitorPlayerOneMinutesTextField];
    [self textFieldConfiguration:_penaltyVisitorPlayerOneSecondsTextField];
    [self textFieldConfiguration:_penaltyVisitorPlayerTwoTextField];
    [self textFieldConfiguration:_penaltyVisitorPlayerTwoMinutesTextField];
    [self textFieldConfiguration:_penaltyVisitorPlayerTwoSecondsTextField];
    [self textFieldConfiguration:_homeTimeOutsTextField];
    [self textFieldConfiguration:_visitorTimeOutsTextField];
    
    if ([currentSettings isSiteOwner]) {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshBarButton, self.saveBarButton, self.statsBarButton, nil];
    } else{
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshBarButton, self.statsBarButton, nil];
    }
    
    self.navigationController.toolbarHidden = YES;    
}

- (void)textFieldConfiguration:(UITextField *)textField {
    if (currentSettings.isSiteOwner) {
        if (textField == _homeScoreTextField) {
            if (game.editHomeScore) {
                textField.enabled = YES;
                textField.backgroundColor = [UIColor whiteColor];
                textField.textColor = [UIColor blackColor];
            } else {
                textField.enabled = NO;
                textField.backgroundColor = [UIColor blackColor];
                textField.textColor = [UIColor yellowColor];
            }
        } else {
            textField.enabled = YES;
            textField.backgroundColor = [UIColor whiteColor];
            textField.textColor = [UIColor blackColor];
        }
    } else {
        textField.enabled = NO;
        textField.backgroundColor = [UIColor blackColor];
        textField.textColor = [UIColor yellowColor];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"HockeyStatsSegue"]) {
        EazesportzHockeyStatsViewController *destController = segue.destinationViewController;
        destController.game = game;
    }
}

- (IBAction)saveBarButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hockeyGameSaved:) name:@"HockeyGameSavedNotification" object:nil];
    game.hockey_game.home_time_outs_left = [NSNumber numberWithInt:[_homeTimeOutsTextField.text intValue]];
    game.hockey_game.visitor_time_outs_left = [NSNumber numberWithInt:[_visitorTimeOutsTextField.text intValue]];
    
    game.hockey_game.home_penalty_one_number = [NSNumber numberWithInt:[_penaltyHomePlayerOneTextField.text intValue]];
    game.hockey_game.home_penalty_one_minutes = [NSNumber numberWithInt:[_penaltyHomePlayerOneMinutesTextField.text intValue]];
    game.hockey_game.home_penalty_one_seconds = [NSNumber numberWithInt:[_penaltyHomePlayerOneSecondsTextField.text intValue]];
    game.hockey_game.home_penalty_two_number = [NSNumber numberWithInt:[_penaltyHomePlayerTwoTextField.text intValue]];
    game.hockey_game.home_penalty_two_minutes = [NSNumber numberWithInt:[_penaltyHomePlayerTwoMinutesTextField.text intValue]];
    game.hockey_game.home_penalty_two_seconds = [NSNumber numberWithInt:[_penaltyHomePlayerTwoSecondsTextField.text intValue]];
    
    game.hockey_game.visitor_penalty_one_number = [NSNumber numberWithInt:[_penaltyVisitorPlayerOneTextField.text intValue]];
    game.hockey_game.visitor_penalty_one_minutes = [NSNumber numberWithInt:[_penaltyVisitorPlayerOneMinutesTextField.text intValue]];
    game.hockey_game.visitor_penalty_one_minutes = [NSNumber numberWithInt:[_penaltyVisitorPlayerOneSecondsTextField.text intValue]];
    game.hockey_game.visitor_penalty_two_number = [NSNumber numberWithInt:[_penaltyVisitorPlayerTwoTextField.text intValue]];
    game.hockey_game.visitor_penalty_two_minutes = [NSNumber numberWithInt:[_penaltyVisitorPlayerTwoMinutesTextField.text intValue]];
    game.hockey_game.visitor_penalty_two_minutes = [NSNumber numberWithInt:[_penaltyVisitorPlayerTwoSecondsTextField.text intValue]];
    
    [game.hockey_game save];
}

- (void)hockeyGameSaved:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        [self saveGameData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error saving game data!" delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WaterPoloGameSavedNotification" object:nil];
}

- (void)saveGameData {
    game.currentgametime = [NSString stringWithFormat:@"%@:%@", _minutesTextField.text, _secondsTextField.text];
    game.period = [NSNumber numberWithInt:[_periodTextField.text intValue]];
    game.opponentscore = [NSNumber numberWithInt:[_visitorScoreTextField.text intValue]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameSaved:) name:@"GameSavedNotification" object:nil];
    [game saveGameschedule];
}

- (void)gameSaved:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Game Saved!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error saving game data!" delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GameSavedNotification" object:nil];
}

- (IBAction)refreshBarButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotGame:) name:@"GameDataNotification" object:nil];
    getgame = [[EazesportzGetGame alloc] init];
    [getgame getGame:currentSettings.sport.id Team:currentSettings.team.teamid Game:game.id Token:currentSettings.user.authtoken];
}

- (void)gotGame:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GameDataNotification" object:nil];
        game = getgame.game;
        [[[EazesportzRetrievePlayers alloc] init] retrievePlayers:currentSettings.sport.id Team:currentSettings.team.teamid
                                                            Token:currentSettings.user.authtoken];
        [self viewWillAppear:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error retrieving game!" delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = @"";
    
    if (textField == _visitorScoreTextField) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Select Period" message:nil delegate:self
                                                  cancelButtonTitle:@"Cancel" otherButtonTitles:@"1", @"2", @"3", @"OT", nil];
        [alertView show];
        [textField resignFirstResponder];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"1"]) {
        period = 1;
        [self displayPeriodScoreAlert];
    } else if ([title isEqualToString:@"2"]) {
        period = 2;
        [self displayPeriodScoreAlert];
    } else if ([title isEqualToString:@"3"]) {
        period = 3;
        [self displayPeriodScoreAlert];
    } else if ([title isEqualToString:@"OT1"]) {
        period = 4;
        [self displayPeriodScoreAlert];
    } else if ([title isEqualToString:@"Submit"]) {
        NSNumber *score = [NSNumber numberWithInt:[[alertView textFieldAtIndex:0].text intValue]];
        
        switch (period) {
            case 1:
                game.hockey_game.visitor_score_period1 = score;
                _visitorTeamPeriodOneScoreLabel.text = [score stringValue];
                break;
                
            case 2:
                game.hockey_game.visitor_score_period2 = score;
                _visitorTeamPeriodTwoScoreLabel.text = [score stringValue];
                break;
                
            case 3:
                game.hockey_game.visitor_score_period3 = score;
                _visitorTeamPeriodThreeScoreLabel.text = [score stringValue];
                break;
                
            default:
                game.hockey_game.visitor_score_overtime = score;
                _visitorTeamOvertimeScoreLabel.text = [score stringValue];
                break;
        }
        
        _visitorScoreTextField.text = [[game.hockey_game visitorScore] stringValue];
        _visitorTeamTotalScoreLabel.text = _visitorScoreTextField.text;
    }
}

- (void)displayPeriodScoreAlert {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter Score" message:nil delegate:self cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Submit", nil];
    alertView.tag = 2;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [alertView show];
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
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

@end
