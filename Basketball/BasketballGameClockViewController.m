//
//  LiveGameSummaryViewController.m
//  Basketball Console
//
//  Created by Gil on 10/1/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "BasketballGameClockViewController.h"
#import "eazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"

#import<QuartzCore/QuartzCore.h>

@interface BasketballGameClockViewController ()

@end

@implementation BasketballGameClockViewController

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
    _firstPeriodButton.layer.cornerRadius = 8;
    _secondPeriodButton.layer.cornerRadius = 8;
    _thirdPeriodButton.layer.cornerRadius = 8;
    _fourthPeriodButton.layer.cornerRadius = 8;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (game.visitorbonus)
        _rightBonusImage.hidden = NO;
    else
        _rightBonusImage.hidden = YES;
    
    if (game.homebonus)
        _leftBonusImage.hidden = NO;
    else
        _leftBonusImage.hidden = YES;
    
    NSArray *spliArray = [game.currentgametime componentsSeparatedByString:@":"];
    _minutesTextField.text = [spliArray objectAtIndex:0];
    _secondsTextField.text = [spliArray objectAtIndex:1];
    _homeScoreTextField.text = [NSString stringWithFormat:@"%d", [currentSettings teamTotalPoints:game.id]];
    _homeFoulsTextField.text = [NSString stringWithFormat:@"%d", [currentSettings teamFouls:game.id]];
    _visitorScoreTextField.text = [NSString stringWithFormat:@"%d", [game.opponentscore intValue]];
    _visitorFoulsTextField.text = [NSString stringWithFormat:@"%d", [game.visitorfouls intValue]];
    
    switch ([game.period intValue]) {
        case 1:
            [self firstPeriodButtonClicked:self];
            break;
            
        case 2:
            [self secondPeriodButtonClicked:self];
            break;
            
        case 3:
            [self thirdPeriodButtonClicked:self];
            break;
            
        default:
            [self fourthPeriodButtonClicked:self];
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _homeScoreTextField) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Score automatically computed from stats!"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        [textField resignFirstResponder];
    } else if (textField == _homeFoulsTextField) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Fouls automatically computed from stats!"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        [textField resignFirstResponder];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ((textField == _minutesTextField) || (textField == _secondsTextField) || (textField == _homeFoulsTextField) ||
        (textField == _visitorFoulsTextField) || (textField == _homeScoreTextField) || (textField == _visitorScoreTextField)) {
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

- (IBAction)firstPeriodButtonClicked:(id)sender {
    _firstPeriodButton.backgroundColor = [UIColor redColor];
    _secondPeriodButton.backgroundColor = [UIColor whiteColor];
    _thirdPeriodButton.backgroundColor = [UIColor whiteColor];
    _fourthPeriodButton.backgroundColor = [UIColor whiteColor];
    _firstPeriodButton.selected = YES;
    _secondPeriodButton.selected = NO;
    _thirdPeriodButton.selected = NO;
    _fourthPeriodButton.selected = NO;
}

- (IBAction)secondPeriodButtonClicked:(id)sender {
    _firstPeriodButton.backgroundColor = [UIColor whiteColor];
    _secondPeriodButton.backgroundColor = [UIColor redColor];
    _thirdPeriodButton.backgroundColor = [UIColor whiteColor];
    _fourthPeriodButton.backgroundColor = [UIColor whiteColor];
    _firstPeriodButton.selected = NO;
    _secondPeriodButton.selected = YES;
    _thirdPeriodButton.selected = NO;
    _fourthPeriodButton.selected = NO;
}

- (IBAction)thirdPeriodButtonClicked:(id)sender {
    _firstPeriodButton.backgroundColor = [UIColor whiteColor];
    _secondPeriodButton.backgroundColor = [UIColor whiteColor];
    _thirdPeriodButton.backgroundColor = [UIColor redColor];
    _fourthPeriodButton.backgroundColor = [UIColor whiteColor];
    _firstPeriodButton.selected = NO;
    _secondPeriodButton.selected = NO;
    _thirdPeriodButton.selected = YES;
    _fourthPeriodButton.selected = NO;
}

- (IBAction)fourthPeriodButtonClicked:(id)sender {
    _firstPeriodButton.backgroundColor = [UIColor whiteColor];
    _secondPeriodButton.backgroundColor = [UIColor whiteColor];
    _thirdPeriodButton.backgroundColor = [UIColor whiteColor];
    _fourthPeriodButton.backgroundColor = [UIColor redColor];
    _firstPeriodButton.selected = NO;
    _secondPeriodButton.selected = NO;
    _thirdPeriodButton.selected = NO;
    _fourthPeriodButton.selected = YES;
}

- (IBAction)homeBonusButton:(id)sender {
    if (!_rightBonusImage.hidden) {
        _rightBonusImage.hidden = YES;
    } else {
        _rightBonusImage.hidden = NO;
    }
}

- (IBAction)visitorBonusButton:(id)sender {
    if (!_leftBonusImage.hidden) {
        _leftBonusImage.hidden = YES;
    } else {
        _leftBonusImage.hidden = NO;
    }
}
@end
