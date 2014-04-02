//
//  EazesportzFootballReceivingTotalsViewController.m
//  EazeSportz
//
//  Created by Gil on 12/3/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzFootballReceivingTotalsViewController.h"
#import "FootballReceivingStat.h"
#import "EazesportzAppDelegate.h"

@interface EazesportzFootballReceivingTotalsViewController ()

@end

@implementation EazesportzFootballReceivingTotalsViewController {
    FootballReceivingStat *stat, *originalstat;
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
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"])
        self.view.backgroundColor = [UIColor clearColor];
    else
        self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"Receiving Totals";
    
    _attemptsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _yardsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _longestTextField.keyboardType = UIKeyboardTypeNumberPad;
    _fumblesLostTextField.keyboardType = UIKeyboardTypeNumberPad;
    _firstdownsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _fumblesTextField.keyboardType = UIKeyboardTypeNumberPad;
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
    
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"manager"]) {
        _playerImage.image = [currentSettings getRosterTinyImage:player];
        _playerName.text = player.logname;
        _playerNumber.text = [player.number stringValue];
    } else {
        _playerImage.image =[currentSettings getRosterThumbImage:player];
        _playerName.text = player.numberLogname;
    }
    
    
    stat = [player findFootballReceivingStat:game.id];
    
    if (stat.football_receiving_id.length > 0)
        originalstat = [stat copy];
    else
        originalstat = nil;
    
    _attemptsTextField.text = [stat.receptions stringValue];
    _fumblesTextField.text = [stat.fumbles stringValue];
    _fumblesLostTextField.text = [stat.fumbles_lost stringValue];
    _yardsTextField.text = [stat.yards stringValue];
    _firstdownsTextField.text = [stat.firstdowns stringValue];
    _longestTextField.text = [stat.longest stringValue];
    _tdTextField.text = [stat.td stringValue];
    _twopointconvTextField.text = [stat.twopointconv stringValue];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                          message:@"Updating Receiving Stats using totals will break automatic live scoring. \n Update totals with care. You should use this only if you are NOT entering stats during the game. \n Reciving totals are also automatically added when QB stats are entered if you use live stat updates." delegate:self
                                          cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)submitButtonClicked:(id)sender {
    stat.receptions = [NSNumber numberWithInt:[_attemptsTextField.text intValue]];
    stat.fumbles = [NSNumber numberWithInt:[_fumblesTextField.text intValue]];
    stat.yards = [NSNumber numberWithInt:[_yardsTextField.text intValue]];
    stat.fumbles_lost = [NSNumber numberWithInt:[_fumblesLostTextField.text intValue]];
    stat.firstdowns = [NSNumber numberWithInt:[_firstdownsTextField.text intValue]];
    stat.longest = [NSNumber numberWithInt:[_longestTextField.text intValue]];
    stat.td = [NSNumber numberWithInt:[_tdTextField.text intValue]];
    stat.twopointconv = [NSNumber numberWithInt:[_twopointconvTextField.text intValue]];
    
    [player updateFootballReceivingGameStats:stat];
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (IBAction)cancelButtonClicked:(id)sender {
    if (originalstat != nil)
        [player updateFootballReceivingGameStats:originalstat];
    
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


@end
