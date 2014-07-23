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

@interface EazesportzWaterPoloGameSummaryViewController ()

@end

@implementation EazesportzWaterPoloGameSummaryViewController

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
    
    _homeImageView.image = [currentSettings.team getImage:@"tiny"];
    _visitorImageView.image = [game opponentImage:@"tiny"];
    [_homeButton setTitle:currentSettings.team.mascot forState:UIControlStateNormal];
    [_visitorButton setTitle:game.opponent_mascot forState:UIControlStateNormal];
    _homeScoreTextField.text = [game.water_polo_game.waterpolo_home_score stringValue];
    _visitorScoreTextField.text = [game.water_polo_game.waterpolo_visitor_score stringValue];
    _periodTextField.text = [game.period stringValue];
    _homeTimeOutsTextField.text = [game.water_polo_game.home_time_outs_left stringValue];
    _visitorTimeOutsTextField.text = [game.water_polo_game.visitor_time_outs_left stringValue];
    _homeOneExclusionNumberTextField.text = [game.water_polo_game.exclusions objectAtIndex:0];
    _homeOneExclusionTimeTextField.text = [game.water_polo_game.exclusions objectAtIndex:1];
    _homeTwoExclusionNumberTextField.text = [game.water_polo_game.exclusions objectAtIndex:2];
    _homeTwoExclusionTimeTextField.text = [game.water_polo_game.exclusions objectAtIndex:3];
    _visitorOneExclusionNumberTextField.text = [game.water_polo_game.exclusions objectAtIndex:4];
    _visitorOneExclusionTimeTextField.text = [game.water_polo_game.exclusions objectAtIndex:5];
    _visitorTwoExclusionNumberTextField.text = [game.water_polo_game.exclusions objectAtIndex:6];
    _visitorTwoExclusionTimeTextField.text = [game.water_polo_game.exclusions objectAtIndex:7];
    
    _homeSummaryLabel.text = currentSettings.team.mascot;
    _visitorSummaryLabel.text = game.opponent_mascot;
    _homePeriodOneLabel.text = [game.water_polo_game.waterpolo_game_home_score_period1 stringValue];
    _homePeriodTwoLabel.text = [game.water_polo_game.waterpolo_game_home_score_period2 stringValue];
    _homePeriodThreeLabel.text = [game.water_polo_game.waterpolo_game_home_score_period3 stringValue];
    _homePeriodFourLabel.text = [game.water_polo_game.waterpolo_game_home_score_period4 stringValue];
    _homeTotalLabel.text = [game.water_polo_game.waterpolo_home_score stringValue];
    _visitorPeriodOneLabel.text = [game.water_polo_game.waterpolo_game_visitor_score_period1 stringValue];
    _visitorPeriodTwoLabel.text = [game.water_polo_game.waterpolo_game_visitor_score_period2 stringValue];
    _visitorPeriodThreeLabel.text = [game.water_polo_game.waterpolo_game_visitor_score_period3 stringValue];
    _visitorPeriodFourLabel.text = [game.water_polo_game.waterpolo_game_visitor_score_period4 stringValue];
    _visitorTotalLabel.text = [game.water_polo_game.waterpolo_visitor_score stringValue];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(waterPoloGameSaved:) name:@"WaterPoloGameStatNotification" object:nil];
    [game.water_polo_game save];
}

- (void)waterPoloGameSaved:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Game Saved!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error saving game data!" delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)refreshBarButtonClicked:(id)sender {
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

- (void)textFieldWillBeginEditing:(UITextField *)textFied {
    textFied.text = @"";
}

@end
