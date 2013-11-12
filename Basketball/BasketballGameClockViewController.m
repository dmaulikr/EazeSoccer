//
//  LiveGameSummaryViewController.m
//  Basketball Console
//
//  Created by Gil on 10/1/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "BasketballGameClockViewController.h"
#import "EazesportzAppDelegate.h"

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
    
    _hometeamImage.image = [currentSettings.team getImage:@"thumb"];
    _visitorImage.image = [game opponentImage];
    _hometeamLabel.text = currentSettings.team.mascot;
    _visitorteamLabel.text = game.opponent_mascot;
    
    if (game.visitorbonus)
        _rightBonusImage.hidden = NO;
    else
        _rightBonusImage.hidden = YES;
    
    if (game.homebonus)
        _leftBonusImage.hidden = NO;
    else
        _leftBonusImage.hidden = YES;
    
    if ([game.possession isEqualToString:@"Home"]) {
        _homePossessionArrow.hidden = NO;
        _visitorPossessionArrow.hidden = YES;
    } else {
        _homePossessionArrow.hidden = YES;
        _visitorPossessionArrow.hidden = NO;
    }
    
    NSArray *splitArray = [game.currentgametime componentsSeparatedByString:@":"];
    _gameclockLabel.text = game.currentgametime;
    _minutesTextField.text = [splitArray objectAtIndex:0];
    _secondsTextField.text = [splitArray objectAtIndex:1];
    _gameclockLabel.text = [NSString stringWithFormat:@"%@%@%@", _minutesTextField.text, @":", _secondsTextField.text];
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

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _minutesTextField) {
        game.currentgametime = _gameclockLabel.text = [NSString stringWithFormat:@"%@%@%@", _minutesTextField.text, @":", _secondsTextField.text];
    } else if (textField == _secondsTextField) {
        game.currentgametime = _gameclockLabel.text = [NSString stringWithFormat:@"%@%@%@", _minutesTextField.text, @":", _secondsTextField.text];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ((textField == _minutesTextField) || (textField == _secondsTextField) || (textField == _homeFoulsTextField) ||
        (textField == _visitorFoulsTextField) || (textField == _homeScoreTextField) || (textField == _visitorScoreTextField)) {
        NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        if (myStringMatchesRegEx)
            
            if ((textField == _minutesTextField) || (textField == _secondsTextField)) {
                return (newLength > 2) ? NO : YES;
            } else {
                return (newLength > 3) ? NO : YES;
            }
        else
            return NO;
    } else
        return YES;
}

- (IBAction)firstPeriodButtonClicked:(id)sender {
    game.period = [NSNumber numberWithInt: 1];
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
    game.period = [NSNumber numberWithInt: 2];
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
    game.period = [NSNumber numberWithInt: 3];
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
    game.period = [NSNumber numberWithInt: 4];
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
    if (!_leftBonusImage.hidden) {
        _leftBonusImage.hidden = YES;
        game.visitorbonus = YES;
    } else {
        _leftBonusImage.hidden = NO;
        game.visitorbonus = NO;
    }
 }

- (IBAction)visitorBonusButton:(id)sender {
    if (!_rightBonusImage.hidden) {
        _rightBonusImage.hidden = YES;
       game.homebonus = YES;
    } else {
        _rightBonusImage.hidden = NO;
        game.homebonus = NO;
    }
}

- (IBAction)saveButtonClicked:(id)sender {
    game.opponentscore = [NSNumber numberWithInt:[_visitorScoreTextField.text intValue]];
    game.visitorfouls = [NSNumber numberWithInt:[_visitorFoulsTextField.text intValue]];
    [game saveGameschedule];
}

- (IBAction)possessionArrorButtonClicked:(id)sender {
    if ([game.possession isEqualToString:@"Home"]) {
        _homePossessionArrow.hidden = YES;
        _visitorPossessionArrow.hidden = NO;
        game.possession = @"Visitor";
    } else {
        _homePossessionArrow.hidden = NO;
        _visitorPossessionArrow.hidden = YES;
        game.possession = @"Home";
    }
}

@end
