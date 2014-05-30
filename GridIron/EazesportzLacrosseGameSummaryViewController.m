//
//  EazesportzLacrosseGameSummaryViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/23/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzLacrosseGameSummaryViewController.h"

#import "EazesportzAppDelegate.h"
#import "EazesportzLacrosseStatTableViewCell.h"
#import "EazesportzLacrosseMinutesStatTableViewCell.h"
#import "EazesportzLacrosseGameStatsViewController.h"
#import "EazesportzLacrosseScoresheetViewController.h"

@interface EazesportzLacrosseGameSummaryViewController ()

@end

@implementation EazesportzLacrosseGameSummaryViewController {
    NSIndexPath *deleteIndexPath;
    
    BOOL home;
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
    [_visitorButton setTitle:game.opponent_mascot forState:UIControlStateNormal];
    _homeScoreTextField.text = [game.lacrosse_home_score stringValue];
    _visitorTextField.text = [game.lacrosse_visitor_score stringValue];
    _periodTextField.text = [game.period stringValue];
    _lastplayTextField.text = game.lastplay;
    
    _summaryHomeLabel.text = currentSettings.team.mascot;
    _summaryVisitorLabel.text = game.opponent_mascot;
    
    _summaryHomeFirstPeriodScore.text = [[game.lacrosse_home_score_by_period objectAtIndex:0] stringValue];
    _summaryHomeSecondPeriodScore.text = [[game.lacrosse_home_score_by_period objectAtIndex:1] stringValue];
    _summaryHomeThirdPeriodScore.text = [[game.lacrosse_home_score_by_period objectAtIndex:2] stringValue];
    _summaryHomeFourthPeriodScore.text = [[game.lacrosse_home_score_by_period objectAtIndex:3] stringValue];
    _summaryHomeOvertimeScore.text = [[game.lacrosse_home_score_by_period objectAtIndex:4] stringValue];
    
    int sum = 0;
    
    for (int i = 0; i < 5; i++) {
        sum += [[game.lacrosse_home_score_by_period objectAtIndex:i] intValue];
    }
    
    _summaryHomeTotalsScore.text = [NSString stringWithFormat:@"%d", sum];
    
    _summaryVisitorFirstPeriodScore.text = [[game.lacrosse_visitor_score_by_period objectAtIndex:0] stringValue];
    _summaryVisitorSecondPeriodScore.text = [[game.lacrosse_visitor_score_by_period objectAtIndex:1] stringValue];
    _summaryVisitorThirdPeriodScore.text = [[game.lacrosse_visitor_score_by_period objectAtIndex:2] stringValue];
    _summaryVisitorFourthPeriodScore.text = [[game.lacrosse_visitor_score_by_period objectAtIndex:3] stringValue];
    _summaryVisitorOvertimeScore.text = [[game.lacrosse_visitor_score_by_period objectAtIndex:4] stringValue];
    
    sum = 0;
    
    for (int i = 0; i < 5; i++) {
        sum += [[game.lacrosse_visitor_score_by_period objectAtIndex:i] intValue];
    }
    
    _summaryVisitorTotalScore.text = [NSString stringWithFormat:@"%d", sum];
    
    _homeImageView.image = [currentSettings.team getImage:@"tiny"];
    _visitorImageView.image = [game opponentImage:@"tiny"];
    
    if (currentSettings.isSiteOwner) {
        _visitorButton.enabled = YES;
        _homeButton.enabled = YES;
        _homePenaltyButton.enabled = YES;
        _visitorPenaltyButton.enabled = YES;
    } else {
        _visitorButton.enabled = NO;
        _homeButton.enabled = NO;
        _homePenaltyButton.enabled = NO;
        _visitorPenaltyButton.enabled = NO;
        [_visitorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_homeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_homePenaltyButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        [_visitorPenaltyButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    }
    
    if (currentSettings.isSiteOwner)
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshButton, self.statsButton, self.sheetButton, self.saveButton, nil];
    else
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshButton, self.statsButton, nil];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GameStatsSegue"]) {
        EazesportzLacrosseGameStatsViewController *destController = segue.destinationViewController;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"ScoreSheetSegue"]) {
        EazesportzLacrosseScoresheetViewController *destController = segue.destinationViewController;
        destController.game = game;
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

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)refreshButtonClicked:(id)sender {
}

- (IBAction)saveButtonClicked:(id)sender {
}

- (IBAction)visitorPenaltyButtonClicked:(id)sender {
}

- (IBAction)homePenaltyButtonClicked:(id)sender {
}

@end
