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
#import "EazesportzDefenseStatsViewController.h"
#import "EazesportzPlaceKickerViewController.h"
#import "EazesportzKickoffStatsViewController.h"
#import "EazesportzPunterStatsViewController.h"
#import "EazesportzReturnerStatsViewController.h"
#import "EazesportzFootballReceivingTotalsViewController.h"


@interface EazesportzFootballStatsViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzFootballStatsViewController {
    BOOL offense, defense, specialteams;
    
    NSMutableArray *qbs, *rbs, *wrs, *defenselist, *pks, *kickerlist, *returnerlist, *punterlist;
    BOOL qb, rb, wr, pk, punter, kicker, returner;
    NSString *quarter;
    
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
    
    qbs = [[NSMutableArray alloc] initWithArray:currentSettings.footballQB];
    rbs = [[NSMutableArray alloc] initWithArray:currentSettings.footballRB];
    wrs = [[NSMutableArray alloc] initWithArray:currentSettings.footballWR];
    defenselist = [[NSMutableArray alloc] initWithArray:currentSettings.footballDEF];
    pks = [[NSMutableArray alloc] initWithArray:currentSettings.footballPK];
    punterlist = [[NSMutableArray alloc] initWithArray:currentSettings.footballPUNT];
    kickerlist = [[NSMutableArray alloc] initWithArray:currentSettings.footballK];
    returnerlist = [[NSMutableArray alloc] initWithArray:currentSettings.footballRET];
    
    qb = NO, rb = NO, wr = NO, pk = NO, kicker= NO, punter = NO, returner = NO;
    
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
        
        if (![defenselist containsObject:player]) {
            if ([player isDEF:game.id])
                [defenselist addObject:player];
        }
        
        if (![pks containsObject:player]) {
            if ([player isPK:game.id])
                [pks addObject:player];
        }
        
        if (![punterlist containsObject:player]) {
            if ([player isPunter:game.id])
                [punterlist addObject:player];
        }
        
        if (![returnerlist containsObject:player]) {
            if ([player isReturner:game.id])
                [returnerlist addObject:player];
        }
        
        if (![kickerlist containsObject:player]) {
            if ([player isKicker:game.id])
                [kickerlist addObject:player];
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
        _visitorTimeOutsTextField.text = [game.opponenttimeouts stringValue];
        _ballonTextField.text = [game.ballon stringValue];
        _downTextField.text = [game.down stringValue];
        _togoTextField.text = [game.togo stringValue];
        _quarterTextField.text = [game.period stringValue];
        
        if (!game.gameisfinal) {
            _finalLabel.hidden = YES;
        }
        
         _finalButton.enabled = YES;
        _finalButton.hidden = NO;
       
        [_statsTableView reloadData];
    } else if (athlete)
        _statLabel.text = [NSString stringWithFormat:@"%@%@", @"Stats for ", athlete.logname];
    else {
        _statLabel.text = @"Select game to enter stats";
        _finalLabel.hidden = YES;
        _finalButton.enabled = NO;
        _finalButton.hidden = YES;
    }

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
            FootballPassingStat *passstat = [[qbs objectAtIndex:i] findFootballPassingStat:game.id];
            if (![passstat saveStats]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:[passstat httperror]
                                                    delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
                return;
            }
        }
        
        for (int i = 0; i < rbs.count; i++) {
            FootballRushingStat *rushstat = [[rbs objectAtIndex:i] findFootballRushingStat:game.id];
            if (![rushstat saveStats]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:[rushstat httperror]
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
                return;
            }
        }

        for (int i = 0; i < wrs.count; i++) {
            FootballReceivingStat *recstat = [[wrs objectAtIndex:i] findFootballReceivingStat:game.id];
            if (![recstat saveStats]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:[recstat httperror]
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
                return;
            }
        }
    } else if (defense) {
        for (int i = 0; i < defenselist.count; i++) {
            FootballDefenseStats *defstat = [[defenselist objectAtIndex:i] findFootballDefenseStat:game.id];
            if (![defstat saveStats]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:[defstat httperror]
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
                return;
            }
        }
    } else {
        for (int i = 0; i < pks.count; i++) {
            FootballPlaceKickerStats *pkstat = [[pks objectAtIndex:i] findFootballPlaceKickerStat:game.id];
            if (![pkstat saveStats]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:[pkstat httperror]
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
                return;
            }
        }

        for (int i = 0; i < punterlist.count; i++) {
            FootballPunterStats *puntstat = [[punterlist objectAtIndex:i] findFootballPunterStat:game.id];
            if (![puntstat saveStats]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:[puntstat httperror]
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
                return;
            }
        }

        for (int i = 0; i < kickerlist.count; i++) {
            FootballKickerStats *kickstat = [[kickerlist objectAtIndex:i] findFootballKickerStat:game.id];
            if (![kickstat saveStats]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:[kickstat httperror]
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
                return;
            }
        }
        
        for (int i = 0; i < returnerlist.count; i++) {
            FootballReturnerStats *retstat = [[returnerlist objectAtIndex:i] findFootballReturnerStat:game.id];
            if (![retstat saveStats]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:[retstat httperror]
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
                return;
            }
        }
    }
    
    game.togo = [NSNumber numberWithInt:[_togoTextField.text intValue]];
    game.down = [NSNumber numberWithInt:[_downTextField.text intValue]];
    game.ballon = [NSNumber numberWithInt:[_ballonTextField.text intValue]];
    game.period = [NSNumber numberWithInt:[_quarterTextField.text intValue]];
    game.hometimeouts = [NSNumber numberWithInt:[_homeTimeOutsTextField.text intValue]];
    game.opponenttimeouts = [NSNumber numberWithInt:[_visitorTimeOutsTextField.text intValue]];
    game.opponentscore = [NSNumber numberWithInt:[_visitorScoreTextField.text intValue]];
    game.currentgametime = [NSString stringWithFormat:@"%@%@%@", _minutesTextField.text, @":", _secondsTextField.text];
    [game saveGameschedule];
    
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
            return qbs.count + 2;
        } else if (section == 1)
            return rbs.count + 2;
        else
            return wrs.count + 2;
