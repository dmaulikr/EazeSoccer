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

@interface BasketballTotalStatsViewController () <UIAlertViewDelegate>

@end

@implementation BasketballTotalStatsViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = [NSString stringWithFormat:@"%@%@%@", player.logname, @" Stats vs. ", game.opponent_mascot];
    
    if (game) {
        BasketballStats *stats = [player findBasketballGameStatEntries:game.id];
        _fgaTextField.text = [stats.twoattempt stringValue];
        _fgmTextField.text = [stats.twomade stringValue];
        
        if ([stats.twomade intValue] > 0)
            _fgpTextField.text = [NSString stringWithFormat:@"%.02f", (float)[stats.twomade intValue] / (float)[stats.twoattempt intValue]];
        else
            _fgpTextField.text = @"0.00";
        
        _threefgaTextField.text = [stats.threeattempt stringValue];
        _threefgmTextField.text = [stats.threemade stringValue];
        
        if ([stats.threemade intValue] > 0)
            _threefgpTextField.text = [NSString stringWithFormat:@"%02f", (float)[stats.threemade intValue] / (float)[stats.threeattempt intValue]];
        else
            _threefgpTextField.text = @"0.00";
        
        _ftaTextField.text = [stats.ftattempt stringValue];
        _ftmTextField.text = [stats.ftmade stringValue];
        
        if ([stats.ftmade intValue] > 0)
            _ftpTextField.text = [NSString stringWithFormat:@"%.02f", (float)[stats.ftmade intValue] / (float)[stats.ftattempt intValue]];
        else
            _ftpTextField.text = @"0.00";
        
        _pointsLabel.text = [NSString stringWithFormat:@"%d", ([stats.twomade intValue] * 2) + ([stats.threemade intValue] * 3) +
                             [stats.ftmade intValue]];
        _foulsTextField.text = [stats.fouls stringValue];
        _assistsTextField.text = [stats.assists stringValue];
        _stealsTextField.text = [stats.steals stringValue];
        _blocksTextField.text = [stats.blocks stringValue];
        _offrbTextField.text = [stats.offrebound stringValue];
        _defrbTextField.text = [stats.defrebound stringValue];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Game must be selected!"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }

}

- (IBAction)SubmitButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Update will override play by play stats. Use this to only enter total stats for a player."
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"]) {
        BasketballStats *stats = [player findBasketballGameStatEntries:game.id];
        
        if (!stats) {
            stats = [[BasketballStats alloc] init];
            stats.gameschedule_id = game.id;
        }
        
        NSURL *aurl;
        if (stats.basketball_stat_id.length > 0) {
//            aurl = [NSURL URLWithString:[BasketballServerInit updateBasketballStats:player.athleteid Statid:stats.basketball_stat_id
//                                                                              Token:currentSettings.user.authtoken]];
        } else {
//            aurl = [NSURL URLWithString:[BasketballServerInit newBasketballStat:player.athleteid Game:game.id Token:currentSettings.user.authtoken]];
        }
        
        NSMutableDictionary *statDict;
        statDict =  [[NSMutableDictionary alloc] initWithObjectsAndKeys: game.id, @"gameschedule_id",
                     _fgaTextField.text , @"twoattempt", _fgmTextField.text, @"twomade", _threefgaTextField.text, @"threeattempt",
                     _threefgmTextField.text, @"threemade", _ftaTextField.text, @"ftattempt", _ftmTextField.text, @"ftmade", _foulsTextField.text, @"fouls",
                     _assistsTextField.text, @"assists", _stealsTextField.text, @"steals", _blocksTextField.text, @"blocks",
                     _offrbTextField.text, @"offrebound", _defrbTextField.text, @"defrebound", @"Totals", @"livestats", nil];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aurl];
        NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:statDict, @"basketball_stat", nil];
        
        NSError *jsonSerializationError = nil;
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        if (stats.basketball_stat_id.length > 0) {
            [request setHTTPMethod:@"PUT"];
        } else {
            [request setHTTPMethod:@"POST"];
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:nil error:&jsonSerializationError];
        
        if (!jsonSerializationError) {
            NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"Serialized JSON: %@", serJson);
        } else {
            NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
        }
        
        [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:jsonData];
        
        //Capturing server response
        NSURLResponse* response;
        NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&jsonSerializationError];
        NSMutableDictionary *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:&jsonSerializationError];
        NSLog(@"%@", serverData);
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([httpResponse statusCode] == 200) {
            NSDictionary *items = [serverData objectForKey:@"bbstats"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update sucessful!" message:@"Stats updated"
                                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
            
            stats.twoattempt = [NSNumber numberWithInt:[[items objectForKey:@"twoattempt"] intValue]];
            stats.twomade = [NSNumber numberWithInt:[[items objectForKey:@"twomade"] intValue]];
            stats.threeattempt = [NSNumber numberWithInt:[[items objectForKey:@"threeattempt"] intValue]];
            stats.threemade = [NSNumber numberWithInt:[[items objectForKey:@"threemade"] intValue]];
            stats.ftattempt = [NSNumber numberWithInt:[[items objectForKey:@"ftattempt"] intValue]];
            stats.ftmade = [NSNumber numberWithInt:[[items objectForKey:@"ftmade"] intValue]];
            stats.fouls = [NSNumber numberWithInt:[[items objectForKey:@"fouls"] intValue]];
            stats.assists = [NSNumber numberWithInt:[[items objectForKey:@"assists"] intValue]];
            stats.steals = [NSNumber numberWithInt:[[items objectForKey:@"steals"] intValue]];
            stats.blocks = [NSNumber numberWithInt:[[items objectForKey:@"blocks"] intValue]];
            stats.offrebound = [NSNumber numberWithInt:[[items objectForKey:@"offrebound"] intValue]];
            stats.defrebound = [NSNumber numberWithInt:[[items objectForKey:@"defrebound"] intValue]];
//            [player updateGameStats:stats Game:game.id];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error updating Stats"
                                                            message:[NSString stringWithFormat:@"%d", [httpResponse statusCode]]
                                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
}

- (void)textDidBeginEditing:(UITextField *)textField {
    textField.text = @"";
}

@end
