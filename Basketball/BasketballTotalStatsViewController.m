//
//  PlayerStatisticsViewController.m
//  Basketball Console
//
//  Created by Gil on 9/23/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "BasketballTotalStatsViewController.h"
#import "EazesportzAppDelegate.h"
#import "BasketballStats.h"

@interface BasketballTotalStatsViewController ()

@end

@implementation BasketballTotalStatsViewController {
    BasketballStats *originalStats;
}

@synthesize player;
@synthesize game;
@synthesize stats;

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
    
    _fgmTextField.keyboardType = UIKeyboardTypeNumberPad;
    _fgaTextField.keyboardType = UIKeyboardTypeNumberPad;
    _threefgmTextField.keyboardType = UIKeyboardTypeNumberPad;
    _threefgaTextField.keyboardType = UIKeyboardTypeNumberPad;
    _ftmTextField.keyboardType = UIKeyboardTypeNumberPad;
    _ftaTextField.keyboardType = UIKeyboardTypeNumberPad;
    _foulsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _assistsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _stealsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _blocksTextField.keyboardType = UIKeyboardTypeNumberPad;
    _offrbTextField.keyboardType = UIKeyboardTypeNumberPad;
    _defrbTextField.keyboardType = UIKeyboardTypeNumberPad;
    _turnoverTextField.keyboardType = UIKeyboardTypeNumberPad;
    _stealsTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    _threefgpTextField.enabled = NO;
    _fgpTextField.enabled = NO;
    _ftpTextField.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _playernameLabel.text = [NSString stringWithFormat:@"%@%@%@", player.logname, @" Stats vs. ", game.opponent_mascot];
    
    self.title = player.numberLogname;
    stats = [player findBasketballGameStatEntries:game.id];
    originalStats = [stats copy];
    _fgaTextField.text = [stats.twoattempt stringValue];
    _fgmTextField.text = [stats.twomade stringValue];
    _threefgaTextField.text = [stats.threeattempt stringValue];
    _threefgmTextField.text = [stats.threemade stringValue];
    _ftaTextField.text = [stats.ftattempt stringValue];
    _ftmTextField.text = [stats.ftmade stringValue];
    _foulsTextField.text = [stats.fouls stringValue];
    _assistsTextField.text = [stats.assists stringValue];
    _stealsTextField.text = [stats.steals stringValue];
    _blocksTextField.text = [stats.blocks stringValue];
    _offrbTextField.text = [stats.offrebound stringValue];
    _defrbTextField.text = [stats.defrebound stringValue];
    _turnoverTextField.text = [stats.turnovers stringValue];
    _stealsTextField.text = [stats.steals stringValue];
    
    if ([stats.twomade intValue] > 0)
        _fgpTextField.text = [NSString stringWithFormat:@"%.02f", [stats.twomade floatValue] / [stats.twoattempt floatValue]];
    else
        _fgpTextField.text = @"0.0";

    if ([stats.threemade intValue] > 0)
        _threefgpTextField.text = [NSString stringWithFormat:@"%.02f", [stats.threemade floatValue] / [stats.threeattempt floatValue]];
    else
        _threefgpTextField.text = @"0.0";
    
    if ([stats.ftmade intValue] > 0)
        _ftpTextField.text = [NSString stringWithFormat:@"%.02f", [stats.ftmade floatValue] / [stats.ftattempt floatValue]];
    else
        _ftpTextField.text = @"0.0";
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = @"";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (!_submitButton.touchInside) {
        stats = originalStats;
    } else {
        stats.twoattempt = [NSNumber numberWithInt:[_fgaTextField.text intValue]];
        stats.twomade = [NSNumber numberWithInt:[_fgmTextField.text intValue]];
        stats.threeattempt = [NSNumber numberWithInt:[_threefgaTextField.text intValue]];
        stats.threemade = [NSNumber numberWithInt:[_threefgmTextField.text intValue]];
        stats.ftattempt = [NSNumber numberWithInt:[_ftaTextField.text intValue]];
        stats.ftmade = [NSNumber numberWithInt:[_ftmTextField.text intValue]];
        stats.fouls = [NSNumber numberWithInt:[_foulsTextField.text intValue]];
        stats.assists = [NSNumber numberWithInt:[_assistsTextField.text intValue]];
        stats.steals = [NSNumber numberWithInt:[_stealsTextField.text intValue]];
        stats.blocks = [NSNumber numberWithInt:[_blocksTextField.text intValue]];
        stats.offrebound = [NSNumber numberWithInt:[_offrbTextField.text intValue]];
        stats.defrebound = [NSNumber numberWithInt:[_defrbTextField.text intValue]];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
    NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
    
    if (myStringMatchesRegEx)
        return YES;
    else
        return NO;
}

- (IBAction)submitButtonClicked:(id)sender {
    [stats saveStats];
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

@end