//        else
//            return currentSettings.footballOL.count;
    } else if (specialteams) {
        if (section == 0)
            return pks.count + 2;
        else if (section == 1)
            return kickerlist.count + 2;
        else if (section == 2)
             return punterlist.count + 2;
       else
            return returnerlist.count + 2;
    } else {
        return defenselist.count + 2;
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
            if (indexPath.row < qbs.count) {
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
            } else if (indexPath.row == (qbs.count + 1)) {
                cell = [self addPlayerCell:cell];
            } else {
                cell.fbimageView.image = [currentSettings.team getImage:@"tiny"];
                cell.namelabel.text = @"Totals";
                
                int attempts = 0, completions = 0, td = 0, yards = 0, interceptions = 0, sacks = 0, firstdowns = 0, lostyards = 0, twopoint = 0;
                
                for (int cnt = 0; cnt < qbs.count; cnt++) {
                    FootballPassingStat *astat = [[qbs objectAtIndex:cnt] findFootballPassingStat:game.id];
                    attempts += [astat.attempts intValue];
                    completions += [astat.completions intValue];
                    td += [astat.td intValue];
                    yards += [astat.yards intValue];
                    interceptions += [astat.interceptions intValue];
                    sacks += [astat.sacks intValue];
                    firstdowns += [astat.firstdowns intValue];
                    lostyards += [astat.yards_lost intValue];
                    twopoint += [astat.twopointconv intValue];
                }
                
                float comp_percent;
                
                if (attempts > 0)
                    comp_percent = (float)completions/(float)attempts;
                else
                    comp_percent = 0.0;
                
                cell.label1.text = [NSString stringWithFormat:@"%d", attempts];
                cell.label2.text = [NSString stringWithFormat:@"%d", completions];
                cell.label3.text = [NSString stringWithFormat:@"%.02f", comp_percent];
                cell.label4.text = [NSString stringWithFormat:@"%d", yards];
                cell.label5.text = [NSString stringWithFormat:@"%d", td];
                cell.label6.text = [NSString stringWithFormat:@"%d", interceptions];
                cell.label7.text = [NSString stringWithFormat:@"%d", sacks];
                cell.label8.text = [NSString stringWithFormat:@"%d", firstdowns];
                cell.label9.text = [NSString stringWithFormat:@"%d", lostyards];
                cell.label10.text = [NSString stringWithFormat:@"%d", twopoint];
                cell.label11.text = @"";
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row < rbs.count) {
                player = [rbs objectAtIndex:indexPath.row];
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
                cell.label8.text = @"";
                cell.label9.text = [stat.fumbles_lost stringValue];
                cell.label10.text = [stat.twopointconv stringValue];
                cell.label11.text = @"";
            } else if (indexPath.row == (rbs.count + 1)) {
                cell = [self addPlayerCell:cell];
            } else {
                cell.fbimageView.image = [currentSettings.team getImage:@"tiny"];
                cell.namelabel.text = @"Totals";
                
                int attempts = 0, td = 0, yards = 0, firstdowns = 0, longest = 0, fumbles = 0, lostfumbles = 0, twopoint = 0;
                
                for (int cnt = 0; cnt < rbs.count; cnt++) {
                    FootballRushingStat *astat = [[rbs objectAtIndex:cnt] findFootballRushingStat:game.id];
                    attempts += [astat.attempts intValue];
                    td += [astat.td intValue];
                    yards += [astat.yards intValue];
                    
                    if (longest < [astat.longest intValue])
                        longest = [astat.longest intValue];
                    
                    fumbles += [astat.fumbles intValue];
                    firstdowns += [astat.firstdowns intValue];
                    lostfumbles += [astat.fumbles_lost intValue];
                    twopoint += [astat.twopointconv intValue];
                }
                
                float average;
                
                if (attempts > 0)
                    average = (float)yards/(float)attempts;
                else
                    average = 0.0;
                
                cell.label1.text = [NSString stringWithFormat:@"%d", attempts];
                cell.label2.text = [NSString stringWithFormat:@"%d", yards];
                cell.label3.text = [NSString stringWithFormat:@"%.02f", average];
                cell.label4.text = [NSString stringWithFormat:@"%d", td];
                cell.label5.text = [NSString stringWithFormat:@"%d", firstdowns];
                cell.label6.text = [NSString stringWithFormat:@"%d", longest];
                cell.label7.text = [NSString stringWithFormat:@"%d", fumbles];
                cell.label8.text = @"";
                cell.label9.text = [NSString stringWithFormat:@"%d", lostfumbles];
                cell.label10.text = [NSString stringWithFormat:@"%d", twopoint];
                cell.label11.text = @"";
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row < wrs.count) {
                player = [wrs objectAtIndex:indexPath.row];
                FootballReceivingStat *stat = [player findFootballReceivingStat:game.id];
                cell.fbimageView.image = [player getImage:@"tiny"];
                cell.namelabel.text = player.numberLogname;
                cell.label1.text = [stat.receptions stringValue];
                cell.label2.text = [stat.yards stringValue];
                cell.label3.text = [NSString stringWithFormat:@"%.02f", [stat.average floatValue]];
                cell.label4.text = [stat.td stringValue];
                cell.label5.text = [stat.firstdowns stringValue];
                cell.label6.text = [stat.longest stringValue];
                cell.label7.text = [stat.fumbles stringValue];
                cell.label8.text = @"";
                cell.label9.text = [stat.fumbles_lost stringValue];
                cell.label10.text = [stat.twopointconv stringValue];
                cell.label11.text = @"";
            } else if (indexPath.row == (wrs.count + 1)) {
                cell = [self addPlayerCell:cell];
            } else {
                cell.fbimageView.image = [currentSettings.team getImage:@"tiny"];
                cell.namelabel.text = @"Totals";
                
                int receptions = 0, yards = 0, td = 0, longest = 0, firstdowns = 0, fumbles = 0, lostfumbles = 0, twopoint = 0;
                
                for (int cnt = 0; cnt < wrs.count; cnt++) {
                    FootballReceivingStat *astat = [[wrs objectAtIndex:cnt] findFootballReceivingStat:game.id];
                    receptions += [astat.receptions intValue];
                    td += [astat.td intValue];
                    yards += [astat.yards intValue];
                    
                    if (longest < [astat.longest intValue])
                        longest = [astat.longest intValue];
                    
                    fumbles += [astat.fumbles intValue];
                    firstdowns += [astat.firstdowns intValue];
                    lostfumbles += [astat.fumbles_lost intValue];
                    twopoint += [astat.twopointconv intValue];
                }
                
                float average;
                
                if (receptions > 0)
                    average = (float)yards/(float)receptions;
                else
                    average = 0.0;

                cell.label1.text = [NSString stringWithFormat:@"%d", receptions];
                cell.label2.text = [NSString stringWithFormat:@"%d", yards];
                cell.label3.text = [NSString stringWithFormat:@"%.02f", average];
                cell.label4.text = [NSString stringWithFormat:@"%d", td];
                cell.label5.text = [NSString stringWithFormat:@"%d", firstdowns];
                cell.label6.text = [NSString stringWithFormat:@"%d", longest];
                cell.label7.text = [NSString stringWithFormat:@"%d", fumbles];
                cell.label8.text = @"";
                cell.label9.text = [NSString stringWithFormat:@"%d", lostfumbles];
                cell.label10.text = [NSString stringWithFormat:@"%d", twopoint];
                cell.label11.text = @"";
            }
         }
    } else if (specialteams) {
        if (indexPath.section == 0) {
            if (indexPath.row < pks.count) {
                player = [pks objectAtIndex:indexPath.row];
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
            } else if (indexPath.row == pks.count) {
                cell.fbimageView.image = [currentSettings.team getImage:@"tiny"];
                cell.namelabel.text = @"Totals";
                
                int fga = 0, fgm = 0, fgblk = 0, fglong = 0, xpa = 0, xpm = 0, xpblock = 0;
                
                for (int cnt = 0; cnt < pks.count; cnt++) {
                    FootballPlaceKickerStats *astat = [[pks objectAtIndex:cnt] findFootballPlaceKickerStat:game.id];
                    fga += [astat.fgattempts intValue];
                    fgm += [astat.fgmade intValue];
                    
                    if (fglong < [astat.fglong intValue])
                        fglong = [astat.fglong intValue];
                    
                    fgblk += [astat.fgblocked intValue];
                    xpa += [astat.xpattempts intValue];
                    xpm += [astat.xpmade intValue];
                    xpblock += [astat.xpblocked intValue];
                }
                
                cell.label1.text = [NSString stringWithFormat:@"%d", fga];
                cell.label2.text = [NSString stringWithFormat:@"%d", fgm];
                cell.label3.text = [NSString stringWithFormat:@"%d", fgblk];
                cell.label4.text = [NSString stringWithFormat:@"%d", fglong];
                cell.label5.text = [NSString stringWithFormat:@"%d", xpa];
                cell.label6.text = [NSString stringWithFormat:@"%d", xpm];
                cell.label7.text = [NSString stringWithFormat:@"%d", xpblock];
                cell.label8.text = @"";
                cell.label9.text = @"";
                cell.label10.text = @"";
                cell.label11.text = @"";
            } else {
                cell = [self addPlayerCell:cell];
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row < kickerlist.count) {
                player = [kickerlist objectAtIndex:indexPath.row];
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
            } else if (indexPath.row == kickerlist.count) {
                cell.fbimageView.image = [currentSettings.team getImage:@"tiny"];
                cell.namelabel.text = @"Totals";
                
                int kickoffs = 0, touchbacks = 0, returned = 0;
                
                for (int cnt = 0; cnt < kickerlist.count; cnt++) {
                    FootballKickerStats *astat = [[kickerlist objectAtIndex:cnt] findFootballKickerStat:game.id];
                    kickoffs += [astat.koattempts intValue];
                    touchbacks += [astat.kotouchbacks intValue];
                    returned += [astat.koreturned intValue];
                }
                
                cell.label1.text = [NSString stringWithFormat:@"%d", kickoffs];
                cell.label2.text = @"";
                cell.label3.text = [NSString stringWithFormat:@"%d", returned];
                cell.label4.text =  @"";
                cell.label5.text = [NSString stringWithFormat:@"%d", touchbacks];
                cell.label6.text =  @"";
                cell.label7.text =  @"";
                cell.label8.text = @"";
                cell.label9.text = @"";
                cell.label10.text = @"";
                cell.label11.text = @"";
            } else {
                cell = [self addPlayerCell:cell];
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row < punterlist.count) {
                player = [punterlist objectAtIndex:indexPath.row];
                FootballPunterStats *stat = [player findFootballPunterStat:game.id];
                cell.fbimageView.image = [player getImage:@"tiny"];
                cell.namelabel.text = player.numberLogname;
                cell.label1.text = [stat.punts stringValue];
                cell.label2.text = [stat.punts_blocked stringValue];
                cell.label3.text = [stat.punts_yards stringValue];
                cell.label4.text =  [stat.punts_long stringValue];
                
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
            } else if (indexPath.row == punterlist.count) {
                cell.fbimageView.image = [currentSettings.team getImage:@"tiny"];
                cell.namelabel.text = @"Totals";
                
                int punts = 0, blocked = 0, yards = 0, longest = 0;
                
                for (int cnt = 0; cnt < punterlist.count; cnt++) {
                    FootballPunterStats *astat = [[punterlist objectAtIndex:cnt] findFootballPunterStat:game.id];
                    punts += [astat.punts intValue];
                    blocked += [astat.punts_blocked intValue];
                    yards += [astat.punts_yards intValue];
                    
                    if (longest < [astat.punts_long intValue])
                        longest = [astat.punts_long intValue];
                }
                
                float average;
                
                if (punts > 0)
                    average = (float)yards/(float)punts;
                else
                    average = 0.0;
                
                cell.label1.text = [NSString stringWithFormat:@"%d", punts];
                cell.label2.text = [NSString stringWithFormat:@"%d", blocked];
                cell.label3.text = [NSString stringWithFormat:@"%d", yards];
                cell.label4.text = [NSString stringWithFormat:@"%d", longest];
                cell.label5.text = [NSString stringWithFormat:@"%.02f", average];
                cell.label6.text =  @"";
                cell.label7.text =  @"";
                cell.label8.text = @"";
                cell.label9.text = @"";
                cell.label10.text = @"";
                cell.label11.text = @"";
            } else {
                cell = [self addPlayerCell:cell];
            }
        } else {
            if (indexPath.row < returnerlist.count) {
                player = [returnerlist objectAtIndex:indexPath.row];
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
                    cell.label10.text = [[NSNumber numberWithFloat:([stat.koyards floatValue]/[stat.koreturn floatValue])] stringValue];
                else
                    cell.label10.text = @"0.0";
                
                cell.label11.text = @"";
            } else if (indexPath.row == returnerlist.count) {
                cell.fbimageView.image = [currentSettings.team getImage:@"tiny"];
                cell.namelabel.text = @"Totals";
                
                int punts = 0, pyards = 0, ptd = 0, plong = 0, kickoffs = 0, kyards = 0, ktd = 0, klong = 0;
                
                for (int cnt = 0; cnt < returnerlist.count; cnt++) {
                    FootballReturnerStats *astat = [[returnerlist objectAtIndex:cnt] findFootballReturnerStat:game.id];
                    punts += [astat.punt_return intValue];
                    pyards += [astat.punt_returnyards intValue];
                    ptd += [astat.punt_returntd intValue];
                    
                    if (plong < [astat.punt_returnlong intValue])
                        plong = [astat.punt_returnlong intValue];
                    
                    kickoffs += [astat.koreturn intValue];
                    kyards += [astat.koyards intValue];
                    ktd += [astat.kotd intValue];
                    
                    if (klong < [astat.kolong intValue])
                        klong = [astat.kolong intValue];
                }
                
                float paverage, kaverage;
                
                if (punts > 0)
                    paverage = (float)pyards/(float)punts;
                else
                    paverage = 0.0;
                
                if (kickoffs > 0)
                    kaverage = (float)kyards/(float)kickoffs;
                else
                    kaverage = 0.0;
                
                cell.label1.text = [NSString stringWithFormat:@"%d", punts];
                cell.label2.text = [NSString stringWithFormat:@"%d", pyards];
                cell.label3.text = [NSString stringWithFormat:@"%d", ptd];
                cell.label4.text = [NSString stringWithFormat:@"%d", plong];
                cell.label5.text = [NSString stringWithFormat:@"%.02f", paverage];
                cell.label6.text = [NSString stringWithFormat:@"%d", kickoffs];
                cell.label7.text = [NSString stringWithFormat:@"%d", kyards];
                cell.label8.text = [NSString stringWithFormat:@"%d", ktd];
                cell.label9.text = [NSString stringWithFormat:@"%d", klong];
                cell.label10.text = [NSString stringWithFormat:@"%.02f", kaverage];
                cell.label11.text = @"";
            } else {
                cell = [self addPlayerCell:cell];
            }
        }
        
    } else {
        if (indexPath.row < defenselist.count) {
            player = [defenselist objectAtIndex:indexPath.row];
            FootballDefenseStats *stat = [player findFootballDefenseStat:game.id];
            cell.fbimageView.image = [player getImage:@"tiny"];
            cell.namelabel.text = player.numberLogname;
            
            if ([stat.assists intValue] > 0)
                cell.label1.text = [NSString stringWithFormat:@"%01f", ([stat.tackles floatValue] + ([stat.assists floatValue]/2))];
            else
                cell.label1.text = [stat.tackles stringValue];
            
//            cell.label2.text = [stat.assists stringValue];
            
            if ([stat.sackassist intValue] > 0)
                cell.label2.text = [NSString stringWithFormat:@"%.01f", ([stat.sacks floatValue] + ([stat.sackassist floatValue]/2))];
            else
                cell.label2.text = [stat.sacks stringValue];
            
            cell.label3.text = [stat.interceptions stringValue];
            cell.label4.text = [stat.pass_defended stringValue];
            cell.label5.text = [stat.int_yards stringValue];
            cell.label6.text = [stat.int_long stringValue];
            cell.label7.text = [stat.td stringValue];
            cell.label8.text = [stat.fumbles_recovered stringValue];
            cell.label9.text = [stat.safety stringValue];
            cell.label10.text = @"";
            cell.label11.text = @"";
        } else if (indexPath.row == defenselist.count) {
            cell.fbimageView.image = [currentSettings.team getImage:@"tiny"];
            cell.namelabel.text = @"Totals";
            
            int tackles = 0, assists = 0, sacks = 0, sackassists = 0, interceptions = 0, passdef = 0, retyards = 0, retlong = 0, td = 0, fumbrec = 0, safety = 0;
            
            for (int cnt = 0; cnt < defenselist.count; cnt++) {
                FootballDefenseStats *astat = [[defenselist objectAtIndex:cnt] findFootballDefenseStat:game.id];
                tackles += [astat.tackles intValue];
                td += [astat.td intValue];
                assists += [astat.assists intValue];
                sackassists += [astat.sackassist intValue];
                sacks += [astat.sacks intValue];
                interceptions += [astat.interceptions intValue];
                passdef += [astat.pass_defended intValue];
                retyards += [astat.int_yards intValue];
                
                if (retlong < [astat.int_long intValue])
                    retlong = [astat.int_long intValue];
                
                fumbrec += [astat.fumbles_recovered intValue];
                safety += [astat.safety intValue];
            }
            
            if (assists > 0)
                cell.label1.text = [NSString stringWithFormat:@"%01f", ((float)tackles + ((float)assists/2))];
            else
                cell.label1.text = [NSString stringWithFormat:@"%d", tackles];
            
            //            cell.label2.text = [stat.assists stringValue];
            
            if (sackassists > 0)
                cell.label2.text = [NSString stringWithFormat:@"%.01f", ((float)sacks + ((float)sackassists/2))];
            else
                cell.label2.text = [NSString stringWithFormat:@"%d", sacks];
            
            cell.label3.text = [NSString stringWithFormat:@"%d", interceptions];
            cell.label4.text = [NSString stringWithFormat:@"%d", passdef];
            cell.label5.text = [NSString stringWithFormat:@"%d", retyards];
            cell.label6.text = [NSString stringWithFormat:@"%d", retlong];
            cell.label7.text = [NSString stringWithFormat:@"%d", td];
            cell.label8.text = [NSString stringWithFormat:@"%d", fumbrec];
            cell.label9.text = [NSString stringWithFormat:@"%d", safety];
            cell.label10.text = @"";
            cell.label11.text = @"";
        } else {
            cell = [self addPlayerCell:cell];
        }
    }
    
    return cell;
}

