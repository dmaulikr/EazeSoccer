//
//  EazeAddPlayerStatsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 3/28/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazeAddPlayerStatsViewController.h"

#import "EazesportzFootballPassingTotalsViewController.h"
#import "EazesportzFootballRushingTotalsViewController.h"
#import "EazesportzFootballDefenseTotalsViewController.h"
#import "EazesportzFootballPlaceKickerTotalsViewController.h"
#import "EazesportzFootballKickerTotalsViewController.h"
#import "EazesportzFootballPunterTotalsViewController.h"
#import "EazesportzFootballReturnerTotalsViewController.h"
#import "EazesportzFootballReceivingTotalsViewController.h"

#import "EazesportzAppDelegate.h"
#import "PlayerSelectionViewController.h"
#import "EazeFootballPlayerStatsViewController.h"

@interface EazeAddPlayerStatsViewController ()

@end

@implementation EazeAddPlayerStatsViewController {
    BOOL addstats, touchdown, safety, twopoint, interception, fumblerecovered, fieldgoal, xpmade, puntreturn,
         koreturn, completion;
    Athlete *receiver;
    PlayerSelectionViewController *playerSelectController;
}

@synthesize athlete;
@synthesize game;
@synthesize position;

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
    _yardsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _quarterStatTextField.keyboardType = UIKeyboardTypeNumberPad;
    _minutesStatTextField.keyboardType = UIKeyboardTypeNumberPad;
    _secondsStatTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    _receiverTextField.inputView = playerSelectController.inputView;
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _playerImageView.image = [currentSettings getRosterThumbImage:athlete];
    _playerSelectContainer.hidden = YES;
    addstats = YES;
    NSString *pos;
    
    if ([position isEqualToString:@"Pass"])
        pos = @"Passing";
    else if ([position isEqualToString:@"Rush"])
        pos = @"Rushing";
    else if ([position isEqualToString:@"Rec"])
        pos = @"Receiving";
    else if ([position isEqualToString:@"Def"])
        pos = @"Defense";
    else if ([position isEqualToString:@"PK"])
        pos = @"Place Kicker";
    else if ([position isEqualToString:@"Kick"])
        pos = @"Kicker";
    else if ([position isEqualToString:@"Punt"])
        pos = @"Punter";
    else if ([position isEqualToString:@"Ret"])
        pos = @"Returner";
    
    [self displayStats];
    
    self.title = [NSString stringWithFormat:@"%@ - %@", athlete.logname, pos];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayerSelectSegue"]) {
        playerSelectController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"PlayerTotalStatsSegue"]) {
        EazeFootballPlayerStatsViewController *destController = segue.destinationViewController;
        destController.player = athlete;
    }
}

- (IBAction)playerSelected:(UIStoryboardSegue *)segue {
    if (playerSelectController.player) {
        Athlete *player = playerSelectController.player;
        _receiverTextField.text = player.logname;
        receiver = player;
    }
    
    _playerSelectContainer.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _receiverTextField) {
        [textField resignFirstResponder];
    }
}

- (IBAction)refreshButtonClicked:(id)sender {
    if (athlete) {
        Athlete *newplayer = [currentSettings retrievePlayer:athlete.athleteid];
        [currentSettings replaceAthleteById:newplayer];
        athlete = newplayer;
        [self displayStats];
    }
}

- (IBAction)buttonOneClicked:(id)sender {
    if ([position isEqualToString:@"Pass"]) {
        FootballPassingStat *stat = [athlete findFootballPassingStat:game.id];
        
        if (addstats)
            stat.attempts = [NSNumber numberWithInt:[stat.attempts intValue] + 1];
        else if ([stat.attempts intValue] > 0)
            stat.attempts = [NSNumber numberWithInt:[stat.attempts intValue] - 1];
        
        _statData2.text = [stat.attempts stringValue];
    } else if ([position isEqualToString:@"Rush"]) {
        FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
        
        if (addstats) {
            stat.attempts = [NSNumber numberWithInt:[stat.attempts intValue] + 1];
            [self yardStats:NO];
        } else if ([stat.attempts intValue] > 0) {
            stat.attempts = [NSNumber numberWithInt:[stat.attempts intValue] - 1];
            [self yardStats:YES];
        }
        
        _statData1.text = [stat.attempts stringValue];
    } else if ([position isEqualToString:@"Def"]) {
        FootballDefenseStats *stat = [athlete findFootballDefenseStat:game.id];
        
        if (addstats) {
            stat.tackles = [NSNumber numberWithInt:[stat.tackles intValue] + 1];
            game.lastplay = [NSString stringWithFormat:@"%@ - Tackle", athlete.logname];
        } else if ([stat.tackles intValue] > 0) {
            stat.tackles = [NSNumber numberWithInt:[stat.tackles intValue] - 1];
            game.lastplay = @"";
        }
        
        _statData1.text = [stat.tackles stringValue];
    } else if ([position isEqualToString:@"PK"]) {
        FootballPlaceKickerStats *stat = [athlete findFootballPlaceKickerStat:game.id];
        
        if (addstats)
            stat.fgattempts= [NSNumber numberWithInt:[stat.fgattempts intValue] + 1];
        else
            stat.fgattempts= [NSNumber numberWithInt:[stat.fgattempts intValue] - 1];
        
        _statData1.text = [stat.fgattempts stringValue];
    } else if ([position isEqualToString:@"Kick"]) {
        FootballKickerStats *stat = [athlete findFootballKickerStat:game.id];
        koreturn = YES;
        
        if (addstats) {
            stat.koattempts = [NSNumber numberWithInt:[stat.koattempts intValue] + 1];
            stat.koreturned = [NSNumber numberWithInt:[stat.koreturned intValue] + 1];
        } else {
            stat.koattempts = [NSNumber numberWithInt:[stat.koattempts intValue] - 1];
            stat.koreturned = [NSNumber numberWithInt:[stat.koreturned intValue] - 1];
        }
        
        _statData2.text = [stat.koattempts stringValue];
        _statData3.text = [stat.koreturned stringValue];
    } else if ([position isEqualToString:@"Ret"]) {
        FootballReturnerStats *stat = [athlete findFootballReturnerStat:game.id];
        
        if (addstats) {
            [self yardStats:NO];
            stat.koreturn = [NSNumber numberWithInt:[stat.koreturn intValue] + 1];
            koreturn = YES;
        } else {
            [self yardStats:YES];
            stat.koreturn = [NSNumber numberWithInt:[stat.koreturn intValue] - 1];
            koreturn = NO;
        }
        
        _statData1.text = [stat.koreturn stringValue];
    } else {
        FootballPunterStats *stat = [athlete findFootballPunterStat:game.id];
        
        if (addstats) {
            [self yardStats:NO];
            stat.punts = [NSNumber numberWithInt:[stat.punts intValue] + 1];
        } else {
            [self yardStats:YES];
            stat.punts = [NSNumber numberWithInt:[stat.punts intValue] - 1];
        }
        
        _statData1.text = [stat.punts stringValue];
    }
}

