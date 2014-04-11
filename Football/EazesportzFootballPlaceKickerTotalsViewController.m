//
//  EazesportzFootballPlaceKickerTotalsViewController.m
//  EazeSportz
//
//  Created by Gil on 12/3/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzFootballPlaceKickerTotalsViewController.h"
#import "FootballPlaceKickerStats.h"
#import "EazesportzAppDelegate.h"

@interface EazesportzFootballPlaceKickerTotalsViewController ()

@end

@implementation EazesportzFootballPlaceKickerTotalsViewController {
    FootballPlaceKickerStats *stat, *originalstat;
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
    self.title = @"Place Kicker Totals";
    
    _fgattemptsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _fgmadeTextField.keyboardType = UIKeyboardTypeNumberPad;
    _fgblockedTextField.keyboardType = UIKeyboardTypeNumberPad;
    _fglongTextField.keyboardType = UIKeyboardTypeNumberPad;
    _xpattemptsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _xpblockedTextField.keyboardType = UIKeyboardTypeNumberPad;
    _xpmadeTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _playerImage.image = [currentSettings getRosterTinyImage:player];
    _playerName.text = player.numberLogname;
    _playerNumber.text = [player.number stringValue];
    
    stat = [player findFootballPlaceKickerStat:game.id];
    
    _fgattemptsTextField.text = [stat.fgattempts stringValue];
    _fgmadeTextField.text = [stat.fgmade stringValue];
    _fgblockedTextField.text = [stat.fgblocked stringValue];
    _fglongTextField.text = [stat.fglong stringValue];
    _xpattemptsTextField.text = [stat.xpattempts stringValue];
    _xpmadeTextField.text = [stat.xpmade stringValue];
    _xpblockedTextField.text = [stat.xpblocked stringValue];
    _pointsTextField.text = [NSString stringWithFormat:@"%d", ([stat.fgmade intValue] * 3) + [stat.xpmade intValue]];
}

- (IBAction)submitButtonClicked:(id)sender {
    stat.fgattempts = [NSNumber numberWithInt:[_fgattemptsTextField.text intValue]];
    stat.fgmade = [NSNumber numberWithInt:[_fgmadeTextField.text intValue]];
    stat.fgblocked = [NSNumber numberWithInt:[_fgblockedTextField.text intValue]];
    stat.fglong = [NSNumber numberWithInt:[_fglongTextField.text intValue]];
    stat.xpblocked = [NSNumber numberWithInt:[_xpblockedTextField.text intValue]];
    stat.xpattempts = [NSNumber numberWithInt:[_xpattemptsTextField.text intValue]];
    stat.xpmade = [NSNumber numberWithInt:[_xpmadeTextField.text intValue]];
    
    [stat saveStats];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Place Kicker Stats Updated" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

- (IBAction)cancelButtonClicked:(id)sender {
    if (originalstat != nil)
        [player updateFootballPlaceKickerGameStats:originalstat];
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (IBAction)saveBarButtonClicked:(id)sender {
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
