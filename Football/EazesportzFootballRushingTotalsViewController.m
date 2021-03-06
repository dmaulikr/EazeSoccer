//
//  EazesportzFootballRushingTotalsViewController.m
//  EazeSportz
//
//  Created by Gil on 12/2/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzFootballRushingTotalsViewController.h"
#import "FootballRushingStat.h"
#import "EazesportzAppDelegate.h"

@interface EazesportzFootballRushingTotalsViewController ()

@end

@implementation EazesportzFootballRushingTotalsViewController {
    FootballRushingStat *stat, *originalstat;
}

@synthesize player;
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
    self.title = @"Rushing Totals";
    
    _attemptsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _yardsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _longestTextField.keyboardType = UIKeyboardTypeNumberPad;
    _fumblesLostTextField.keyboardType = UIKeyboardTypeNumberPad;
    _firstdownsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _fumblesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _tdTextField.keyboardType = UIKeyboardTypeNumberPad;
    _twopointconvTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    [_playerImage setClipsToBounds:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) {
        _playerImage.image = [currentSettings getRosterTinyImage:player];
        _playerName.text = player.numberLogname;
    } else {
        _playerImage.image = [currentSettings getRosterMediumImage:player];
        _playerName.text = [NSString stringWithFormat:@"%@ vs %@", player.numberLogname, game.opponent_mascot];
        _playerNumber.text = [player.number stringValue];
    }
    
    stat = [player findFootballRushingStat:game.id];
    
    _attemptsTextField.text = [stat.attempts stringValue];
    _fumblesTextField.text = [stat.fumbles stringValue];
    _fumblesLostTextField.text = [stat.fumbles_lost stringValue];
    _yardsTextField.text = [stat.yards stringValue];
    _firstdownsTextField.text = [stat.firstdowns stringValue];
    _longestTextField.text = [stat.longest stringValue];
    _tdTextField.text = [stat.td stringValue];
    _twopointconvTextField.text = [stat.twopointconv stringValue];
    
    if ([stat.attempts intValue] > 0)
        _averageTextField.text = [NSString stringWithFormat:@"%.02f", [stat.yards floatValue] / [stat.attempts floatValue]];
    else
        _averageTextField.text = @"0.0";
}

- (IBAction)saveBarButtonClicked:(id)sender {
    [self submitButtonClicked:sender];
}

- (IBAction)submitButtonClicked:(id)sender {
    stat.attempts = [NSNumber numberWithInt:[_attemptsTextField.text intValue]];
    stat.fumbles = [NSNumber numberWithInt:[_fumblesTextField.text intValue]];
    stat.yards = [NSNumber numberWithInt:[_yardsTextField.text intValue]];
    stat.fumbles_lost = [NSNumber numberWithInt:[_fumblesLostTextField.text intValue]];
    stat.firstdowns = [NSNumber numberWithInt:[_firstdownsTextField.text intValue]];
    stat.longest = [NSNumber numberWithInt:[_longestTextField.text intValue]];
    stat.td = [NSNumber numberWithInt:[_tdTextField.text intValue]];
    stat.twopointconv = [NSNumber numberWithInt:[_twopointconvTextField.text intValue]];
    
    [stat saveStats];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Rushing Stats Updated" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

- (IBAction)cancelButtonClicked:(id)sender {
    if (originalstat != nil)
        [player updateFootballRushingGameStats:originalstat];
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
    NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (myStringMatchesRegEx) {
        return (newLength > 3) ? NO : YES;
    } else
        return  NO;
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

@end