- (IBAction)buttonTwoClicked:(id)sender {
    if (([position isEqualToString:@"Pass"])) {
        FootballPassingStat *stat = [athlete findFootballPassingStat:game.id];
        
        if (addstats) {
            stat.completions = [NSNumber numberWithInt:[stat.completions intValue] + 1];
            stat.attempts = [NSNumber numberWithInt:[stat.attempts intValue] + 1];
            _receiverTextField.hidden = NO;
            _receiverTextField.enabled = YES;
            _playerSelectContainer.hidden = NO;
            completion = YES;
            [self yardStats:NO];
            [self fumbleStats:NO];
            playerSelectController.player = nil;
            [playerSelectController viewWillAppear:YES];
        } else if ([stat.completions intValue] > 0) {
            stat.completions = [NSNumber numberWithInt:[stat.completions intValue] - 1];
            stat.attempts = [NSNumber numberWithInt:[stat.attempts intValue] - 1];
            _receiverTextField.hidden = YES;
            _receiverTextField.enabled = NO;
            _receiverTextField.text = @"";
            _playerSelectContainer.hidden = YES;
            completion = NO;
            [self yardStats:YES];
            [self fumbleStats:YES];
        }
        
        _statData1.text = [stat.completions stringValue];
        _statData2.text = [stat.attempts stringValue];
    } else if ([position isEqualToString:@"Rush"]) {
        FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
        
        if (addstats )
            stat.firstdowns = [NSNumber numberWithInt:[stat.firstdowns intValue] + 1];
        else if ([stat.firstdowns intValue] > 0)
            stat.firstdowns = [NSNumber numberWithInt:[stat.firstdowns intValue] - 1];
        
        _statData6.text = [stat.firstdowns stringValue];
    } else if ([position isEqualToString:@"Def"]) {
        FootballDefenseStats *stat = [athlete findFootballDefenseStat:game.id];
        
        if (addstats) {
            stat.assists = [NSNumber numberWithInt:[stat.assists intValue] + 1];
            game.lastplay = [NSString stringWithFormat:@"%@ - Tackle Assist", athlete.logname];
        } else if ([stat.assists intValue] > 0) {
            stat.assists = [NSNumber numberWithInt:[stat.assists intValue] - 1];
            game.lastplay = @"";
        }
        
        _statData2.text = [stat.assists stringValue];
    } else if ([position isEqualToString:@"PK"]) {
        FootballPlaceKickerStats *stat = [athlete findFootballPlaceKickerStat:game.id];
        
        if (addstats) {
            stat.fgattempts= [NSNumber numberWithInt:[stat.fgattempts intValue] + 1];
            stat.fgmade = [NSNumber numberWithInt:[stat.fgmade intValue] + 1];
            fieldgoal = YES;
            [self yardStats:NO];
            [self scoreStats:NO];
        } else {
            stat.fgattempts= [NSNumber numberWithInt:[stat.fgattempts intValue] - 1];
            stat.fgmade = [NSNumber numberWithInt:[stat.fgmade intValue] - 1];
            fieldgoal = NO;
            [self yardStats:YES];
            [self scoreStats:YES];
        }
        
        _statData1.text = [stat.fgattempts stringValue];
        _statData2.text = [stat.fgmade stringValue];
    } else if ([position isEqualToString:@"Kick"]) {
        FootballKickerStats *stat = [athlete findFootballKickerStat:game.id];
        
        if (addstats) {
            stat.koreturned = [NSNumber numberWithInt:[stat.koattempts intValue] - 1];
            stat.kotouchbacks = [NSNumber numberWithInt:[stat.kotouchbacks intValue] + 1];
        } else if ([stat.kotouchbacks intValue] > 0){
            stat.kotouchbacks = [NSNumber numberWithInt:[stat.kotouchbacks intValue] - 1];
        }
        
        _statData3.text = [stat.koreturned stringValue];
        _statData4.text = [stat.kotouchbacks stringValue];
    } else if ([position isEqualToString:@"Ret"]) {
        FootballReturnerStats *stat = [athlete findFootballReturnerStat:game.id];
        
        if (addstats) {
            [self yardStats:NO];
            stat.punt_return = [NSNumber numberWithInt:[stat.punt_return intValue] + 1];
            puntreturn = YES;
        } else if ([stat.punt_return intValue] > 0) {
            [self yardStats:YES];
            stat.punt_return = [NSNumber numberWithInt:[stat.punt_return intValue] - 1];
            puntreturn = NO;
        }
        
        _statData6.text = [stat.punt_return stringValue];
    } else {
        FootballPunterStats *stat = [athlete findFootballPunterStat:game.id];
        [self yardStats:YES];
        
        if (addstats) {
            stat.punts_blocked = [NSNumber numberWithInt:[stat.punts_blocked intValue] + 1];
            stat.punts = [NSNumber numberWithInt:[stat.punts intValue] + 1];
        } else if (([stat.punts_blocked intValue] > 0) && ([stat.punts intValue] > 0)) {
            stat.punts_blocked = [NSNumber numberWithInt:[stat.punts_blocked intValue] - 1];
            stat.punts = [NSNumber numberWithInt:[stat.punts intValue] - 1];
        }
        
        _statData4.text = [stat.punts_blocked stringValue];
        _statData1.text = [stat.punts stringValue];
    }
}

