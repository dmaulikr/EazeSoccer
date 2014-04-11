//
//  EazesportzFootballReturnerTotalsViewController.m
//  EazeSportz
//
//  Created by Gil on 12/3/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzFootballReturnerTotalsViewController.h"
#import "FootballReturnerStats.h"
#import "EazesportzAppDelegate.h"

@interface EazesportzFootballReturnerTotalsViewController ()

@end

@implementation EazesportzFootballReturnerTotalsViewController{
    FootballReturnerStats *stat, *originalstat;
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
    self.title = @"Returner Totals";
    
    _puntreturnlongTextField.keyboardType = UIKeyboardTypeNumberPad;
    _puntreturntdTextField.keyboardType = UIKeyboardTypeNumberPad;
    _puntreturnTextField.keyboardType = UIKeyboardTypeNumberPad;
    _puntreturnyardsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _kickoffreturnlongTextField.keyboardType = UIKeyboardTypeNumberPad;
    _kickoffreturntdTextField.keyboardType = UIKeyboardTypeNumberPad;
    _kickoffreturnTextField.keyboardType = UIKeyboardTypeNumberPad;
    _kickoffreturnyardsTextField.keyboardType = UIKeyboardTypeNumberPad;
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
    
    stat = [player findFootballReturnerStat:game.id];
    
    _puntreturnyardsTextField.text = [stat.punt_returnyards stringValue];
    _puntreturnTextField.text = [stat.punt_return stringValue];
    _puntreturntdTextField.text = [stat.punt_returntd stringValue];
    _puntreturnlongTextField.text = [stat.punt_returnlong stringValue];
    
    if ([stat.punt_return intValue] > 0)
        _puntReturnAverageTextField.text = [NSString stringWithFormat:@"%.02f", [stat.punt_returnyards floatValue] / [stat.punt_return floatValue]];
    else
        _puntReturnAverageTextField.text = @"0.0";
    
    _kickoffreturnyardsTextField.text = [stat.koyards stringValue];
    _kickoffreturnTextField.text = [stat.koreturn stringValue];
    _kickoffreturntdTextField.text = [stat.kotd stringValue];
    _kickoffreturnlongTextField.text = [stat.kolong stringValue];
    
    if ([stat.koreturn intValue] > 0)
        _kickoffReturnAverageTextField.text = [NSString stringWithFormat:@"%.02f", [stat.koyards floatValue] / [stat.koreturn floatValue]];
    else
        _kickoffReturnAverageTextField.text = @"0.0";
}

- (IBAction)submitButtonClicked:(id)sender {
    stat.punt_return = [NSNumber numberWithInt:[_puntreturnTextField.text intValue]];
    stat.punt_returnlong = [NSNumber numberWithInt:[_puntreturnlongTextField.text intValue]];
    stat.punt_returntd = [NSNumber numberWithInt:[_puntreturntdTextField.text intValue]];
    stat.punt_returnyards = [NSNumber numberWithInt:[_puntreturnyardsTextField.text intValue]];
    stat.koreturn = [NSNumber numberWithInt:[_kickoffreturnTextField.text intValue]];
    stat.kolong = [NSNumber numberWithInt:[_kickoffreturnlongTextField.text intValue]];
    stat.kotd = [NSNumber numberWithInt:[_kickoffreturntdTextField.text intValue]];
    stat.koyards = [NSNumber numberWithInt:[_kickoffreturnyardsTextField.text intValue]];
    
    [stat saveStats];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Returner Stats Updated" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

- (IBAction)cancelButtonClicked:(id)sender {
    if (originalstat != nil)
        [player updateFootballReturnerGameStats:originalstat];
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (IBAction)saveBarButtonClicked:(id)sender {
    [self submitButtonClicked:sender];
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
