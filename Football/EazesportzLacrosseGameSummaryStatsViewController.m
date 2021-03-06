//
//  EazesportzLacrosseGameSummaryStatsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 6/12/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzLacrosseGameSummaryStatsViewController.h"

#import "EazesportzLacrosseStatTableViewCell.h"
#import "EazesportzLacrosseMinutesStatTableViewCell.h"
#import "EazesportzLacrosseScoresheetViewController.h"
#import "EazesportzGetGame.h"

@interface EazesportzLacrosseGameSummaryStatsViewController ()

@end

@implementation EazesportzLacrosseGameSummaryStatsViewController {
    NSIndexPath *deleteIndexPath;
    EazesportzGetGame *getgame;
    
    BOOL home;
}

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
    _secondsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _homeScoreTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorTextField.keyboardType = UIKeyboardTypeNumberPad;
    _periodTextField.keyboardType = UIKeyboardTypeNumberPad;
    _homePenaltyOneMinutesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _homePenaltyOnePlayerTextField.keyboardType = UIKeyboardTypeNumberPad;
    _homePenaltyOneSecondsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorPenaltyOneMinutesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorPenaltyOnePlayerTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorPenaltyOneSecondsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _homePenaltyTwoMinutesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _homePenaltyTwoPlayerTextField.keyboardType = UIKeyboardTypeNumberPad;
    _homePenaltyTwoSecondsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorPenaltyTwoMinutesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorPenaltyTwoPlayerTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorPenaltyTwoSecondsTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    home = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self textFieldConfiguration:_secondsTextField];
    [self textFieldConfiguration:_minutesTextField];
    [self textFieldConfiguration:_visitorTextField];
    [self textFieldConfiguration:_homeScoreTextField];
    [self textFieldConfiguration:_periodTextField];
    [self textFieldConfiguration:_homePenaltyOneMinutesTextField];
    [self textFieldConfiguration:_homePenaltyOnePlayerTextField];
    [self textFieldConfiguration:_homePenaltyOneSecondsTextField];
    [self textFieldConfiguration:_visitorPenaltyOneMinutesTextField];
    [self textFieldConfiguration:_visitorPenaltyOnePlayerTextField];
    [self textFieldConfiguration:_visitorPenaltyOneSecondsTextField];
    [self textFieldConfiguration:_homePenaltyTwoMinutesTextField];
    [self textFieldConfiguration:_homePenaltyTwoPlayerTextField];
    [self textFieldConfiguration:_homePenaltyTwoSecondsTextField];
    [self textFieldConfiguration:_visitorPenaltyTwoMinutesTextField];
    [self textFieldConfiguration:_visitorPenaltyTwoPlayerTextField];
    [self textFieldConfiguration:_visitorPenaltyTwoSecondsTextField];
    
    [_homeButton setTitle:currentSettings.team.mascot forState:UIControlStateNormal];
    [_visitorButton setTitle:self.game.opponent_mascot forState:UIControlStateNormal];
    _homeScoreTextField.text = [self.game.lacrosse_home_score stringValue];
    _visitorTextField.text = [self.game.lacrosse_visitor_score stringValue];
    _periodTextField.text = [self.game.period stringValue];
    _lastplayTextField.text = self.game.lastplay;
    
    _summaryHomeLabel.text = currentSettings.team.mascot;
    _summaryVisitorLabel.text = self.game.opponent_mascot;
    
    NSArray *gametime = [self.game.currentgametime componentsSeparatedByString:@":"];
    _minutesTextField.text = gametime[0];
    _secondsTextField.text = gametime[1];
    
    _homePenaltyOnePlayerTextField.text = [self.game.lacross_game.home_penaltyone_number stringValue];
    _homePenaltyOneSecondsTextField.text = [self padzerotime:[self.game.lacross_game.home_penaltyone_seconds intValue]];
    _homePenaltyOneMinutesTextField.text = [self.game.lacross_game.home_penaltyone_minutes stringValue];
    _homePenaltyTwoPlayerTextField.text = [self.game.lacross_game.home_penaltytwo_number stringValue];
    _homePenaltyOneSecondsTextField.text = [self padzerotime:[self.game.lacross_game.home_penaltytwo_seconds intValue]];
    _homePenaltyTwoMinutesTextField.text = [self.game.lacross_game.home_penaltytwo_minutes stringValue];
    _visitorPenaltyOnePlayerTextField.text = [self.game.lacross_game.visitor_penaltyone_number stringValue];
    _visitorPenaltyOneSecondsTextField.text = [self padzerotime:[self.game.lacross_game.visitor_penaltyone_seconds intValue]];
    _visitorPenaltyOneMinutesTextField.text = [self.game.lacross_game.visitor_penaltyone_minutes stringValue];
    _visitorPenaltyTwoPlayerTextField.text = [self.game.lacross_game.visitor_penaltytwo_number stringValue];
    _visitorPenaltyTwoSecondsTextField.text = [self padzerotime:[self.game.lacross_game.visitor_penaltytwo_seconds intValue]];
    _visitorPenaltyTwoMinutesTextField.text = [self.game.lacross_game.visitor_penaltytwo_minutes stringValue];
    
    _summaryHomeFirstPeriodScore.text = [[self.game.lacrosse_home_score_by_period objectAtIndex:0] stringValue];
    _summaryHomeSecondPeriodScore.text = [[self.game.lacrosse_home_score_by_period objectAtIndex:1] stringValue];
    _summaryHomeThirdPeriodScore.text = [[self.game.lacrosse_home_score_by_period objectAtIndex:2] stringValue];
    _summaryHomeFourthPeriodScore.text = [[self.game.lacrosse_home_score_by_period objectAtIndex:3] stringValue];
    _summaryHomeOvertimeScore.text = [[self.game.lacrosse_home_score_by_period objectAtIndex:4] stringValue];
    
    int sum = 0;
    
    for (int i = 0; i < 5; i++) {
        sum += [[self.game.lacrosse_home_score_by_period objectAtIndex:i] intValue];
    }
    
    _summaryHomeTotalsScore.text = [NSString stringWithFormat:@"%d", sum];
    
    _summaryVisitorFirstPeriodScore.text = [[self.game.lacrosse_visitor_score_by_period objectAtIndex:0] stringValue];
    _summaryVisitorSecondPeriodScore.text = [[self.game.lacrosse_visitor_score_by_period objectAtIndex:1] stringValue];
    _summaryVisitorThirdPeriodScore.text = [[self.game.lacrosse_visitor_score_by_period objectAtIndex:2] stringValue];
    _summaryVisitorFourthPeriodScore.text = [[self.game.lacrosse_visitor_score_by_period objectAtIndex:3] stringValue];
    _summaryVisitorOvertimeScore.text = [[self.game.lacrosse_visitor_score_by_period objectAtIndex:4] stringValue];
    
    sum = 0;
    
    for (int i = 0; i < 5; i++) {
        sum += [[self.game.lacrosse_visitor_score_by_period objectAtIndex:i] intValue];
    }
    
    _summaryVisitorTotalScore.text = [NSString stringWithFormat:@"%d", sum];
    
    _homeImageView.image = [currentSettings.team getImage:@"tiny"];
    _visitorImageView.image = [self.game opponentImage:@"tiny"];
    
    if (currentSettings.isSiteOwner)
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshButton, self.statsButton, self.sheetButton, self.saveButton, nil];
    else
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshButton, self.statsButton, nil];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ScoreSheetSegue"]) {
        EazesportzLacrosseScoresheetViewController *destController = segue.destinationViewController;
        destController.game = self.game;
    } else {
        [super prepareForSegue:segue sender:sender];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
    NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (myStringMatchesRegEx) {
        if ((textField == _minutesTextField) || (textField == _secondsTextField) || (textField == _homePenaltyOneSecondsTextField) ||
            (textField == _homePenaltyTwoSecondsTextField) || (textField == _visitorPenaltyOneSecondsTextField) ||
            (textField == _visitorPenaltyTwoSecondsTextField)) {
            return (newLength > 2) ? NO : YES;
        } else if ((textField == _periodTextField) || (textField == _homePenaltyOnePlayerTextField) || (textField == _homePenaltyTwoPlayerTextField) ||
                   (textField == _homePenaltyOneMinutesTextField) || (textField == _homePenaltyTwoMinutesTextField) ||
                   (textField == _visitorPenaltyOneMinutesTextField) || (textField == _visitorPenaltyTwoMinutesTextField)) {
            return (newLength > 1) ? NO : YES;
        } else if ((textField == _visitorTextField) || (textField == _homeScoreTextField)||
                   (textField == _visitorPenaltyOnePlayerTextField) || (textField == _visitorPenaltyTwoPlayerTextField)) {
            return (newLength > 3 ? NO : YES);
        } else
            return NO;
    } else
        return NO;
}