- (IBAction)buttonThreeClicked:(id)sender {
    if (([position isEqualToString:@"Pass"])) {
        FootballPassingStat *stat = [athlete findFootballPassingStat:game.id];
        
        if (addstats) {
            stat.sacks = [NSNumber numberWithInt:[stat.sacks intValue] + 1];
            [self yardStats:YES];
        } else if ([stat.sacks intValue] > 0) {
            [self yardStats:NO];
            stat.sacks = [NSNumber numberWithInt:[stat.sacks intValue] - 1];
        }
        
        _statData8.text = [stat.sacks stringValue];
    } else if ([position isEqualToString:@"Rush"]) {
        FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
        
        if ((addstats) && (!_yardsTextField.hidden)) {
            stat.td = [NSNumber numberWithInt:[stat.td intValue] + 1];
            touchdown = YES;
            [self scoreStats:NO];
        } else if (_yardsTextField.hidden) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Enter rush attempt and yards first!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        } else if ([stat.td intValue] > 0) {
            stat.td = [NSNumber numberWithInt:[stat.td intValue] - 1];
            touchdown = NO;
            [self scoreStats:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"  message:@"If you already saved a score you should delete the game log to adjust stats. Stats will be automatically updated!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else if ([position isEqualToString:@"Def"]) {
        FootballDefenseStats *stat = [athlete findFootballDefenseStat:game.id];
        
        if (addstats) {
            stat.sacks = [NSNumber numberWithInt:[stat.sacks intValue] + 1];
            game.lastplay = [NSString stringWithFormat:@"%@ - Sack", athlete.logname];
        } else if ([stat.sacks intValue] > 0) {
            stat.sacks = [NSNumber numberWithInt:[stat.sacks intValue] - 1];
            game.lastplay = @"";
        }
        
        _statData3.text = [stat.sacks stringValue];
    } else if ([position isEqualToString:@"PK"]) {
        FootballPlaceKickerStats *stat = [athlete findFootballPlaceKickerStat:game.id];
        
        if (addstats)
            stat.fgblocked = [NSNumber numberWithInt:[stat.fgblocked intValue] + 1];
        else if ([stat.fgblocked intValue] > 0)
            stat.fgblocked = [NSNumber numberWithInt:[stat.fgblocked intValue] - 1];
        
        _statData3.text = [stat.fgblocked stringValue];
    } else if ([position isEqualToString:@"Ret"]) {
        if ((puntreturn) || (koreturn)) {
            FootballReturnerStats *stat = [athlete findFootballReturnerStat:game.id];
            
            if (addstats) {
                touchdown = YES;
                [self scoreStats:NO];
                if (puntreturn) {
                    stat.punt_returntd = [NSNumber numberWithInt:[stat.punt_returntd intValue] + 1];
                    _statData8.text = [stat.punt_returntd stringValue];
                } else {
                    stat.kotd = [NSNumber numberWithInt:[stat.kotd intValue] + 1];
                    _statData3.text = [stat.kotd stringValue];
                }
            } else {
                touchdown = NO;
                [self scoreStats:YES];
                if ((puntreturn) && ([stat.punt_returntd intValue] > 0)) {
                    stat.punt_returntd = [NSNumber numberWithInt:[stat.punt_returntd intValue] - 1];
                    _statData8.text = [stat.punt_returntd stringValue];
                } else if ((koreturn) && ([stat.kotd intValue] > 0)) {
                    stat.kotd = [NSNumber numberWithInt:[stat.kotd intValue] - 1];
                    _statData3.text = [stat.kotd stringValue];
                }
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Please select punt or kickoff return before posting TD!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
}

- (IBAction)buttonFourClicked:(id)sender {
    if ([position isEqualToString:@"Pass"]) {
        FootballPassingStat *stat = [athlete findFootballPassingStat:game.id];
        
        if (_receiverTextField.text.length > 0) {
            FootballReceivingStat *recstat = [receiver findFootballReceivingStat:game.id];
            if (addstats) {
                stat.firstdowns = [NSNumber numberWithInt:[stat.firstdowns intValue] + 1];
                recstat.firstdowns = [NSNumber numberWithInt:[recstat.firstdowns intValue] + 1];
            } else if ([stat.firstdowns intValue] > 0) {
                stat.firstdowns = [NSNumber numberWithInt:[stat.firstdowns intValue] - 1];
                recstat.firstdowns = [NSNumber numberWithInt:[recstat.firstdowns intValue] - 1];
            }
            
            _statData6.text = [stat.firstdowns stringValue];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Completion to receiver must be added before adding a first down! If you are adjusting stat errors, use the totals page." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else if ([position isEqualToString:@"Rush"]) {
        FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
        
        if (addstats) {
            stat.twopointconv = [NSNumber numberWithInt:[stat.twopointconv intValue] + 1];
            [self scoreStats:NO];
        } else if ([stat.td intValue] > 0) {
            stat.twopointconv = [NSNumber numberWithInt:[stat.twopointconv intValue] - 1];
            [self scoreStats:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"  message:@"If you already saved a score you should delete the game log to adjust stats. Stats will be automatically updated!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else if ([position isEqualToString:@"Def"]) {
        FootballDefenseStats *stat = [athlete findFootballDefenseStat:game.id];
        
        if (addstats) {
            stat.sackassist = [NSNumber numberWithInt:[stat.sackassist intValue] + 1];
            game.lastplay = [NSString stringWithFormat:@"%@ - sack assist", athlete.logname];
        } else if ([stat.sackassist intValue] > 0) {
            stat.sackassist = [NSNumber numberWithInt:[stat.sackassist intValue] - 1];
            game.lastplay = @"";
        }
        
        _statData4.text = [stat.sackassist stringValue];
    } else if ([position isEqualToString:@"PK"]) {
        FootballPlaceKickerStats *stat = [athlete findFootballPlaceKickerStat:game.id];
        
        if (addstats)
            stat.xpattempts = [NSNumber numberWithInt:[stat.xpattempts intValue] + 1];
        else if ([stat.xpattempts intValue] > 0)
            stat.xpattempts = [NSNumber numberWithInt:[stat.xpattempts intValue] - 1];
        
        _statData7.text = [stat.xpattempts stringValue];
    }
}

- (IBAction)buttonFiveClicked:(id)sender {
    if ([position isEqualToString:@"Pass"]) {
        FootballPassingStat *stat = [athlete findFootballPassingStat:game.id];
        
        if (addstats)
            stat.interceptions = [NSNumber numberWithInt:[stat.interceptions intValue] + 1];
        else if ([stat.interceptions intValue] > 0)
            stat.interceptions = [NSNumber numberWithInt:[stat.interceptions intValue] - 1];
        
        _statData7.text = [stat.interceptions stringValue];
    } else if ([position isEqualToString:@"Rush"]) {
        FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
        stat.fumbles = [NSNumber numberWithInt:[stat.fumbles intValue] + 1];
        _statData7.text = [stat.fumbles stringValue];
    } else if ([position isEqualToString:@"Def"]) {
        FootballDefenseStats *stat = [athlete findFootballDefenseStat:game.id];
        
        if (addstats) {
            stat.interceptions = [NSNumber numberWithInt:[stat.interceptions intValue] + 1];
            interception = YES;
            [self yardStats:NO];
        } else if ([stat.interceptions intValue] > 0) {
            stat.interceptions = [NSNumber numberWithInt:[stat.interceptions intValue] - 1];
            interception = NO;
            [self yardStats:YES];
        }
        
        _statData5.text = [stat.interceptions stringValue];
    } else if ([position isEqualToString:@"PK"]) {
        FootballPlaceKickerStats *stat = [athlete findFootballPlaceKickerStat:game.id];
        
        if (addstats) {
            stat.xpattempts = [NSNumber numberWithInt:[stat.xpattempts intValue] + 1];
            stat.xpmade = [NSNumber numberWithInt:[stat.xpmade intValue] + 1];
            xpmade = YES;
            [self scoreStats:NO];
        } else if ([stat.xpmade intValue] > 0) {
            stat.xpattempts = [NSNumber numberWithInt:[stat.xpattempts intValue] - 1];
            stat.xpmade = [NSNumber numberWithInt:[stat.xpmade intValue] - 1];
            xpmade = NO;
            [self scoreStats:YES];
        }
        
        _statData7.text = [stat.xpattempts stringValue];
        _statData8.text = [stat.xpmade stringValue];
    }
}

- (IBAction)buttonSixClicked:(id)sender {
    if ([position isEqualToString:@"Pass"]) {
        FootballPassingStat *stat = [athlete findFootballPassingStat:game.id];
        
        if (addstats) {
            if (receiver) {
                stat.td = [NSNumber numberWithInt:[stat.td intValue] + 1];
                touchdown = YES;
                [self scoreStats:NO];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Receiver must be selected to post a score!"
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
            }
        } else if ([stat.td intValue] > 0) {
            stat.td = [NSNumber numberWithInt:[stat.td intValue] - 1];
            touchdown = NO;
            [self scoreStats:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"  message:@"If you already saved a score you should delete the game log to adjust stats. Stats will be automatically updated!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
        
        _statData5.text = [stat.td stringValue];
    } else if ([position isEqualToString:@"Rush"]) {
        FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
        stat.fumbles_lost = [NSNumber numberWithInt:[stat.fumbles_lost intValue] + 1];
        _statData8.text = [stat.fumbles_lost stringValue];
    } else if ([position isEqualToString:@"Def"]) {
        FootballDefenseStats *stat = [athlete findFootballDefenseStat:game.id];
        
        if (addstats) {
            stat.pass_defended = [NSNumber numberWithInt:[stat.pass_defended intValue] + 1];
            game.lastplay = [NSString stringWithFormat:@"%@ - Pass Defended", athlete.logname];
        } else if ([stat.pass_defended intValue] > 0) {
            stat.pass_defended = [NSNumber numberWithInt:[stat.pass_defended intValue] - 1];
            game.lastplay = @"";
        }
        
        _statData6.text = [stat.pass_defended stringValue];
    } else if ([position isEqualToString:@"PK"]) {
        FootballPlaceKickerStats *stat = [athlete findFootballPlaceKickerStat:game.id];
        
        if (addstats) {
            stat.xpblocked = [NSNumber numberWithInt:[stat.xpblocked intValue] + 1];
            stat.xpattempts = [NSNumber numberWithInt:[stat.xpattempts intValue] + 1];
        } else if ([stat.xpblocked intValue] > 0) {
            stat.xpblocked = [NSNumber numberWithInt:[stat.xpblocked intValue] - 1];
            stat.xpattempts = [NSNumber numberWithInt:[stat.xpattempts intValue] - 1];
        }
        
        _statData9.text = [stat.xpblocked stringValue];
    }
}

- (IBAction)buttonSevenClicked:(id)sender {
    if ([position isEqualToString:@"Pass"]) {
        FootballPassingStat *stat = [athlete findFootballPassingStat:game.id];
        
        if (addstats) {
            if (receiver) {
                stat.twopointconv = [NSNumber numberWithInt:[stat.twopointconv intValue] + 1];
                twopoint = YES;
                [self scoreStats:NO];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Receiver must be selected to post a score!"
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
            }
        } else if ([stat.twopointconv intValue] > 0) {
            stat.twopointconv = [NSNumber numberWithInt:[stat.twopointconv intValue] - 1];
            twopoint = NO;
            [self scoreStats:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"  message:@"If you already saved a score you should delete the game log to adjust stats. Stats will be automatically updated!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
        
        _statData10.text = [stat.td stringValue];
    } else if ([position isEqualToString:@"Def"]) {
        FootballDefenseStats *stat = [athlete findFootballDefenseStat:game.id];
        
        if (addstats) {
            stat.fumbles_recovered = [NSNumber numberWithInt:[stat.fumbles_recovered intValue] + 1];
            game.lastplay = [NSString stringWithFormat:@"%@ - Fumble Recovered", athlete.logname];
            [self yardStats:NO];
        } else if ([stat.fumbles_recovered intValue] > 0) {
            stat.fumbles_recovered = [NSNumber numberWithInt:[stat.fumbles_recovered intValue] - 1];
            [self yardStats:YES];
            game.lastplay = @"";
        }
        
        _statData8.text = [stat.fumbles_recovered stringValue];
    }
}

- (IBAction)buttonEightClicked:(id)sender {
    if ([position isEqualToString:@"Def"]) {
        FootballDefenseStats *stat = [athlete findFootballDefenseStat:game.id];
        
        if (addstats) {
            if ((interception) || (fumblerecovered)) {
                stat.td = [NSNumber numberWithInt:[stat.td intValue] + 1];
                touchdown = YES;
                [self scoreStats:NO];
            }  else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"If you already saved a score you should delete the game log to adjust stats. Stats will be automatically updated! If not, continue." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
            }
        } else if ([stat.td intValue] > 0) {
            stat.td = [NSNumber numberWithInt:[stat.td intValue] - 1];
            touchdown = NO;
            [self scoreStats:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"  message:@"If you already saved a score you should delete the game log to adjust stats. Stats will be automatically updated! If not, continue." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
        
        _statData9.text = [stat.td stringValue];
    }
}

- (IBAction)buttonNineClicked:(id)sender {
    if ([position isEqualToString:@"Def"]) {
        FootballDefenseStats *stat = [athlete findFootballDefenseStat:game.id];
        
        if (addstats) {
            stat.safety = [NSNumber numberWithInt:[stat.safety intValue] + 1];
            [self scoreStats:NO];
        } else if ([stat.safety intValue] > 0) {
            stat.safety = [NSNumber numberWithInt:[stat.safety intValue] - 1];
            [self scoreStats:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"  message:@"If you already saved a score you should delete the game log to adjust stats. Stats will be automatically updated!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
        
        _statData10.text = [stat.td stringValue];
    }
}

- (void)yardStats:(BOOL)hidden {
    if (hidden) {
        _yardsPluMinusSegmentedControl.hidden = YES;
        _yardsPluMinusSegmentedControl.enabled = NO;
        _yardsTextField.hidden = YES;
        _yardsTextField.enabled = NO;
    } else {
        _yardsPluMinusSegmentedControl.hidden = NO;
        _yardsPluMinusSegmentedControl.enabled = YES;
        _yardsTextField.hidden = NO;
        _yardsTextField.enabled = YES;
    }
}

- (void)scoreStats:(BOOL)hidden {
    if (hidden) {
        _quarterLabel.hidden = YES;
        _quarterStatTextField.hidden = YES;
        _quarterStatTextField.enabled = NO;
        _timeofscoreLabel.hidden = YES;
        _colonLabel.hidden = YES;
        _minutesStatTextField.hidden = YES;
        _minutesStatTextField.enabled = NO;
        _secondsStatTextField.hidden = YES;
        _secondsStatTextField.enabled = NO;
    } else {
        _quarterLabel.hidden = NO;
        _quarterStatTextField.hidden = NO;
        _quarterStatTextField.enabled = YES;
        _timeofscoreLabel.hidden = NO;
        _colonLabel.hidden = NO;
        _minutesStatTextField.hidden = NO;
        _minutesStatTextField.enabled = YES;
        _secondsStatTextField.hidden = NO;
        _secondsStatTextField.enabled = YES;
    }
}

- (void)fumbleStats:(BOOL)hidden {
    if (hidden) {
        _fumbleLostLabel.hidden = YES;
        _fumbleLostSwitch.enabled = NO;
        _fumbleLostSwitch.hidden = YES;
        _fumbleLabel.hidden = YES;
        _fumbleSwitch.enabled = NO;
        _fumbleSwitch.hidden = YES;
    } else {
        _fumbleLostLabel.hidden = NO;
        _fumbleLostSwitch.enabled = YES;
        _fumbleLostSwitch.hidden = NO;
        _fumbleLabel.hidden = NO;
        _fumbleSwitch.enabled = YES;
        _fumbleSwitch.hidden = NO;
        
        if ([position isEqualToString:@"Pass"]) {
            _fumbleLabel.text = @"Fumble";
            _fumbleLostLabel.text = @"Fumble Lost";
        } else if ([position isEqualToString:@"Rush"])
            _fumbleLabel.text = @"Fumble";
    }
    
    [_fumbleSwitch setOn:NO];
    [_fumbleLostSwitch setOn:NO];
}

- (void)displayStats {
    interception = touchdown = twopoint = safety = fieldgoal = xpmade = puntreturn = koreturn = fumblerecovered = NO;
    
    _savePlayerStatsButton.hidden = NO;
    _savePlayerStatsButton.enabled = YES;
    _toggleButton.hidden = NO;
    _toggleButton.enabled = YES;
    
    if ([currentSettings getRosterThumbImage:athlete] == nil) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:athlete.thumb]];
            
            //this will set the image when loading is finished
            dispatch_async(dispatch_get_main_queue(), ^{
                _playerImageView.image = [UIImage imageWithData:image];
            });
        });
    } else
        _playerImageView.image = [currentSettings getRosterThumbImage:athlete];
    
    _receiverTextField.hidden = YES;
    _receiverTextField.enabled = NO;
    _yardsTextField.hidden = YES;
    
    [self fumbleStats:YES];
    [self scoreStats:YES];
    [self yardStats:YES];
    
    if ([position isEqualToString:@"Pass"]) {
        FootballPassingStat *stat = [athlete findFootballPassingStat:game.id];
        
        _statLabel1.text = @"CMP";
        _statData1.text = [stat.completions stringValue];
        _statLabel2.text = @"ATT";
        _statData2.text = [stat.attempts stringValue];
        _statLabel3.text = @"PCT";
        _statData3.text = [NSString stringWithFormat:@"%.02f", [stat.comp_percentage floatValue]];
        _statLabel4.text = @"YDS";
        _statData4.text = [stat.yards stringValue];
        _statLabel5.text = @"TD";
        _statData5.text = [stat.td stringValue];
        _statLabel6.text = @"FD";
        _statData6.text = [stat.firstdowns stringValue];
        _statLabel7.text = @"INT";
        _statData7.text = [stat.interceptions stringValue];
        _statLabel8.text = @"SCK";
        _statData8.text = [stat.sacks stringValue];
        _statLabel9.text = @"YDL";
        _statData9.text = [stat.yards_lost stringValue];
        _statLabel10.text = @"2PT";
        _statData10.text = [stat.twopointconv stringValue];
        
        [_buttonOne setTitle:@"Attempt" forState:UIControlStateNormal];
        _buttonOne.enabled = YES;
        _buttonOne.hidden = NO;
        [_buttonTwo setTitle:@"Completion" forState:UIControlStateNormal];
        _buttonTwo.enabled = YES;
        _buttonTwo.hidden = NO;
        [_buttonThree setTitle:@"Sack" forState:UIControlStateNormal];
        _buttonThree.enabled = YES;
        _buttonThree.hidden = NO;
        [_buttonFour setTitle:@"First Down" forState:UIControlStateNormal];
        _buttonFour.enabled = YES;
        _buttonFour.hidden = NO;
        [_buttonFive setTitle:@"Interception" forState:UIControlStateNormal];
        _buttonFive.enabled = YES;
        _buttonFive.hidden = NO;
        [_buttonSix setTitle:@"TD" forState:UIControlStateNormal];
        _buttonSix.enabled = YES;
        _buttonSix.hidden = NO;
        [_buttonSeven setTitle:@"2PT Conv" forState:UIControlStateNormal];
        _buttonSeven.enabled = YES;
        _buttonSeven.hidden = NO;
        _buttonEight.enabled = NO;
        _buttonEight.hidden = YES;
        _buttonNine.enabled = NO;
        _buttonNine.hidden = YES;
    } else if ([position isEqualToString:@"Rush"]) {
        FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
        
        _statLabel1.text = @"ATT";
        _statData1.text = [stat.attempts stringValue];
        _statLabel2.text = @"YDS";
        _statData2.text = [stat.yards stringValue];
        _statLabel3.text = @"AVG";
        _statData3.text = [NSString stringWithFormat:@"%.02f", [stat.average floatValue]];
        _statLabel4.text = @"TD";
        _statData4.text = [stat.td stringValue];
        _statLabel5.text = @"LNG";
        _statData5.text = [stat.longest stringValue];
        _statLabel6.text = @"FD";
        _statData6.text = [stat.firstdowns stringValue];
        _statLabel7.text = @"FMB";
        _statData7.text = [stat.fumbles stringValue];
        _statLabel8.text = @"LST";
        _statData8.text = [stat.fumbles_lost stringValue];
        _statLabel9.text = @"2PT";
        _statData9.text = [stat.twopointconv stringValue];
        _statLabel10.text = @"";
        _statData10.text = @"";
        
        [_buttonOne setTitle:@"Attempt" forState:UIControlStateNormal];
        _buttonOne.enabled = YES;
        _buttonOne.hidden = NO;
        [_buttonTwo setTitle:@"First Down" forState:UIControlStateNormal];
        _buttonTwo.enabled = YES;
        _buttonTwo.hidden = NO;
        [_buttonThree setTitle:@"TD" forState:UIControlStateNormal];
        _buttonThree.enabled = YES;
        _buttonThree.hidden = NO;
        [_buttonFour setTitle:@"2PT Conv" forState:UIControlStateNormal];
        _buttonFour.enabled = YES;
        _buttonFour.hidden = NO;
        [_buttonFive setTitle:@"Fumble" forState:UIControlStateNormal];
        _buttonFive.enabled = YES;
        _buttonFive.hidden = NO;
        [_buttonSix setTitle:@"Fumble Lost" forState:UIControlStateNormal];
        _buttonSix.enabled = NO;
        _buttonSix.hidden = YES;
        _buttonSeven.enabled = NO;
        _buttonSeven.hidden = YES;
        _buttonEight.enabled = NO;
        _buttonEight.hidden = YES;
        _buttonNine.enabled = NO;
        _buttonNine.hidden = YES;
    } else if ([position isEqualToString:@"Def"]) {
        FootballDefenseStats *stat = [athlete findFootballDefenseStat:game.id];
        
        _statLabel1.text = @"TKL";
        _statData1.text = [stat.tackles stringValue];
        _statLabel2.text = @"AST";
        _statData2.text = [stat.assists stringValue];
        _statLabel3.text = @"SAK";
        _statData3.text = [stat.sacks stringValue];
        _statLabel4.text = @"AST";
        _statData4.text = [stat.sackassist stringValue];
        _statLabel5.text = @"INT";
        _statData5.text = [stat.interceptions stringValue];
        _statLabel6.text = @"PD";
        _statData6.text = [stat.pass_defended stringValue];
        _statLabel7.text = @"RYD";
        _statData7.text = [stat.int_yards stringValue];
        _statLabel8.text = @"FRC";
        _statData8.text = [stat.fumbles_recovered stringValue];
        _statLabel9.text = @"TD";
        _statData9.text = [stat.td stringValue];
        _statLabel10.text = @"SFY";
        _statData10.text = [stat.safety stringValue];
        
        [_buttonOne setTitle:@"Tackle" forState:UIControlStateNormal];
        _buttonOne.enabled = YES;
        _buttonOne.hidden = NO;
        [_buttonTwo setTitle:@"Assist" forState:UIControlStateNormal];
        _buttonTwo.enabled = YES;
        _buttonTwo.hidden = NO;
        [_buttonThree setTitle:@"Sack" forState:UIControlStateNormal];
        _buttonThree.enabled = YES;
        _buttonThree.hidden = NO;
        [_buttonFour setTitle:@"Sack Assist" forState:UIControlStateNormal];
        _buttonFour.enabled = YES;
        _buttonFour.hidden = NO;
        [_buttonFive setTitle:@"Interception" forState:UIControlStateNormal];
        _buttonFive.enabled = YES;
        _buttonFive.hidden = NO;
        [_buttonSix setTitle:@"Pass Def" forState:UIControlStateNormal];
        _buttonSix.enabled = YES;
        _buttonSix.hidden = NO;
        [_buttonSeven setTitle:@"Fumble Rec" forState:UIControlStateNormal];
        _buttonSeven.enabled = YES;
        _buttonSeven.hidden = NO;
        [_buttonEight setTitle:@"TD" forState:UIControlStateNormal];
        _buttonEight.enabled = YES;
        _buttonEight.hidden = NO;
        [_buttonNine setTitle:@"Safety" forState:UIControlStateNormal];
        _buttonNine.enabled = YES;
        _buttonNine.hidden = NO;
    } else if ([position isEqualToString:@"PK"]) {
        FootballPlaceKickerStats *stat = [athlete findFootballPlaceKickerStat:game.id];
        
        _statLabel1.text = @"FGA";
        _statData1.text = [stat.fgattempts stringValue];
        _statLabel2.text = @"FGM";
        _statData2.text = [stat.fgmade stringValue];
        _statLabel3.text = @"BLK";
        _statData3.text = [stat.fgblocked stringValue];
        _statLabel4.text = @"LNG";
        _statData4.text = [stat.fglong stringValue];
        _statLabel5.text = @"";
        _statData5.text = @"";
        _statLabel6.text = @"";
        _statData6.text = @"";
        _statLabel7.text = @"XPA";
        _statData7.text = [stat.xpattempts stringValue];
        _statLabel8.text = @"XPM";
        _statData8.text = [stat.xpmade stringValue];
        _statLabel9.text = @"BLK";
        _statData9.text = [stat.xpblocked stringValue];
        _statLabel10.text = @"";
        _statData10.text = @"";
        
        [_buttonOne setTitle:@"FGA" forState:UIControlStateNormal];
        _buttonOne.enabled = YES;
        _buttonOne.hidden = NO;
        [_buttonTwo setTitle:@"FGM" forState:UIControlStateNormal];
        _buttonTwo.enabled = YES;
        _buttonTwo.hidden = NO;
        [_buttonThree setTitle:@"Blocked" forState:UIControlStateNormal];
        _buttonThree.enabled = YES;
        _buttonThree.hidden = NO;
        [_buttonFour setTitle:@"XPA" forState:UIControlStateNormal];
        _buttonFour.enabled = YES;
        _buttonFour.hidden = NO;
        [_buttonFive setTitle:@"XPM" forState:UIControlStateNormal];
        _buttonFive.enabled = YES;
        _buttonFive.hidden = NO;
        [_buttonSix setTitle:@"Blocked" forState:UIControlStateNormal];
        _buttonSix.enabled = YES;
        _buttonSix.hidden = NO;
        _buttonSeven.enabled = NO;
        _buttonSeven.hidden = YES;
        _buttonEight.enabled = NO;
        _buttonEight.hidden = YES;
        _buttonNine.enabled = NO;
        _buttonNine.hidden = YES;
    } else if ([position isEqualToString:@"Kick"]) {
        FootballKickerStats *stat = [athlete findFootballKickerStat:game.id];
        
        _statLabel1.text = @"";
        _statData1.text = @"";
        _statLabel2.text = @"KO";
        _statData2.text = [stat.koattempts stringValue];
        _statLabel3.text = @"RET";
        _statData3.text = [stat.koreturned stringValue];
        _statLabel4.text = @"TCH";
        _statData4.text = [stat.kotouchbacks stringValue];
        _statLabel5.text = @"";
        _statData5.text = @"";
        _statLabel6.text = @"";
        _statData6.text = @"";
        _statLabel7.text = @"";
        _statData7.text = @"";
        _statLabel8.text = @"";
        _statData8.text = @"";
        _statLabel9.text = @"";
        _statData9.text = @"";
        _statLabel10.text = @"";
        _statData10.text = @"";
        
        [_buttonOne setTitle:@"Kickoff" forState:UIControlStateNormal];
        _buttonOne.enabled = YES;
        _buttonOne.hidden = NO;
        [_buttonTwo setTitle:@"Touchback" forState:UIControlStateNormal];
        _buttonTwo.enabled = YES;
        _buttonTwo.hidden = NO;
        _buttonThree.enabled = NO;
        _buttonThree.hidden = YES;
        _buttonFour.enabled = NO;
        _buttonFour.hidden = YES;
        _buttonFive.enabled = NO;
        _buttonFive.hidden = YES;
        _buttonSix.enabled = NO;
        _buttonSix.hidden = YES;
        _buttonSeven.enabled = NO;
        _buttonSeven.hidden = YES;
        _buttonEight.enabled = NO;
        _buttonEight.hidden = YES;
        _buttonNine.enabled = NO;
        _buttonNine.hidden = YES;
        
    } else if ([position isEqualToString:@"Ret"]) {
        FootballReturnerStats *stat = [athlete findFootballReturnerStat:game.id];
        
        _statLabel1.text = @"RET";
        _statData1.text = [stat.koreturn stringValue];
        _statLabel2.text = @"YDS";
        _statData2.text = [stat.koyards stringValue];
        _statLabel3.text = @"TD";
        _statData3.text = [stat.kotd stringValue];
        _statLabel4.text = @"LNG";
        _statData4.text = [stat.kolong stringValue];
        _statLabel5.text = @"";
        _statData5.text = @"";
        _statLabel6.text = @"PNT";
        _statData6.text = [stat.punt_return stringValue];
        _statLabel7.text = @"YDS";
        _statData7.text = [stat.punt_returnyards stringValue];
        _statLabel8.text = @"TD";
        _statData8.text = [stat.punt_returntd stringValue];
        _statLabel9.text = @"LNG";
        _statData9.text = [stat.punt_returnlong stringValue];
        _statLabel10.text = @"";
        _statData10.text = @"";
        
        [_buttonOne setTitle:@"Kick Return" forState:UIControlStateNormal];
        _buttonOne.enabled = YES;
        _buttonOne.hidden = NO;
        [_buttonTwo setTitle:@"Punt Return" forState:UIControlStateNormal];
        _buttonTwo.enabled = YES;
        _buttonTwo.hidden = NO;
        [_buttonThree setTitle:@"TD" forState:UIControlStateNormal];
        _buttonThree.enabled = YES;
        _buttonThree.hidden = NO;
        _buttonFour.enabled = NO;
        _buttonFour.hidden = YES;
        _buttonFive.enabled = NO;
        _buttonFive.hidden = YES;
        _buttonSix.enabled = NO;
        _buttonSix.hidden = YES;
        _buttonSeven.enabled = NO;
        _buttonSeven.hidden = YES;
        _buttonEight.enabled = NO;
        _buttonEight.hidden = YES;
        _buttonNine.enabled = NO;
        _buttonNine.hidden = YES;
    } else if ([position isEqualToString:@"Punt"]) {
        FootballPunterStats *stat = [athlete findFootballPunterStat:game.id];
        
        _statLabel1.text = @"PNT";
        _statData1.text = [stat.punts stringValue];
        _statLabel2.text = @"YDS";
        _statData2.text = [stat.punts_yards stringValue];
        _statLabel3.text = @"LNG";
        _statData3.text = [stat.punts_long stringValue];
        _statLabel4.text = @"BLK";
        _statData4.text = [stat.punts_blocked stringValue];
        _statLabel5.text = @"";
        _statData5.text = @"";
        _statLabel6.text = @"";
        _statData6.text = @"";
        _statLabel7.text = @"";
        _statData7.text = @"";
        _statLabel8.text = @"";
        _statData8.text = @"";
        _statLabel9.text = @"";
        _statData9.text = @"";
        _statLabel10.text = @"";
        _statData10.text = @"";
        
        [_buttonOne setTitle:@"Punt" forState:UIControlStateNormal];
        _buttonOne.enabled = YES;
        _buttonOne.hidden = NO;
        [_buttonTwo setTitle:@"Blocked" forState:UIControlStateNormal];
        _buttonTwo.enabled = YES;
        _buttonTwo.hidden = NO;
        _buttonThree.enabled = NO;
        _buttonThree.hidden = YES;
        _buttonFour.enabled = NO;
        _buttonFour.hidden = YES;
        _buttonFive.enabled = NO;
        _buttonFive.hidden = YES;
        _buttonSix.enabled = NO;
        _buttonSix.hidden = YES;
        _buttonSeven.enabled = NO;
        _buttonSeven.hidden = YES;
        _buttonEight.enabled = NO;
        _buttonEight.hidden = YES;
        _buttonNine.enabled = NO;
        _buttonNine.hidden = YES;
    }
}

- (IBAction)savePlayerStatsButtonClicked:(id)sender {
    if ([position isEqualToString:@"Pass"]) {
        FootballPassingStat *passstat = [athlete findFootballPassingStat:game.id];
        FootballReceivingStat *recstat;
        
        if (receiver) {
            recstat = [receiver findFootballReceivingStat:game.id];
            recstat.receptions = [NSNumber numberWithInt:[recstat.receptions intValue] + 1];
            
            if ([_buttonThree isSelected]) {
                if (_yardsPluMinusSegmentedControl.selectedSegmentIndex == 1) {
                    passstat.yards_lost = [NSNumber numberWithInt:[passstat.yards_lost intValue] + [_yardsTextField.text intValue]];
                }
                game.lastplay = [NSString stringWithFormat:@"%@ sacked for %d loss", athlete.logname, [_yardsTextField.text intValue]];
            } else {
                if (_yardsPluMinusSegmentedControl.selectedSegmentIndex == 0) {
                    recstat.yards = [NSNumber numberWithInt:[_yardsTextField.text intValue] + [recstat.yards intValue]];
                    passstat.yards = [NSNumber numberWithInt:[_yardsTextField.text intValue] + [passstat.yards intValue]];
                } else if (_yardsPluMinusSegmentedControl.selectedSegmentIndex == 1) {
                    recstat.yards = [NSNumber numberWithInt:[_yardsTextField.text intValue] - [recstat.yards intValue]];
                    passstat.yards = [NSNumber numberWithInt:[_yardsTextField.text intValue] - [passstat.yards intValue]];
                }
                game.lastplay = [NSString stringWithFormat:@"%@ pass to %@ for %@", athlete.logname, receiver.logname, _yardsTextField.text];
            }
        
            _statData4.text = [passstat.yards stringValue];
            
            if (touchdown) {
                recstat.td = [NSNumber numberWithInt:[recstat.td intValue] + 1];
            } else if (twopoint)
                recstat.twopointconv = [NSNumber numberWithInt:[recstat.twopointconv intValue] + 1];
            
            [recstat saveStats];
        } else if (_yardsPluMinusSegmentedControl.selectedSegmentIndex == 1) {
            passstat.yards_lost = [NSNumber numberWithInt:[passstat.yards_lost intValue] + [_yardsTextField.text intValue]];
            game.lastplay = [NSString stringWithFormat:@"%@ sacked for %d loss", athlete.logname, [_yardsTextField.text intValue]];
        }
        
        [passstat saveStats];
        
        if ((touchdown) || (twopoint)) {
            Gamelogs *gamelog = [self populateGameLogEntries];
            gamelog.football_passing_id = passstat.football_passing_id;
            gamelog.assistplayer = receiver.athleteid;
            gamelog.logentry = @"yard pass to";
            [game updateGamelog:gamelog];
        }
        
        [game saveGameschedule];
        receiver = nil;
    } else if ([position isEqualToString:@"Rush"]) {
        FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
        
        if (_yardsPluMinusSegmentedControl.selectedSegmentIndex == 0)
            stat.yards = [NSNumber numberWithInt:[stat.yards intValue] + [_yardsTextField.text intValue]];
        else
            stat.yards = [NSNumber numberWithInt:[stat.yards intValue] - [_yardsTextField.text intValue]];
        
        _statData2.text = [stat.yards stringValue];
        
        game.lastplay = [NSString stringWithFormat:@"%@ %@ yard run", athlete.logname, _yardsTextField.text];
        
        if ([_yardsTextField.text intValue] > [stat.longest intValue])
            stat.longest = [NSNumber numberWithInt:[_yardsTextField.text intValue]];
        
        [stat saveStats];
        
        if ((touchdown) || (twopoint)) {
            Gamelogs *gamelog = [self populateGameLogEntries];
            gamelog.logentry = @"yard run";
            gamelog.football_rushing_id = stat.football_rushing_id;
            [game updateGamelog:gamelog];
        }
        
        [game saveGameschedule];
    } else if ([position isEqualToString:@"Def"]) {
        FootballDefenseStats *stat = [athlete findFootballDefenseStat:game.id];
        
        if (_yardsTextField.text.length > 0) {
            if (_yardsPluMinusSegmentedControl.selectedSegmentIndex == 0)
                stat.int_yards = [NSNumber numberWithInt:[stat.int_yards intValue] + [_yardsTextField.text intValue]];
            else
                stat.int_yards = [NSNumber numberWithInt:[stat.int_yards intValue] - [_yardsTextField.text intValue]];
            
            game.lastplay = [NSString stringWithFormat:@"%@ interception return for %@", athlete.logname, _yardsTextField.text];
        }
        
        _statData7.text = [stat.int_yards stringValue];
        
        [stat saveStats];
        
        if ((touchdown) || (twopoint)) {
            Gamelogs *gamelog = [self populateGameLogEntries];
            gamelog.football_defense_id = stat.football_defense_id;
            
            if (touchdown) {
                if (interception)
                    gamelog.logentry = @"yard interception return";
                else
                    gamelog.logentry = @"yard fumble return";
                
                gamelog.score = @"TD";
            } else {
                gamelog.logentry = @"safety";
                gamelog.score = @"2P";
            }
            
            [game updateGamelog:gamelog];
        }
        
        [game saveGameschedule];
    } else if ([position isEqualToString:@"PK"]) {
        FootballPlaceKickerStats *stat = [athlete findFootballPlaceKickerStat:game.id];
        
        if ((fieldgoal) && ([stat.fglong intValue] > [_yardsTextField.text intValue])) {
            stat.fglong = [NSNumber numberWithInt:[_yardsTextField.text intValue]];
        }
        
        [stat saveStats];
        
        if ((fieldgoal) || (xpmade)) {
            Gamelogs *gamelog = [self populateGameLogEntries];
            gamelog.football_place_kicker_id = stat.football_place_kicker_id;
            
            if (fieldgoal) {
                gamelog.yards = [NSNumber numberWithInt:[_yardsTextField.text intValue]];
            }
            
            gamelog.logentry = athlete.logname;
            [game updateGamelog:gamelog];
            [game saveGameschedule];
        }
    } else if ([position isEqualToString:@"Ret"]) {
        FootballReturnerStats *stat = [athlete findFootballReturnerStat:game.id];
        
        if (_yardsTextField.text.length > 0) {
            if (koreturn) {
                
                if (_yardsPluMinusSegmentedControl.selectedSegmentIndex == 0)
                    stat.koyards = [NSNumber numberWithInt:[stat.koyards intValue] + [_yardsTextField.text intValue]];
                else
                    stat.koyards = [NSNumber numberWithInt:[stat.koyards intValue] - [_yardsTextField.text intValue]];
                
                if ([_yardsTextField.text intValue] > [stat.kolong intValue])
                    stat.kolong = [NSNumber numberWithInt:[_yardsTextField.text intValue]];
                
                _statData2.text = [stat.koyards stringValue];
                _statData4.text = [stat.kolong stringValue];
            } else {
                
                if (_yardsPluMinusSegmentedControl.selectedSegmentIndex == 0)
                    stat.punt_returnyards = [NSNumber numberWithInt:[stat.punt_returnyards intValue] + [_yardsTextField.text intValue]];
                else
                    stat.punt_returnyards = [NSNumber numberWithInt:[stat.punt_returnyards intValue] - [_yardsTextField.text intValue]];
                
                if ([_yardsTextField.text intValue] > [stat.punt_returnlong intValue])
                    stat.punt_returnlong = [NSNumber numberWithInt:[_yardsTextField.text intValue]];
                
                _statData7.text = [stat.punt_returnyards stringValue];
                _statData9.text = [stat.punt_returnlong stringValue];
            }
        }
        
        [stat saveStats];
        
        if (touchdown) {
            Gamelogs *gamelog = [self populateGameLogEntries];
            gamelog.football_returner_id = stat.football_returner_id;
            gamelog.logentry = athlete.logname;
            [game updateGamelog:gamelog];
            [game saveGameschedule];
        }
    } else if ([position isEqualToString:@"Kick"]) {
        FootballKickerStats *stat = [athlete findFootballKickerStat:game.id];
        
        [stat saveStats];
    } else {
        FootballPunterStats *stat = [athlete findFootballPunterStat:game.id];
        
        if (_yardsPluMinusSegmentedControl.selectedSegmentIndex == 0)
            stat.punts_yards = [NSNumber numberWithInt:[stat.punts_yards intValue] + [_yardsTextField.text intValue]];
        else
            stat.punts_yards = [NSNumber numberWithInt:[stat.punts_yards intValue] - [_yardsTextField.text intValue]];
        
        if ([stat.punts_long intValue] < [_yardsTextField.text intValue])
            stat.punts_long = [NSNumber numberWithInt:[_yardsTextField.text intValue]];
        
        _statData2.text = [stat.punts_yards stringValue];
        _statData4.text = [stat.punts_long stringValue];
        
        [stat saveStats];
    }
    
    [self viewWillAppear:YES];
    touchdown = twopoint = fieldgoal = xpmade = puntreturn = koreturn = NO;
}

- (Gamelogs *)populateGameLogEntries {
    Gamelogs *gamelog = [[Gamelogs alloc] init];
    
    gamelog.gameschedule_id = game.id;
    
    switch ([_quarterStatTextField.text intValue]) {
        case 1:
            gamelog.period = @"Q1";
            if (touchdown )
                game.homeq1 = [NSNumber numberWithInt:[game.homeq1 intValue] + 6];
            else if (twopoint)
                game.homeq1 = [NSNumber numberWithInt:[game.homeq1 intValue] + 2];
            else if (fieldgoal)
                game.homeq1 = [NSNumber numberWithInt:[game.homeq1 intValue] + 3];
            else if (xpmade)
                game.homeq1 = [NSNumber numberWithInt:[game.homeq1 intValue] + 1];
            break;
            
        case 2:
            gamelog.period = @"Q2";
            if (touchdown )
                game.homeq2 = [NSNumber numberWithInt:[game.homeq2 intValue] + 6];
            else if (twopoint)
                game.homeq2 = [NSNumber numberWithInt:[game.homeq2 intValue] + 2];
            else if (fieldgoal)
                game.homeq2 = [NSNumber numberWithInt:[game.homeq2 intValue] + 3];
            else if (xpmade)
                game.homeq2 = [NSNumber numberWithInt:[game.homeq2 intValue] + 1];
            break;
            
        case 3:
            gamelog.period = @"Q3";
            if (touchdown )
                game.homeq3 = [NSNumber numberWithInt:[game.homeq3 intValue] + 6];
            else if (twopoint)
                game.homeq3 = [NSNumber numberWithInt:[game.homeq3 intValue] + 2];
            else if (fieldgoal)
                game.homeq3 = [NSNumber numberWithInt:[game.homeq3 intValue] + 3];
            else if (xpmade)
                game.homeq3 = [NSNumber numberWithInt:[game.homeq3 intValue] + 1];
            break;
            
        default:
            gamelog.period = @"Q4";
            if (touchdown )
                game.homeq4 = [NSNumber numberWithInt:[game.homeq4 intValue] + 6];
            else if (twopoint)
                game.homeq4 = [NSNumber numberWithInt:[game.homeq4 intValue] + 2];
            else if (fieldgoal)
                game.homeq4 = [NSNumber numberWithInt:[game.homeq4 intValue] + 3];
            else if (xpmade)
                game.homeq4 = [NSNumber numberWithInt:[game.homeq4 intValue] + 1];
            break;
    }
    
    if ([_minutesStatTextField.text intValue] < 10) {
        int minute = [_minutesStatTextField.text intValue];
        _secondsStatTextField.text = [NSString stringWithFormat:@"0%d", minute];
    }
    
    if ([_secondsStatTextField.text intValue] < 10) {
        int minute = [_secondsStatTextField.text intValue];
        _minutesStatTextField.text = [NSString stringWithFormat:@"0%d", minute];
    }
    
    gamelog.time = [NSString stringWithFormat:@"%@%@%@", _minutesStatTextField.text, @":", _secondsStatTextField.text];
    gamelog.player = athlete.athleteid;
    gamelog.yards = [NSNumber numberWithInt:[_yardsTextField.text intValue]];
    
    if (touchdown)
        gamelog.score = @"TD";
    else if (twopoint)
        gamelog.score = @"2P";
    else if (xpmade)
        gamelog.score = @"XP";
    else if (fieldgoal)
        gamelog.score = @"FG";
    
    return gamelog;
}

- (IBAction)toggleButtonClicked:(id)sender {
    if (addstats) {
        [_toggleButton setTitle:@"Add" forState:UIControlStateNormal];
        addstats = NO;
    } else {
        [_toggleButton setTitle:@"Subtract" forState:UIControlStateNormal];
        addstats = YES;
    }
}

- (IBAction)totalsButtonClicked:(id)sender {
    if ([position isEqualToString:@"Pass"])
        [self performSegueWithIdentifier:@"PassingStatSegue" sender:self];
    else if ([position isEqualToString:@"Rush"])
        [self performSegueWithIdentifier:@"RushingStatSegue" sender:self];
    else if ([position isEqualToString:@"Def"])
        [self performSegueWithIdentifier:@"DefenseStatSegue" sender:self];
    else if ([position isEqualToString:@"PK"])
        [self performSegueWithIdentifier:@"PlaceKickerStatSegue" sender:self];
    else if ([position isEqualToString:@"Kick"])
        [self performSegueWithIdentifier:@"KickerStatSegue" sender:self];
    else if ([position isEqualToString:@"Ret"])
        [self performSegueWithIdentifier:@"ReturnerStatSegue" sender:self];
    else if ([position isEqualToString:@"Punt"])
        [self performSegueWithIdentifier:@"PunterStatSegue" sender:self];
}

- (IBAction)fumbleSwitchToggle:(id)sender {
    if ([_fumbleSwitch isOn]) {
        if ([position isEqualToString:@"Pass"]) {
            FootballReceivingStat *stat = [athlete findFootballReceivingStat:game.id];
            stat.fumbles = [NSNumber numberWithInt:[stat.fumbles intValue] + 1];
        } else if ([position isEqualToString:@"Rush"]) {
            FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
            stat.fumbles = [NSNumber numberWithInt:[stat.fumbles intValue] + 1];
            _statData7.text = [stat.fumbles stringValue];
        }
    } else if (![_fumbleSwitch isOn]) {
        if ([position isEqualToString:@"Pass"]) {
            FootballReceivingStat *stat = [athlete findFootballReceivingStat:game.id];
            if ([stat.fumbles intValue] > 0)
                stat.fumbles = [NSNumber numberWithInt:[stat.fumbles intValue] - 1];
        } else if ([position isEqualToString:@"Rush"]) {
            FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
            
            if ([stat.fumbles intValue] > 0)
                stat.fumbles = [NSNumber numberWithInt:[stat.fumbles intValue] - 1];
            
            _statData7.text = [stat.fumbles stringValue];
        }
    }
}

- (IBAction)fumblelostSwitchToggle:(id)sender {
    if ([_fumbleLostSwitch isOn]) {
        if ([position isEqualToString:@"Pass"]) {
            FootballReceivingStat *stat = [athlete findFootballReceivingStat:game.id];
            stat.fumbles_lost = [NSNumber numberWithInt:[stat.fumbles_lost intValue] + 1];
        } else if ([position isEqualToString:@"Rush"]) {
            FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
            stat.fumbles_lost = [NSNumber numberWithInt:[stat.fumbles_lost intValue] + 1];
            _statData7.text = [stat.fumbles_lost stringValue];
        }
    } else if (![_fumbleLostSwitch isOn]) {
        if ([position isEqualToString:@"Pass"]) {
            FootballReceivingStat *stat = [athlete findFootballReceivingStat:game.id];
            if ([stat.fumbles_lost intValue] > 0)
                stat.fumbles_lost = [NSNumber numberWithInt:[stat.fumbles_lost intValue] - 1];
        } else if ([position isEqualToString:@"Rush"]) {
            FootballRushingStat *stat = [athlete findFootballRushingStat:game.id];
            
            if ([stat.fumbles_lost intValue] > 0)
                stat.fumbles_lost = [NSNumber numberWithInt:[stat.fumbles_lost intValue] - 1];
            
            _statData7.text = [stat.fumbles_lost stringValue];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ((textField == _minutesStatTextField) || (textField == _secondsStatTextField) || (textField == _quarterStatTextField) ||
        (textField == _yardsTextField)) {
        NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        if (myStringMatchesRegEx)
            
            if ((textField == _minutesStatTextField) || (textField == _secondsStatTextField)) {
                return (newLength > 2) ? NO : YES;
            } else if (textField == _quarterStatTextField) {
                return (newLength > 1) ? NO : YES;
            } else if (textField == _yardsTextField) {
                return (newLength > 3 ? NO : YES);
            } else
                return NO;
            else
                return  NO;
    } else
        return YES;
}

@end
