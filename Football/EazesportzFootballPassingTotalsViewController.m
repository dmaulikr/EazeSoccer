//
//  EazesportzFootballPassingTotalsViewController.m
//  EazeSportz
//
//  Created by Gil on 12/2/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzFootballPassingTotalsViewController.h"
#import "FootballPassingStat.h"
#import "EazesportzAppDelegate.h"

@interface EazesportzFootballPassingTotalsViewController ()

@end

@implementation EazesportzFootballPassingTotalsViewController {
    FootballPassingStat *stat, *originalstat;
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
    self.view.backgroundColor = [UIColor clearColor];
    self.title = @"Passing Totals";
    
    _attemptsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _completionsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _yardslostTextField.keyboardType = UIKeyboardTypeNumberPad;
    _yardsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _firstdownsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _sacksTextField.keyboardType = UIKeyboardTypeNumberPad;
    _tdTextField.keyboardType = UIKeyboardTypeNumberPad;
    _twopointconvTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _playerImage.image = [currentSettings getRosterTinyImage:player];
    _playerName.text = player.logname;
    _playerNumber.text = [player.number stringValue];
    
    stat = [player findFootballPassingStat:game.id];
    
    if (stat.football_passing_id.length > 0)
        originalstat = [stat copy];
    else
        originalstat = nil;
    
    _attemptsTextField.text = [stat.attempts stringValue];
    _completionsTextField.text = [stat.completions stringValue];
    _yardslostTextField.text = [stat.yards_lost stringValue];
    _yardsTextField.text = [stat.yards stringValue];
    _firstdownsTextField.text = [stat.firstdowns stringValue];
    _sacksTextField.text = [stat.sacks stringValue];
    _tdTextField.text = [stat.td stringValue];
    _twopointconvTextField.text = [stat.twopointconv stringValue];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                         message:@"Updating Passing Stats using totals will break automatic live scoring. \n Update totals with care. You should use this only if you are not entering stats during the game." delegate:self
                         cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)submitButtonClicked:(id)sender {
    stat.attempts = [NSNumber numberWithInt:[_attemptsTextField.text intValue]];
    stat.completions = [NSNumber numberWithInt:[_completionsTextField.text intValue]];
    stat.yards = [NSNumber numberWithInt:[_yardsTextField.text intValue]];
    stat.yards_lost = [NSNumber numberWithInt:[_yardslostTextField.text intValue]];
    stat.firstdowns = [NSNumber numberWithInt:[_firstdownsTextField.text intValue]];
    stat.sacks = [NSNumber numberWithInt:[_sacksTextField.text intValue]];
    stat.td = [NSNumber numberWithInt:[_tdTextField.text intValue]];
    stat.twopointconv = [NSNumber numberWithInt:[_twopointconvTextField.text intValue]];
    
    [player updateFootballPassingGameStats:stat];
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (IBAction)cancelButtonClicked:(id)sender {
    if (originalstat != nil)
        [player updateFootballPassingGameStats:originalstat];
    
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

@end
