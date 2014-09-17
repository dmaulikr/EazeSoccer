//
//  EazesportzWaterPoloGameSummaryViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/19/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzWaterPoloGameSummaryViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzWaterPoloStatsViewController.h"
#import "EazesportzGetGame.h"
#import "EazesportzRetrievePlayers.h"

@interface EazesportzWaterPoloGameSummaryViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzWaterPoloGameSummaryViewController {
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
    _minutesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _secondsTextField.keyboardType =  UIKeyboardTypeNumberPad;
    _homeScoreTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorScoreTextField.keyboardType = UIKeyboardTypeNumberPad;
    _periodTextField.keyboardType = UIKeyboardTypeNumberPad;
    _homeTimeOutsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorTimeOutsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _homeOneExclusionNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    _homeOneExclusionTimeTextField.keyboardType = UIKeyboardTypeNumberPad;
    _homeTwoExclusionNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    _homeTwoExclusionTimeTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorOneExclusionNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorOneExclusionTimeTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorTwoExclusionNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorTwoExclusionTimeTextField.keyboardType = UIKeyboardTypeNumberPad;
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
    _homeScoreTextField.text = [game.water_polo_game.waterpolo_home_score stringValue];
    _visitorScoreTextField.text = [game.water_polo_game.waterpolo_visitor_score stringValue];
    _periodTextField.text = [game.period stringValue];
    _homeTimeOutsTextField.text = [game.water_polo_game.home_time_outs_left stringValue];
    _visitorTimeOutsTextField.text = [game.water_polo_game.visitor_time_outs_left stringValue];
    _homeOneExclusionNumberTextField.text = [[game.water_polo_game.exclusions objectAtIndex:0] stringValue];
    _homeOneExclusionTimeTextField.text = [[game.water_polo_game.exclusions objectAtIndex:1] stringValue];
    _homeTwoExclusionNumberTextField.text = [[game.water_polo_game.exclusions objectAtIndex:2] stringValue];
    _homeTwoExclusionTimeTextField.text = [[game.water_polo_game.exclusions objectAtIndex:3] stringValue];
    _visitorOneExclusionNumberTextField.text = [[game.water_polo_game.exclusions objectAtIndex:4] stringValue];
    _visitorOneExclusionTimeTextField.text = [[game.water_polo_game.exclusions objectAtIndex:5] stringValue];
    _visitorTwoExclusionNumberTextField.text = [[game.water_polo_game.exclusions objectAtIndex:6] stringValue];
    _visitorTwoExclusionTimeTextField.text = [[game.water_polo_game.exclusions objectAtIndex:7] stringValue];
    
    _homeSummaryLabel.text = currentSettings.team.mascot;
    _visitorSummaryLabel.text = game.opponent_mascot;
    
    _homePeriodOneLabel.text = [game.water_polo_game.waterpolo_game_home_score_period1 stringValue];
    _homePeriodTwoLabel.text = [game.water_polo_game.waterpolo_game_home_score_period2 stringValue];
    _homePeriodThreeLabel.text = [game.water_polo_game.waterpolo_game_home_score_period3 stringValue];
    _homePeriodFourLabel.text = [game.water_polo_game.waterpolo_game_home_score_period4 stringValue];
    _homeOverTimeLabel.text = [game.water_polo_game.waterpolo_game_home_score_periodOT1 stringValue];
    
    _homeTotalLabel.text = [game.water_polo_game.waterpolo_home_score stringValue];
    
    _visitorPeriodOneLabel.text = [game.water_polo_game.waterpolo_game_visitor_score_period1 stringValue];
    _visitorPeriodTwoLabel.text = [game.water_polo_game.waterpolo_game_visitor_score_period2 stringValue];
    _visitorPeriodThreeLabel.text = [game.water_polo_game.waterpolo_game_visitor_score_period3 stringValue];
    _visitorPeriodFourLabel.text = [game.water_polo_game.waterpolo_game_visitor_score_period4 stringValue];
    _visitorOverTimeLabel.text = [game.water_polo_game.waterpolo_game_visitor_score_periodOT1 stringValue];
    
    _visitorTotalLabel.text = [game.water_polo_game.waterpolo_visitor_score stringValue];
    
    NSArray *gametime = [game.currentgametime componentsSeparatedByString:@":"];
    
    if (gametime.count == 2) {
        _minutesTextField.text = [gametime objectAtIndex:0];
        _secondsTextField.text = [gametime objectAtIndex:1];
    } else {
        _minutesTextField.text = @"00";
        _secondsTextField.text = @"00";
    }
    
