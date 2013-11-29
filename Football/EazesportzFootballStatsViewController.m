//
//  EazesportzFootballStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 11/21/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzFootballStatsViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzFootballStatsTableViewCell.h"
#import "EazesportzPassingStatsViewController.h"
#import "EazesportzRushingStatsViewController.h"
#import "EazesportzGameLogViewController.h"
#import "PlayerSelectionViewController.h"

@interface EazesportzFootballStatsViewController ()

@end

@implementation EazesportzFootballStatsViewController {
    BOOL offense, defense, specialteams;
    
    NSMutableArray *qbs, *rbs, *wrs;
    BOOL qb, rb, wr;
    Athlete *otherplayer;
    
    PlayerSelectionViewController *playerController;
    EazesportzGameLogViewController *gamelogController;
}

@synthesize athlete;
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
    offense = YES;
    defense = NO;
    specialteams = NO;
    
    _togoTextField.keyboardType = UIKeyboardTypeNumberPad;
    _downTextField.keyboardType = UIKeyboardTypeNumberPad;
    _ballonTextField.keyboardType = UIKeyboardTypeNumberPad;
    _minutesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _secondsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorTimeOutsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorScoreTextField.keyboardType = UIKeyboardTypeNumberPad;
    _quarterTextField.keyboardType = UIKeyboardTypeNumberPad;
    _homeTimeOutsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorTimeOutsTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _playerSelectContainer.hidden = YES;
    _gamelogContainer.hidden = YES;
    
    qbs = [currentSettings.footballQB copy];
    rbs = [currentSettings.footballRB copy];
    wrs = [currentSettings.footballWR copy];
    
    qb = NO, rb = NO, wr = NO;
    
    for (int cnt = 0; cnt < currentSettings.roster.count; cnt++) {
        Athlete *player = [currentSettings.roster objectAtIndex:cnt];
        
        if (![qbs containsObject:player]) {
            if ([player isQB:game.id])
                [qbs addObject:player];
        }
        
        if (![rbs containsObject:player]) {
            if ([player isRB:game.id])
                [rbs addObject:player];
        }
        
        if (![wrs containsObject:player]) {
            if ([player isWR:game.id])
                [wrs addObject:player];
        }
    }

    if (game) {
         _statLabel.text = [NSString stringWithFormat:@"%@%@", @"Stats vs. ", game.opponent_name];
       
        _gameClockLabel.text = game.currentgametime;
        NSArray *timearray = [game.currentgametime componentsSeparatedByString:@":"];
        _minutesTextField.text = timearray[0];
        _secondsTextField.text = timearray[1];
        _homeImageView.image = [currentSettings.team getImage:@"tiny"];
        _visitorImageView.image = [game opponentImage];
        _homeLabel.text = currentSettings.team.mascot;
        _visitorLabel.text = game.opponent;
        _visitorScoreLabel.text = [game.opponentscore stringValue];
        _visitorScoreTextField.text = [game.opponentscore stringValue];
        
        _homeScoreLabel.text = [NSString stringWithFormat:@"%d", [currentSettings teamTotalPoints:game.id]];
        
        _homeTimeOutsTextField.text = [game.hometimeouts stringValue];
        _visitorTimeOutsTextField.text = [game.opoonenttimeouts stringValue];
        _ballonTextField.text = [game.ballon stringValue];
        _downTextField.text = [game.down stringValue];
        _togoTextField.text = [game.togo stringValue];
        _quarterTextField.text = [game.period stringValue];
        
        [_statsTableView reloadData];
    } else if (athlete)
        _statLabel.text = [NSString stringWithFormat:@"%@%@", @"Stats for ", athlete.logname];
    else
        _statLabel.text = @"Select game to enter stats";

}

- (IBAction)offenseButtonClicked:(id)sender {
    offense = YES;
    defense = NO;
    specialteams = NO;
    [_statsTableView reloadData];
}

- (IBAction)defenseButtonClicked:(id)sender {
    offense = NO;
    defense = YES;
    specialteams = NO;
    [_statsTableView reloadData];
}

