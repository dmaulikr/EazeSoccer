//
//  EazesportzFootballDefenseTotalsViewController.m
//  EazeSportz
//
//  Created by Gil on 12/2/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzFootballDefenseTotalsViewController.h"
#import "FootballDefenseStats.h"
#import "EazesportzAppDelegate.h"

@interface EazesportzFootballDefenseTotalsViewController ()

@end

@implementation EazesportzFootballDefenseTotalsViewController {
    FootballDefenseStats *stat, *originalstat;
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
    self.title = @"Defense Totals";
    
    _tacklesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _assistsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _sacksTextField.keyboardType = UIKeyboardTypeNumberPad;
    _sackAssistsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _passdefendedTextField.keyboardType = UIKeyboardTypeNumberPad;
    _interceptionsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _returnYardsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _returnTDTextField.keyboardType = UIKeyboardTypeNumberPad;
    _longestReturnTextField.keyboardType = UIKeyboardTypeNumberPad;
    _fumblesRecoveredTextField.keyboardType = UIKeyboardTypeNumberPad;
    _safetiesTextField.keyboardType = UIKeyboardTypeNumberPad;
    
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
    
    stat = [player findFootballDefenseStat:game.id];
    
    _tacklesTextField.text = [stat.tackles stringValue];
    _assistsTextField.text = [stat.assists stringValue];
    _sacksTextField.text = [stat.sacks stringValue];
    _sackAssistsTextField.text = [stat.sackassist stringValue];
    _passdefendedTextField.text = [stat.pass_defended stringValue];
    _interceptionsTextField.text = [stat.interceptions stringValue];
    _returnTDTextField.text = [stat.td stringValue];
    _returnYardsTextField.text = [stat.int_yards stringValue];
    _longestReturnTextField.text = [stat.int_long stringValue];
    _fumblesRecoveredTextField.text = [stat.fumbles_recovered stringValue];
    _safetiesTextField.text = [stat.safety stringValue];
}

- (IBAction)submitButtonClicked:(id)sender {
    stat.tackles = [NSNumber numberWithInt:[_tacklesTextField.text intValue]];
    stat.assists = [NSNumber numberWithInt:[_assistsTextField.text intValue]];
    stat.sackassist = [NSNumber numberWithInt:[_sackAssistsTextField.text intValue]];
    stat.sacks = [NSNumber numberWithInt:[_sacksTextField.text intValue]];
    stat.pass_defended = [NSNumber numberWithInt:[_passdefendedTextField.text intValue]];
    stat.interceptions = [NSNumber numberWithInt:[_interceptionsTextField.text intValue]];
    stat.td = [NSNumber numberWithInt:[_returnTDTextField.text intValue]];
    stat.int_yards = [NSNumber numberWithInt:[_returnYardsTextField.text intValue]];
    stat.int_long = [NSNumber numberWithInt:[_longestReturnTextField.text intValue]];
    stat.fumbles_recovered = [NSNumber numberWithInt:[_fumblesRecoveredTextField.text intValue]];
    stat.safety = [NSNumber numberWithInt:[_safetiesTextField.text intValue]];
    
    [stat saveStats];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Defensive Stats Updated" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

- (IBAction)cancelButtonClicked:(id)sender {
    if (originalstat != nil)
        [player updateFootballDefenseGameStats:originalstat];
    
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