- (void)textFieldConfiguration:(UITextField *)textField {
    if (currentSettings.isSiteOwner) {
        if (textField == _homeScoreTextField) {
            if (self.game.editHomeScore) {
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

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)refreshButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotGame:) name:@"GameDataNotification" object:nil];
    getgame = [[EazesportzGetGame alloc] init];
    [getgame getGame:currentSettings.sport.id Team:currentSettings.team.teamid Game:self.game.id Token:currentSettings.user.authtoken];
}

- (void)gotGame:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GameDataNotification" object:nil];
        self.game = getgame.game;
        [self viewWillAppear:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error retrieving game!" delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)saveButtonClicked:(id)sender {
    self.game.currentgametime = [NSString stringWithFormat:@"%@:%@", _minutesTextField.text, _secondsTextField.text];
    self.game.period = [NSNumber numberWithInt:[_periodTextField.text intValue]];
    self.game.opponentscore = [NSNumber numberWithInt:[_visitorTextField.text intValue]];
    self.game.lacross_game.home_penaltyone_number = [NSNumber numberWithInt:[_homePenaltyOnePlayerTextField.text intValue]];
    self.game.lacross_game.home_penaltyone_minutes = [NSNumber numberWithInt:[_homePenaltyOneMinutesTextField.text intValue]];
    self.game.lacross_game.home_penaltyone_seconds = [NSNumber numberWithInt:[_homePenaltyOneSecondsTextField.text intValue]];
    self.game.lacross_game.home_penaltytwo_number = [NSNumber numberWithInt:[_homePenaltyTwoPlayerTextField.text intValue]];
    self.game.lacross_game.home_penaltytwo_minutes = [NSNumber numberWithInt:[_homePenaltyTwoMinutesTextField.text intValue]];
    self.game.lacross_game.home_penaltytwo_seconds = [NSNumber numberWithInt:[_homePenaltyTwoSecondsTextField.text intValue]];
    self.game.lacross_game.visitor_penaltyone_number = [NSNumber numberWithInt:[_visitorPenaltyOnePlayerTextField.text intValue]];
    self.game.lacross_game.visitor_penaltyone_minutes = [NSNumber numberWithInt:[_visitorPenaltyOneMinutesTextField.text intValue]];
    self.game.lacross_game.visitor_penaltyone_seconds = [NSNumber numberWithInt:[_visitorPenaltyOneSecondsTextField.text intValue]];
    self.game.lacross_game.visitor_penaltytwo_number = [NSNumber numberWithInt:[_visitorPenaltyTwoPlayerTextField.text intValue]];
    self.game.lacross_game.visitor_penaltytwo_minutes = [NSNumber numberWithInt:[_visitorPenaltyTwoMinutesTextField.text intValue]];
    self.game.lacross_game.visitor_penaltytwo_seconds = [NSNumber numberWithInt:[_visitorPenaltyTwoSecondsTextField.text intValue]];
    
    [self.game.lacross_game save];
    [self.game saveGameschedule];
}

- (NSString *)padzerotime:(int)entry {
    NSString *result;
    
    if (entry < 10) {
        result = [NSString stringWithFormat:@"0%d", entry];
    } else {
        result = [NSString stringWithFormat:@"%d", entry];
    }
    
    return result;
}

@end