- (EazesportzFootballStatsTableViewCell *)addPlayerCell:(EazesportzFootballStatsTableViewCell *)cell {
    cell.fbimageView.image = [currentSettings.team getImage:@"tiny"];
    cell.namelabel.text = @"Add Player";
    cell.label1.text = @"";
    cell.label2.text = @"";
    cell.label3.text = @"";
    cell.label4.text = @"";
    cell.label5.text = @"";
    cell.label6.text = @"";
    cell.label7.text = @"";
    cell.label8.text = @"";
    cell.label9.text = @"";
    cell.label10.text = @"";
    cell.label11.text = @"";
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (offense) {
        
        if (section == 0)
            return @"                QB                      ATT    CMP       PCT     YDS      TD       INT     SACK     FD   LSTYDS  2PT ";
        else if (section == 1)
            return @"                Rusher                  ATT    YDS       AVG     TD       FD      LNG    FUMB        LSTFUMB  2PT";
        else
            return @"                WR                      REC    YDS       AVG     TD       FD      LNG    FUMB        LSTFUMB  2PT";

    } else if (specialteams) {
        if (section == 0)
            return @"                Place Kicker        FGA    FGM   FGBLK  FGLNG XPA   XPM  XPBLK";
        else if (section == 1)
            return @"                Kicker                Kickoffs      Returned      Touchbacks";
        else if (section== 2)
            return @"                Punter                Punts    Blkd    Yards   Long    AVG";
        else
            return @"                Returner             Punts  Yards     TD      Long    AVG   Kickoffs Yards     TD      Long    AVG";
        
    } else
        return @"                Defender              TK      SACK    INT    PDEF  RYDS  RLNG    TD     FUMREC   SFTY";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    playerController.player = nil;
    
    if (game) {
        if (offense) {
            if (indexPath.section == 0) {
                if (indexPath.row < qbs.count)
                    [self performSegueWithIdentifier:@"PassingStatSegue" sender:self];
                else if (indexPath.row == (qbs.count + 1)) {
                    _playerSelectContainer.hidden = NO;
                    qb = YES;
                }
            } else if (indexPath.section == 1) {
                if (indexPath.row < rbs.count)
                    [self performSegueWithIdentifier:@"RushingStatSegue" sender:self];
                else if (indexPath.row == (rbs.count + 1)) {
                    _playerSelectContainer.hidden = NO;
                    rb = YES;
                }
            } else {
                if (indexPath.row < wrs.count)
                    [self performSegueWithIdentifier:@"TotalsReceivingSegue" sender:self];
                else if (indexPath.row == (wrs.count + 1)) {
                    _playerSelectContainer.hidden = NO;
                    wr = YES;
                }
            }
        } else if (defense) {
            if (indexPath.row < defenselist.count)
                [self performSegueWithIdentifier:@"DefenseStatSegue" sender:self];
            else if (indexPath.row == (defenselist.count + 1)) {
                _playerSelectContainer.hidden = NO;
            }
        } else {
            if (indexPath.section == 0) {
                if (indexPath.row < pks.count)
                    [self performSegueWithIdentifier:@"PlaceKickerStatSegue" sender:self];
                else if (indexPath.row == (pks.count + 1)) {
                    _playerSelectContainer.hidden = NO;
                    pk = YES;
                }
            } else if (indexPath.section == 1) {
                if (indexPath.row < kickerlist.count)
                    [self performSegueWithIdentifier:@"KickerStatSegue" sender:self];
                else if (indexPath.row == (kickerlist.count + 1)) {
                    _playerSelectContainer.hidden = NO;
                    kicker = YES;
                }
            } else if (indexPath.section == 2) {
                if (indexPath.row < punterlist.count)
                    [self performSegueWithIdentifier:@"PunterStatSegue" sender:self];
                else if (indexPath.row == (punterlist.count + 1)) {
                    _playerSelectContainer.hidden = NO;
                    punter = YES;
                }
            } else {
                if (indexPath.row < returnerlist.count)
                    [self performSegueWithIdentifier:@"ReturnerStatSegue" sender:self];
                else if (indexPath.row == (returnerlist.count + 1)) {
                    _playerSelectContainer.hidden = NO;
                    returner = YES;
                }
            }
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"  message:@"Select game to update stats for player!" delegate:nil
                                              cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PassingStatSegue"]) {
        EazesportzPassingStatsViewController *destController = segue.destinationViewController;
        if (!playerController.player) {
            NSIndexPath *indexPath = [_statsTableView indexPathForSelectedRow];
            destController.player = [qbs objectAtIndex:indexPath.row];
        } else {
            destController.player = playerController.player;
            playerController.player = nil;
        }
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"RushingStatSegue"]) {
        EazesportzRushingStatsViewController *destController = segue.destinationViewController;
        if (!playerController.player) {
            NSIndexPath *indexPath = [_statsTableView indexPathForSelectedRow];
            destController.player = [rbs objectAtIndex:indexPath.row];
        } else {
            destController.player = playerController.player;
            playerController.player = nil;
        }
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"DefenseStatSegue"]) {
        EazesportzDefenseStatsViewController *destController = segue.destinationViewController;
        if (!playerController.player) {
            NSIndexPath *indexPath = [_statsTableView indexPathForSelectedRow];
            destController.player = [defenselist objectAtIndex:indexPath.row];
        } else {
            destController.player = playerController.player;
            playerController.player = nil;
        }
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"PlaceKickerStatSegue"]) {
        EazesportzPlaceKickerViewController *destController = segue.destinationViewController;
        if (!playerController.player) {
            NSIndexPath *indexPath = [_statsTableView indexPathForSelectedRow];
            destController.player = [pks objectAtIndex:indexPath.row];
        } else {
            destController.player = playerController.player;
            playerController.player = nil;
        }
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"KickerStatSegue"]) {
        EazesportzKickoffStatsViewController *destController = segue.destinationViewController;
        if (!playerController.player) {
            NSIndexPath *indexPath = [_statsTableView indexPathForSelectedRow];
            destController.player = [kickerlist objectAtIndex:indexPath.row];
        } else {
            destController.player = playerController.player;
            playerController.player = nil;
        }
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"PunterStatSegue"]) {
        EazesportzPunterStatsViewController *destController = segue.destinationViewController;
        if (!playerController.player) {
            NSIndexPath *indexPath = [_statsTableView indexPathForSelectedRow];
            destController.player = [punterlist objectAtIndex:indexPath.row];
        } else {
            destController.player = playerController.player;
            playerController.player = nil;
        }
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"ReturnerStatSegue"]) {
        EazesportzReturnerStatsViewController *destController = segue.destinationViewController;
        if (!playerController.player) {
            NSIndexPath *indexPath = [_statsTableView indexPathForSelectedRow];
            destController.player = [returnerlist objectAtIndex:indexPath.row];
        } else {
            destController.player = playerController.player;
            playerController.player = nil;
        }
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"TotalsReceivingSegue"]) {
        EazesportzFootballReceivingTotalsViewController *destController = segue.destinationViewController;
        if (!playerController.player) {
            NSIndexPath *indexPath = [_statsTableView indexPathForSelectedRow];
            destController.player = [wrs objectAtIndex:indexPath.row];
        } else {
            destController.player = playerController.player;
            playerController.player = nil;
        }
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"PlayerSelectSegue"]) {
        playerController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"GamelogSelectSegue"]) {
        gamelogController = segue.destinationViewController;
    }
}