- (IBAction)specialteamsButtonClicked:(id)sender {
    offense = NO;
    defense = NO;
    specialteams = YES;
    [_statsTableView reloadData];
}

- (IBAction)savestatsButtonClicked:(id)sender {
    game.period = [NSNumber numberWithInt:[_quarterTextField.text intValue]];
    
    if (offense) {
        for (int i = 0; i < qbs.count; i++) {
            if (![[qbs objectAtIndex:i] saveStats]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:[[qbs objectAtIndex:i] httpError]
                                                    delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
                return;
            }
        }
        
        for (int i = 0; i < rbs.count; i++) {
            if (![[rbs objectAtIndex:i] saveStats]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:[[rbs objectAtIndex:i] httpError]
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
                return;
            }
        }

        for (int i = 0; i < wrs.count; i++) {
            if (![[wrs objectAtIndex:i] saveStats]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:[[wrs objectAtIndex:i] httpError]
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
                return;
            }
        }
    } else if (defense) {
        
    } else {
        
    }
    
    [self viewWillAppear:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (offense)
        return 3;
    else if (specialteams) {
        return 4;
    } else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (offense) {
        if (section == 0) {
            return qbs.count + 1;
        } else if (section == 1)
            return rbs.count + 1;
        else
            return wrs.count + 1;
//        else
//            return currentSettings.footballOL.count;
    } else if (specialteams) {
        if (section == 0)
            return currentSettings.footballPK.count;
        else if (section == 1)
            return currentSettings.footballK.count;
        else if (section == 2)
             return currentSettings.footballPUNT.count;
       else
            return currentSettings.footballRET.count;
    } else {
        return currentSettings.footballDEF.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FootballStatTableCell";
    EazesportzFootballStatsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[EazesportzFootballStatsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Athlete *player;
    
    if (offense) {
        if (indexPath.section == 0) {
            if (indexPath.row < currentSettings.footballQB.count) {
                player = [qbs objectAtIndex:indexPath.row];
                FootballPassingStat *stat = [player findFootballPassingStat:game.id];
                cell.fbimageView.image = [player getImage:@"tiny"];
                cell.namelabel.text = player.numberLogname;
                cell.label1.text = [stat.attempts stringValue];
                cell.label2.text = [stat.completions stringValue];
                cell.label3.text = [NSString stringWithFormat:@"%.02f", [stat.comp_percentage floatValue]];
                cell.label4.text = [stat.yards stringValue];
                cell.label5.text = [stat.td stringValue];
                cell.label6.text = [stat.interceptions stringValue];
                cell.label7.text = [stat.sacks stringValue];
                cell.label8.text = [stat.firstdowns stringValue];
                cell.label9.text = [stat.yards_lost stringValue];
                cell.label10.text = [stat.twopointconv stringValue];
                cell.label11.text = @"";
            } else {
                cell.fbimageView.image = [currentSettings.team getImage:@"tiny"];
                cell.namelabel.text = @"Other Player";
                cell.label1.text = @"0";
                cell.label2.text = @"0";
                cell.label3.text = @"0.0";
                cell.label4.text = @"0";
                cell.label5.text = @"0";
                cell.label6.text = @"0";
                cell.label7.text = @"0";
                cell.label8.text = @"0";
                cell.label9.text = @"0";
                cell.label10.text = @"0";
                cell.label11.text = @"";
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row < rbs.count) {
                player = [currentSettings.footballRB objectAtIndex:indexPath.row];
                FootballRushingStat *stat = [player findFootballRushingStat:game.id];
                cell.fbimageView.image = [player getImage:@"tiny"];
                cell.namelabel.text = player.numberLogname;
                cell.label1.text = [stat.attempts stringValue];
                cell.label2.text = [stat.yards stringValue];
                cell.label3.text = [NSString stringWithFormat:@"%.02f", [stat.average floatValue]];
                cell.label4.text = [stat.td stringValue];
                cell.label5.text = [stat.firstdowns stringValue];
                cell.label6.text = [stat.longest stringValue];
                cell.label7.text = [stat.fumbles stringValue];
                cell.label9.text = [stat.fumbles_lost stringValue];
                cell.label10.text = [stat.twopointconv stringValue];
                cell.label8.text = @"";
                cell.label11.text = @"";
            } else {
                cell.fbimageView.image = [currentSettings.team getImage:@"tiny"];
                cell.namelabel.text = @"Other Player";
                cell.label1.text = @"0";
                cell.label2.text = @"0";
                cell.label3.text = @"0.0";
                cell.label4.text = @"0";
                cell.label5.text = @"0";
                cell.label6.text = @"0";
                cell.label7.text = @"0";
                cell.label8.text = @"";
                cell.label9.text = @"0";
                cell.label10.text = @"0";
                cell.label11.text = @"";
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row < wrs.count) {
                player = [currentSettings.footballWR objectAtIndex:indexPath.row];
                FootballReceivingStat *stat = [player findFootballReceivingStat:game.id];
                cell.fbimageView.image = [player getImage:@"tiny"];
                cell.namelabel.text = player.numberLogname;
                cell.label1.text = [stat.receptions stringValue];
                cell.label2.text = [stat.yards stringValue];
                cell.label3.text = [NSString stringWithFormat:@"%.02f", [stat.average floatValue]];
                cell.label4.text = [stat.longest stringValue];
                cell.label5.text = [stat.fumbles stringValue];
                cell.label7.text = [stat.fumbles_lost stringValue];
                cell.label8.text = [stat.twopointconv stringValue];
                cell.label6.text = @"";
                cell.label9.text = @"";
                cell.label10.text = @"";
                cell.label11.text = @"";
            } else {
                cell.fbimageView.image = [currentSettings.team getImage:@"tiny"];
                cell.namelabel.text = @"Other Player";
                cell.label1.text = @"0";
                cell.label2.text = @"0";
                cell.label3.text = @"0.0";
                cell.label4.text = @"0";
                cell.label5.text = @"0";
                cell.label6.text = @"";
                cell.label7.text = @"0";
                cell.label8.text = @"0";
                cell.label9.text = @"";
                cell.label10.text = @"";
                cell.label11.text = @"";
            }
         }
    } else if (specialteams) {
        if (indexPath.section == 0) {
            player = [currentSettings.footballPK objectAtIndex:indexPath.row];
            FootballPlaceKickerStats *stat = [player findFootballPlaceKickerStat:game.id];
            cell.fbimageView.image = [player getImage:@"tiny"];
            cell.namelabel.text = player.numberLogname;
            cell.label1.text = [stat.fgattempts stringValue];
            cell.label2.text = [stat.fgmade stringValue];
            cell.label3.text = [stat.fgblocked stringValue];
            cell.label4.text = [stat.fglong stringValue];
            cell.label5.text = [stat.xpattempts stringValue];
            cell.label6.text = [stat.xpmade stringValue];
            cell.label7.text = [stat.xpblocked stringValue];
            cell.label8.text = @"";
            cell.label9.text = @"";
            cell.label10.text = @"";
            cell.label11.text = @"";
        } else if (indexPath.section == 1) {
            player = [currentSettings.footballK objectAtIndex:indexPath.row];
            FootballKickerStats *stat = [player findFootballKickerStat:game.id];
            cell.fbimageView.image = [player getImage:@"tiny"];
            cell.namelabel.text = player.numberLogname;
            cell.label1.text = [stat.koattempts stringValue];
            cell.label2.text = @"";
            cell.label3.text = [stat.koreturned stringValue];
            cell.label4.text =  @"";
            cell.label5.text = [stat.kotouchbacks stringValue];
            cell.label6.text =  @"";
            cell.label7.text =  @"";
            cell.label8.text = @"";
            cell.label9.text = @"";
            cell.label10.text = @"";
            cell.label11.text = @"";
        } else if (indexPath.section == 2) {
            player = [currentSettings.footballPUNT objectAtIndex:indexPath.row];
            FootballPunterStats *stat = [player findFootballPunterStat:game.id];
            cell.fbimageView.image = [player getImage:@"tiny"];
            cell.namelabel.text = player.numberLogname;
            cell.label1.text = [stat.punts stringValue];
            cell.label2.text = [stat.punts_yards stringValue];
            cell.label3.text = [stat.punts_long stringValue];
            cell.label4.text =  [stat.punts_blocked stringValue];
            
            if ([stat.punts intValue] > 0)
                cell.label5.text = [[NSNumber numberWithFloat:([stat.punts_yards floatValue]/[stat.punts floatValue])] stringValue];
            else
                cell.label5.text = @"0.0";
            
            cell.label6.text =  @"";
            cell.label7.text =  @"";
            cell.label8.text = @"";
            cell.label9.text = @"";
            cell.label10.text = @"";
            cell.label11.text = @"";
        } else {
            player = [currentSettings.footballRET objectAtIndex:indexPath.row];
            FootballReturnerStats *stat = [player findFootballReturnerStat:game.id];
            cell.fbimageView.image = [player getImage:@"tiny"];
            cell.namelabel.text = player.numberLogname;
            cell.label1.text = [stat.punt_return stringValue];
            cell.label2.text = [stat.punt_returnyards stringValue];
            cell.label3.text = [stat.punt_returntd stringValue];
            cell.label4.text =  [stat.punt_returnlong stringValue];
            
            if ([stat.punt_return intValue] > 0)
                cell.label5.text = [[NSNumber numberWithFloat:([stat.punt_returnyards floatValue]/[stat.punt_return floatValue])] stringValue];
            else
                cell.label5.text = @"0.0";
            
            cell.label6.text =  [stat.koreturn stringValue];
            cell.label7.text =  [stat.koyards stringValue];
            cell.label8.text = [stat.kotd stringValue];
            cell.label9.text = [stat.kolong stringValue];
            
            if ([stat.koreturn intValue] > 0)
                cell.label10.text = [[NSNumber numberWithFloat:([stat.koyards floatValue]/[stat.punt_return floatValue])] stringValue];
            else
                cell.label10.text = @"0.0";
            
            cell.label11.text = @"";
        }
        
    } else {
        player = [currentSettings.footballDEF objectAtIndex:indexPath.row];
        FootballDefenseStats *stat = [player findFootballDefenseStat:game.id];
        cell.fbimageView.image = [player getImage:@"tiny"];
        cell.namelabel.text = player.numberLogname;
        cell.label1.text = [stat.tackles stringValue];
        cell.label2.text = [stat.assists stringValue];
        cell.label3.text = [stat.sacks stringValue];
        cell.label4.text = [stat.interceptions stringValue];
        cell.label5.text = [stat.pass_defended stringValue];
        cell.label6.text = [stat.int_yards stringValue];
        cell.label7.text = [stat.int_long stringValue];
        cell.label8.text = [stat.td stringValue];
        cell.label9.text = [stat.fumbles_recovered stringValue];
        cell.label10.text = [stat.safety stringValue];
        cell.label11.text = @"";
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (offense) {
        
        if (section == 0)
            return @"                QB                      ATT    CMP       PCT     YDS      TD       INT     SACK     FD   LSTYDS  2PT ";
        else if (section == 1)
            return @"                Rusher                  ATT    YDS       AVG     TD       FD      LNG    FUMB        LSTFUMB  2PT";
        else
            return @"                WR                      REC    YDS       AVG    LNG    FUMB        LSTFUMB  2PT";

    } else if (specialteams) {
        if (section == 0)
            return @"                Place Kicker        FGA    FGM   FGBLK  FGLNG XPA   XPM  XPBLK";
        else if (section == 1)
            return @"                Kicker                Kickoffs      Touchbacks      Returned";
        else if (section== 2)
            return @"                Punter                Punts    Blkd    Yards   Long    AVG";
        else
            return @"                Returner              Punts  Yards    TD     Long    AVG  Kickoffs  Yards     TD     Long    AVG";
        
    } else
        return @"                Defender              TK      ASST   SACK    INT    PDEF  RYDS  RLNG    TD     FUMREC   SFTY";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (game) {
        if (offense) {
            if (indexPath.section == 0) {
                if (indexPath.row < qbs.count)
                    [self performSegueWithIdentifier:@"PassingStatSegue" sender:self];
                else {
                    _playerSelectContainer.hidden = NO;
                    qb = YES;
                }
            } else if (indexPath.section == 1) {
                if (indexPath.row < rbs.count)
                    [self performSegueWithIdentifier:@"RushingStatSegue" sender:self];
                else {
                    _playerSelectContainer.hidden = NO;
                    rb = YES;
                }
            }
        } else if (defense) {
            [self performSegueWithIdentifier:@"DefenseStatSegue" sender:self];
        } else {
            
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"  message:@"Select game to update stats for player!" delegate:nil
                                              cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (athlete) {
//            totalStatsController.player = athlete;
//            totalStatsController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
        } else {
//            totalStatsController.game = game;
//            totalStatsController.player = [currentSettings.roster objectAtIndex:indexPath.row];
        }
        
//        [totalStatsController viewWillAppear:YES];
//        _basketballTotalStatsContainer.hidden = NO;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Enter Totals";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PassingStatSegue"]) {
        EazesportzPassingStatsViewController *destController = segue.destinationViewController;
        if (!otherplayer) {
            NSIndexPath *indexPath = [_statsTableView indexPathForSelectedRow];
            destController.player = [qbs objectAtIndex:indexPath.row];
        } else {
            destController.player = otherplayer;
            otherplayer = nil;
        }
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"RushingStatSegue"]) {
        EazesportzRushingStatsViewController *destController = segue.destinationViewController;
        if (!otherplayer) {
            NSIndexPath *indexPath = [_statsTableView indexPathForSelectedRow];
            destController.player = [rbs objectAtIndex:indexPath.row];
        } else {
            destController.player = otherplayer;
            otherplayer = nil;
        }
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"DefenseStatSegue"]) {
    } else if ([segue.identifier isEqualToString:@"PlayerSelectSegue"]) {
        playerController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"GameLogSegue"]) {
        gamelogController = segue.destinationViewController;
    }
}

- (IBAction)otherPlayerFootballStat:(UIStoryboardSegue *)segue {
    if (playerController.player) {
        otherplayer = playerController.player;
        if (offense) {
            if (qb) {
                [self performSegueWithIdentifier:@"PassingStatSegue" sender:self];
            } else if (rb)
                [self performSegueWithIdentifier:@"RushingStatSegue" sender:self];
        } else if (defense) {
            
        } else {
            
        }
    }
}

- (IBAction)scoreLogButtonClicked:(id)sender {
    if (_gamelogContainer.hidden) {
        _gamelogContainer.hidden = NO;
        gamelogController.game = game;
        [gamelogController viewWillAppear:YES];
    } else
        _gamelogContainer.hidden = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ((textField == _minutesTextField) || (textField == _secondsTextField) || (textField == _visitorScoreTextField) ||
        (textField == _homeTimeOutsTextField) || (textField == _visitorTimeOutsTextField) || (textField == _quarterTextField) ||
        (textField == _downTextField) || (textField == _togoTextField) || (textField == _ballonTextField)) {
        NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        if (myStringMatchesRegEx)
            
            if ((textField == _minutesTextField) || (textField == _secondsTextField) || (textField == _ballonTextField)) {
                return (newLength > 2) ? NO : YES;
            } else if ((textField == _quarterTextField) || (textField == _downTextField) || (textField == _visitorTimeOutsTextField) ||
                       (textField == _homeTimeOutsTextField)) {
                return (newLength > 1) ? NO : YES;
            } else if (textField == _visitorScoreTextField) {
                return (newLength > 3 ? NO : YES);
            } else
                return NO;
        else
            return  NO;
    } else
        return YES;
}

- (IBAction)cancelGamelogTable:(UIStoryboardSegue *)segue {
    _gamelogContainer.hidden = YES;
}

@end