    [self textFieldConfiguration:_minutesTextField];
    [self textFieldConfiguration:_secondsTextField];
    [self textFieldConfiguration:_homeScoreTextField];
    [self textFieldConfiguration:_secondsTextField];
    [self textFieldConfiguration:_periodTextField];
    [self textFieldConfiguration:_homeScoreTextField];
    [self textFieldConfiguration:_visitorScoreTextField];
    [self textFieldConfiguration:_homeOneExclusionTimeTextField];
    [self textFieldConfiguration:_homeOneExclusionNumberTextField];
    [self textFieldConfiguration:_homeTwoExclusionNumberTextField];
    [self textFieldConfiguration:_homeTwoExclusionTimeTextField];
    [self textFieldConfiguration:_visitorOneExclusionNumberTextField];
    [self textFieldConfiguration:_visitorOneExclusionTimeTextField];
    [self textFieldConfiguration:_visitorTwoExclusionNumberTextField];
    [self textFieldConfiguration:_visitorTwoExclusionTimeTextField];
    [self textFieldConfiguration:_homeTimeOutsTextField];
    [self textFieldConfiguration:_visitorTimeOutsTextField];
    
    if ([currentSettings isSiteOwner]) {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshBarButton, self.saveBarButton, self.statsBarButton, nil];
    } else{
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshBarButton, self.statsBarButton, nil];
    }
    
    self.navigationController.toolbarHidden = YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"WaterpoloStatsSegue"]) {
        EazesportzWaterPoloStatsViewController *destController = segue.destinationViewController;
        destController.game = game;
    }
}

- (IBAction)homeButtonClicked:(id)sender {
}

- (IBAction)visitorButtonClicked:(id)sender {
}

- (IBAction)saveBarButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(waterPoloGameSaved:) name:@"WaterPoloGameSavedNotification" object:nil];
    game.water_polo_game.home_time_outs_left = [NSNumber numberWithInt:[_homeTimeOutsTextField.text intValue]];
    game.water_polo_game.visitor_time_outs_left = [NSNumber numberWithInt:[_visitorTimeOutsTextField.text intValue]];
    [game.water_polo_game.exclusions replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:[_homeOneExclusionNumberTextField.text intValue]]];
    [game.water_polo_game.exclusions replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:[_homeOneExclusionTimeTextField.text intValue]]];
    [game.water_polo_game.exclusions replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:[_homeTwoExclusionNumberTextField.text intValue]]];
    [game.water_polo_game.exclusions replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:[_homeTwoExclusionTimeTextField.text intValue]]];
    [game.water_polo_game.exclusions replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:[_visitorOneExclusionNumberTextField.text intValue]]];
    [game.water_polo_game.exclusions replaceObjectAtIndex:5 withObject:[NSNumber numberWithInt:[_visitorOneExclusionTimeTextField.text intValue]]];
    [game.water_polo_game.exclusions replaceObjectAtIndex:6 withObject:[NSNumber numberWithInt:[_visitorTwoExclusionNumberTextField.text intValue]]];
    [game.water_polo_game.exclusions replaceObjectAtIndex:7 withObject:[NSNumber numberWithInt:[_visitorTwoExclusionTimeTextField.text intValue]]];
    [game.water_polo_game save];
}

- (void)waterPoloGameSaved:(NSNotification *)notification {
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

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = @"";
    
    if (textField == _visitorScoreTextField) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Select Period" message:nil delegate:self
                                 cancelButtonTitle:@"Cancel" otherButtonTitles:@"1", @"2", @"3", @"4", @"OT", nil];
//        alertView.tag = 2;
//        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
//        [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
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
    } else if ([title isEqualToString:@"4"]) {
        period = 4;
        [self displayPeriodScoreAlert];
    } else if ([title isEqualToString:@"OT1"]) {
        period = 5;
        [self displayPeriodScoreAlert];
    } else if ([title isEqualToString:@"Submit"]) {
        NSNumber *score = [NSNumber numberWithInt:[[alertView textFieldAtIndex:0].text intValue]];
        
        switch (period) {
            case 1:
                game.water_polo_game.waterpolo_game_visitor_score_period1 = score;
                _visitorPeriodOneLabel.text = [score stringValue];
                break;
                
            case 2:
                game.water_polo_game.waterpolo_game_visitor_score_period2 = score;
                _visitorPeriodTwoLabel.text = [score stringValue];
                break;
                
            case 3:
                game.water_polo_game.waterpolo_game_visitor_score_period3 = score;
                _visitorPeriodThreeLabel.text = [score stringValue];
                break;
                
            case 4:
                game.water_polo_game.waterpolo_game_visitor_score_period4 = score;
                _visitorPeriodFourLabel.text = [score stringValue];
                break;
                
            default:
                game.water_polo_game.waterpolo_game_visitor_score_periodOT1 = score;
                _visitorOverTimeLabel.text = [score stringValue];
        }
        
        _visitorScoreTextField.text = [[game.water_polo_game visitorScore] stringValue];
        _visitorTotalLabel.text = _visitorScoreTextField.text;
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

@end
