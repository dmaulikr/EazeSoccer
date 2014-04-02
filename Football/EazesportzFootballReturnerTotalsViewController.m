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
    self.view.backgroundColor = [UIColor clearColor];
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
    _playerName.text = player.logname;
    _playerNumber.text = [player.number stringValue];
    
    stat = [player findFootballReturnerStat:game.id];
    
    if (stat.football_returner_id.length > 0)
        originalstat = [stat copy];
    else
        originalstat = nil;
    
    _puntreturnyardsTextField.text = [stat.punt_returnyards stringValue];
    _puntreturnTextField.text = [stat.punt_return stringValue];
    _puntreturntdTextField.text = [stat.punt_returntd stringValue];
    _puntreturnlongTextField.text = [stat.punt_returnlong stringValue];
    _kickoffreturnyardsTextField.text = [stat.koyards stringValue];
    _kickoffreturnTextField.text = [stat.koreturn stringValue];
    _kickoffreturntdTextField.text = [stat.kotd stringValue];
    _kickoffreturnlongTextField.text = [stat.kolong stringValue];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Updating Return Stats using totals will break automatic live scoring. \n Update totals with care. You should use this only if you are NOT entering stats during the game." delegate:self
                                          cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
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
    
    [player updateFootballReturnerGameStats:stat];
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (IBAction)cancelButtonClicked:(id)sender {
    if (originalstat != nil)
        [player updateFootballReturnerGameStats:originalstat];
    
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