- (IBAction)playerSelected:(UIStoryboardSegue *)segue {
    if (playerController.player) {
        if (offense) {
            if (qb) {
                [self performSegueWithIdentifier:@"PassingStatSegue" sender:self];
            } else if (rb) {
                [self performSegueWithIdentifier:@"RushingStatSegue" sender:self];
            } else if (wr) {
                [self performSegueWithIdentifier:@"TotalsReceivingSegue" sender:self];
            }
        } else if (defense) {
            [self performSegueWithIdentifier:@"DefenseStatSegue" sender:self];
        } else {
            if (pk) {
                [self performSegueWithIdentifier:@"PlaceKickerStatSegue" sender:self];
            } else if (kicker)
                [self performSegueWithIdentifier:@"KickerStatSegue" sender:self];
            else if (punter)
                [self performSegueWithIdentifier:@"PunterStatSegue" sender:self];
            else
                [self performSegueWithIdentifier:@"ReturnerStatSegue" sender:self];
        }
    }
    
    _playerSelectContainer.hidden = YES;
}

- (IBAction)scoreLogButtonClicked:(id)sender {
    if (_gamelogContainer.hidden) {
        if (game) {
            _gamelogContainer.hidden = NO;
            gamelogController.game = game;
            [gamelogController viewWillAppear:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"No game selected to display scores."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else
        _gamelogContainer.hidden = YES;
    
    [self viewWillAppear:YES];
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
            
            if ((textField == _minutesTextField) || (textField == _secondsTextField) || (textField == _ballonTextField) ||
                (textField == _togoTextField)) {
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _visitorScoreTextField) {
        [textField resignFirstResponder];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opponent Score"  message:@"Update Opponents Score"
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Q1", @"Q2", @"Q3", @"Q4", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        textField.text = @"";
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _minutesTextField) {
        NSArray *clockentries = [_gameClockLabel.text componentsSeparatedByString:@":"];
        _gameClockLabel.text = [NSString stringWithFormat:@"%@%@%@", _minutesTextField.text, @":", clockentries[1]];
    } else if (textField == _secondsTextField) {
        NSArray *clockentries = [_gameClockLabel.text componentsSeparatedByString:@":"];
        _gameClockLabel.text = [NSString stringWithFormat:@"%@%@%@", clockentries[0], @":", _secondsTextField.text];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Add Touchdown"]) {
        if ([quarter isEqualToString:@"Q1"])
            game.opponentq1 = [NSNumber numberWithInt:[game.opponentq1 intValue] + 6];
        else if ([quarter isEqualToString:@"Q2"])
            game.opponentq2 = [NSNumber numberWithInt:[game.opponentq2 intValue] + 6];
        else if ([quarter isEqualToString:@"Q3"])
            game.opponentq3 = [NSNumber numberWithInt:[game.opponentq3 intValue] + 6];
        else
            game.opponentq4 = [NSNumber numberWithInt:[game.opponentq4 intValue] + 6];
        
        game.opponentscore = [NSNumber numberWithInt:[game.opponentscore intValue] + 6];
        _visitorScoreTextField.text = [game.opponentscore stringValue];
    } else if ([title isEqualToString:@"Delete Touchdown"]) {
        if (([quarter isEqualToString:@"Q1"]) && ([game.opponentq1 intValue] >= 6))
            game.opponentq1 = [NSNumber numberWithInt:[game.opponentq1 intValue] - 6];
        else if (([quarter isEqualToString:@"Q2"]) && ([game.opponentq2 intValue] >= 6))
            game.opponentq2 = [NSNumber numberWithInt:[game.opponentq2 intValue] - 6];
        else if (([quarter isEqualToString:@"Q3"]) && ([game.opponentq3 intValue] >= 6))
            game.opponentq3 = [NSNumber numberWithInt:[game.opponentq3 intValue] - 6];
        else if ([game.opponentq4 intValue] >= 6)
            game.opponentq4 = [NSNumber numberWithInt:[game.opponentq4 intValue] - 6];
        
        game.opponentscore = [NSNumber numberWithInt:[game.opponentscore intValue] - 6];
        _visitorScoreTextField.text = [game.opponentscore stringValue];
    } else if ([title isEqualToString:@"Add Field Goal"]) {
        if ([quarter isEqualToString:@"Q1"])
            game.opponentq1 = [NSNumber numberWithInt:[game.opponentq1 intValue] + 3];
        else if ([quarter isEqualToString:@"Q2"])
            game.opponentq2 = [NSNumber numberWithInt:[game.opponentq2 intValue] + 3];
        else if ([quarter isEqualToString:@"Q3"])
            game.opponentq3 = [NSNumber numberWithInt:[game.opponentq3 intValue] + 3];
        else
            game.opponentq4 = [NSNumber numberWithInt:[game.opponentq4 intValue] + 3];
        
        game.opponentscore = [NSNumber numberWithInt:[game.opponentscore intValue] + 3];
        _visitorScoreTextField.text = [game.opponentscore stringValue];
    } else if ([title isEqualToString:@"Delete Field Goal"]) {
        if (([quarter isEqualToString:@"Q1"]) && ([game.opponentq1 intValue] >= 3))
            game.opponentq1 = [NSNumber numberWithInt:[game.opponentq1 intValue] - 3];
        else if (([quarter isEqualToString:@"Q2"]) && ([game.opponentq1 intValue] >= 3))
            game.opponentq2 = [NSNumber numberWithInt:[game.opponentq2 intValue] - 3];
        else if (([quarter isEqualToString:@"Q3"]) && ([game.opponentq1 intValue] >= 3))
            game.opponentq3 = [NSNumber numberWithInt:[game.opponentq3 intValue] - 3];
        else if ([game.opponentq1 intValue] >= 3)
            game.opponentq4 = [NSNumber numberWithInt:[game.opponentq4 intValue] - 3];
        
        game.opponentscore = [NSNumber numberWithInt:[game.opponentscore intValue] - 3];
        _visitorScoreTextField.text = [game.opponentscore stringValue];
    } else if ([title isEqualToString:@"Add Extra Point"]) {
        if ([quarter isEqualToString:@"Q1"])
            game.opponentq1 = [NSNumber numberWithInt:[game.opponentq1 intValue] + 1];
        else if ([quarter isEqualToString:@"Q2"])
            game.opponentq2 = [NSNumber numberWithInt:[game.opponentq2 intValue] + 1];
        else if ([quarter isEqualToString:@"Q3"])
            game.opponentq3 = [NSNumber numberWithInt:[game.opponentq3 intValue] + 1];
        else
            game.opponentq4 = [NSNumber numberWithInt:[game.opponentq4 intValue] + 1];
        
        game.opponentscore = [NSNumber numberWithInt:[game.opponentscore intValue] + 1];
        _visitorScoreTextField.text = [game.opponentscore stringValue];
    } else if ([title isEqualToString:@"Delete Extra Point"]) {
        if (([quarter isEqualToString:@"Q1"]) && ([game.opponentq1 intValue] >= 1))
            game.opponentq1 = [NSNumber numberWithInt:[game.opponentq1 intValue] - 1];
        else if (([quarter isEqualToString:@"Q2"]) && ([game.opponentq1 intValue] >= 1))
            game.opponentq2 = [NSNumber numberWithInt:[game.opponentq2 intValue] - 1];
        else if (([quarter isEqualToString:@"Q3"]) && ([game.opponentq1 intValue] >= 1))
            game.opponentq3 = [NSNumber numberWithInt:[game.opponentq3 intValue] - 1];
        else if ([game.opponentq1 intValue] >= 1)
            game.opponentq4 = [NSNumber numberWithInt:[game.opponentq4 intValue] - 1];
        
        game.opponentscore = [NSNumber numberWithInt:[game.opponentscore intValue] - 1];
        _visitorScoreTextField.text = [game.opponentscore stringValue];
    } else if ([title isEqualToString:@"Add 2PT"]) {
        if ([quarter isEqualToString:@"Q1"])
            game.opponentq1 = [NSNumber numberWithInt:[game.opponentq1 intValue] + 2];
        else if ([quarter isEqualToString:@"Q2"])
            game.opponentq2 = [NSNumber numberWithInt:[game.opponentq2 intValue] + 2];
        else if ([quarter isEqualToString:@"Q3"])
            game.opponentq3 = [NSNumber numberWithInt:[game.opponentq3 intValue] + 2];
        else
            game.opponentq4 = [NSNumber numberWithInt:[game.opponentq4 intValue] + 2];
        
        game.opponentscore = [NSNumber numberWithInt:[game.opponentscore intValue] + 2];
        _visitorScoreTextField.text = [game.opponentscore stringValue];
    } else if ([title isEqualToString:@"Delete 2PT"]) {
        if (([quarter isEqualToString:@"Q1"]) && ([game.opponentq1 intValue] >= 2))
            game.opponentq1 = [NSNumber numberWithInt:[game.opponentq1 intValue] - 2];
        else if (([quarter isEqualToString:@"Q2"]) && ([game.opponentq1 intValue] >= 2))
            game.opponentq2 = [NSNumber numberWithInt:[game.opponentq2 intValue] - 2];
        else if (([quarter isEqualToString:@"Q3"]) && ([game.opponentq1 intValue] >= 2))
            game.opponentq3 = [NSNumber numberWithInt:[game.opponentq3 intValue] - 2];
        else if ([game.opponentq1 intValue] >= 2)
            game.opponentq4 = [NSNumber numberWithInt:[game.opponentq4 intValue] - 2];
        
        game.opponentscore = [NSNumber numberWithInt:[game.opponentscore intValue] - 2];
        _visitorScoreTextField.text = [game.opponentscore stringValue];
    } else if ([title isEqualToString:@"Q1"]) {
        quarter = @"Q1";
        [self scoreType];
    } else if ([title isEqualToString:@"Q2"]) {
        quarter = @"Q2";
        [self scoreType];
    } else if ([title isEqualToString:@"Q3"]) {
        quarter = @"Q3";
        [self scoreType];
    } else if ([title isEqualToString:@"Q4"]) {
        quarter = @"Q4";
        [self scoreType];
    }
}

- (void)scoreType {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Score"  message:@"Score Type"
                         delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Touchdown", @"Delete Touchdown", @"Add Field Goal",
                          @"Delete Field Goal", @"Add Extra Point", @"Delete Extra Point", @"Add 2PT", @"Delete 2PT", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)searchBlogGameLog:(UIStoryboardSegue *)segue {
    _gamelogContainer.hidden = YES;
}

- (IBAction)finalButtonClicked:(id)sender {
    if (_finalLabel.hidden) {
        _finalLabel.hidden = NO;
        game.gameisfinal = YES;
    } else {
        _finalLabel.hidden = YES;
        game.gameisfinal = NO;
    }
}
@end
