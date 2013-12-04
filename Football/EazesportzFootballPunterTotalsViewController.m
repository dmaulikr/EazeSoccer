//
//  EazesportzFootballPunterTotalsViewController.m
//  EazeSportz
//
//  Created by Gil on 12/3/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzFootballPunterTotalsViewController.h"
#import "FootballPunterStats.h"

@interface EazesportzFootballPunterTotalsViewController ()

@end

@implementation EazesportzFootballPunterTotalsViewController {
    FootballPunterStats *stat, *originalstat;
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
    self.title = @"Punter Totals";
    
    _puntblockedTextField.keyboardType = UIKeyboardTypeNumberPad;
    _puntslongTextField.keyboardType = UIKeyboardTypeNumberPad;
    _puntsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _puntsyardsTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _playerImage.image = [player getImage:@"tiny"];
    _playerName.text = player.logname;
    _playerNumber.text = [player.number stringValue];
    
    stat = [player findFootballPunterStat:game.id];
    
    if (stat.football_punter_id.length > 0)
        originalstat = [stat copy];
    else
        originalstat = nil;
    
    _puntsyardsTextField.text = [stat.punts_yards stringValue];
    _puntsTextField.text = [stat.punts stringValue];
    _puntslongTextField.text = [stat.punts_long stringValue];
    _puntblockedTextField.text = [stat.punts_blocked stringValue];
}

- (IBAction)submitButtonClicked:(id)sender {
    stat.punts = [NSNumber numberWithInt:[_puntsTextField.text intValue]];
    stat.punts_blocked = [NSNumber numberWithInt:[_puntblockedTextField.text intValue]];
    stat.punts_long = [NSNumber numberWithInt:[_puntslongTextField.text intValue]];
    stat.punts_yards = [NSNumber numberWithInt:[_puntsyardsTextField.text intValue]];
    
    [player updateFootballPunterGameStats:stat];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)cancelButtonClicked:(id)sender {
    if (originalstat != nil)
        [player updateFootballPunterGameStats:originalstat];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
