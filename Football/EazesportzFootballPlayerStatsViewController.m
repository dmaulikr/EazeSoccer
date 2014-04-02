//
//  EazesportzFootballPlayerStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 12/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzFootballPlayerStatsViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzFootballStatsTableViewCell.h"

@interface EazesportzFootballPlayerStatsViewController ()

@end

@implementation EazesportzFootballPlayerStatsViewController {
    BOOL offense, defense, specialteams;
    NSMutableArray *qbs, *rbs, *wrs, *defenselist, *pks, *kickerlist, *punterlist, *retrunerlist;
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
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.offenseButton, self.defenseButton, self.specialteamsButton, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = player.full_name;
    offense = defense = specialteams = NO;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Select Button to Display Stats"
                                                   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)offenseButtonClicked:(id)sender {
    offense = YES;
    defense = specialteams = NO;
    qbs = [[NSMutableArray alloc] init];
    rbs = [[NSMutableArray alloc] init];
    wrs = [[NSMutableArray alloc] init];
    
    if (player ) {
        for (int i = 0; i < currentSettings.gameList.count; i++) {
            if ([player isQB:[[currentSettings.gameList objectAtIndex:i] id]])
                [qbs addObject:[player findFootballPassingStat:[[currentSettings.gameList objectAtIndex:i] id]]];
        }
        
        for (int i = 0; i < currentSettings.gameList.count; i++) {
            if ([player isRB:[[currentSettings.gameList objectAtIndex:i]id]])
                [rbs addObject:[player findFootballRushingStat:[[currentSettings.gameList objectAtIndex:i] id]]];
        }
        
        for (int i = 0; i < currentSettings.gameList.count; i++) {
            if ([player isWR:[[currentSettings.gameList objectAtIndex:i] id]])
                [wrs addObject:[player findFootballReceivingStat:[[currentSettings.gameList objectAtIndex:i] id]]];
        }
    } else {
        for (int i = 0; i < currentSettings.roster.count; i++) {
            if ([[currentSettings.roster objectAtIndex:i] isQB:game.id])
                [qbs addObject:[[currentSettings.roster objectAtIndex:i] findFootballPassingStat:game.id]];
        }
        
        for (int i = 0; i < currentSettings.roster.count; i++) {
            if ([[currentSettings.roster objectAtIndex:i] isRB:game.id])
                [rbs addObject:[[currentSettings.roster objectAtIndex:i] findFootballRushingStat:game.id]];
        }
        
        for (int i = 0; i < currentSettings.roster.count; i++) {
            if ([[currentSettings.roster objectAtIndex:i] isWR:game.id])
                [wrs addObject:[[currentSettings.roster objectAtIndex:i] findFootballReceivingStat:game.id]];
        }
    
    }
    
    if ((qbs.count > 0) || (rbs.count > 0) || (wrs.count > 0))
        [_playerstatsTableView reloadData];
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"No Offensive Stats"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (IBAction)defenseButtonClicked:(id)sender {
    defense = YES;
    offense = specialteams = NO;
    defenselist = [[NSMutableArray alloc] init];
    
    if (player) {
        for (int i = 0; i < currentSettings.gameList.count; i++) {
            if ([player isDEF:[currentSettings.gameList objectAtIndex:i]])
                [defenselist addObject:[player findFootballDefenseStat:[[currentSettings.gameList objectAtIndex:i] id]]];
        }
    } else {
        for (int i = 0; i < currentSettings.roster.count; i++) {
            if ([[currentSettings.roster objectAtIndex:i] isDEF:game.id])
                [defenselist addObject:[[currentSettings.roster objectAtIndex:i] findFootballDefenseStat:game.id]];
        }
    }
    
    if (defenselist.count > 0)
        [_playerstatsTableView reloadData];
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"No Defensive Stats"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (IBAction)specialteamsButtonClicked:(id)sender {
    specialteams = YES;
    offense = defense = NO;
    punterlist = [[NSMutableArray alloc] init];
    pks = [[NSMutableArray alloc] init];
    kickerlist = [[NSMutableArray alloc] init];
    retrunerlist = [[NSMutableArray alloc] init];
    
    
    if (player ) {
        for (int i = 0; i < currentSettings.gameList.count; i++) {
            if ([player isPK:[currentSettings.gameList objectAtIndex:i]])
                [pks addObject:[player findFootballPlaceKickerStat:[[currentSettings.gameList objectAtIndex:i] id]]];
        }
        
        for (int i = 0; i < currentSettings.gameList.count; i++) {
            if ([player isKicker:[currentSettings.gameList objectAtIndex:i]])
                [kickerlist addObject:[player findFootballKickerStat:[[currentSettings.gameList objectAtIndex:i] id]]];
        }
        
        for (int i = 0; i < currentSettings.gameList.count; i++) {
            if ([player isPunter:[currentSettings.gameList objectAtIndex:i]])
                [punterlist addObject:[player findFootballPunterStat:[[currentSettings.gameList objectAtIndex:i] id]]];
        }
        
        for (int i = 0; i < currentSettings.gameList.count; i++) {
            if ([player isReturner:[currentSettings.gameList objectAtIndex:i]])
                [retrunerlist addObject:[player findFootballReturnerStat:[[currentSettings.gameList objectAtIndex:i] id]]];
        }
    } else {
        for (int i = 0; i < currentSettings.roster.count; i++) {
            if ([[currentSettings.roster objectAtIndex:i] isQB:game.id])
                [pks addObject:[[currentSettings.roster objectAtIndex:i] findFootballPlaceKickerStat:game.id]];
        }
        
        for (int i = 0; i < currentSettings.roster.count; i++) {
            if ([[currentSettings.roster objectAtIndex:i] isRB:game.id])
                [kickerlist addObject:[[currentSettings.roster objectAtIndex:i] findFootballKickerStat:game.id]];
        }
        
        for (int i = 0; i < currentSettings.roster.count; i++) {
            if ([[currentSettings.roster objectAtIndex:i] isWR:game.id])
                [punterlist addObject:[[currentSettings.roster objectAtIndex:i] findFootballPunterStat:game.id]];
        }
        
        for (int i = 0; i < currentSettings.roster.count; i++) {
            if ([[currentSettings.roster objectAtIndex:i] isWR:game.id])
                [retrunerlist addObject:[[currentSettings.roster objectAtIndex:i] findFootballReturnerStat:game.id]];
        }
    }
    
    if ((pks.count > 0) || (kickerlist.count > 0) || (punterlist.count > 0) || (retrunerlist.count > 0))
        [_playerstatsTableView reloadData];
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"No Special Teams Stats"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
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
        if (section == 0)
            return qbs.count + 1;
        else if (section == 1)
            return rbs.count + 1;
        else
            return wrs.count + 1;
    } else if (specialteams) {
        if (section == 0)
            return pks.count + 1;
        else if (section == 1)
            return kickerlist.count + 1;
        else if (section == 2)
            return punterlist.count + 1;
        else
            return retrunerlist.count + 1;
     } else {
        return defenselist.count + 1;
     }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlayerStatsTableCell";
    EazesportzFootballStatsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[EazesportzFootballStatsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (offense ) {
        if (indexPath.section == 0) {
            FootballPassingStat *stat = [[FootballPassingStat alloc] init];
            
            if ((player)  && (indexPath.row < qbs.count)) {
                stat = [qbs objectAtIndex:indexPath.row];
                GameSchedule *agame = [currentSettings findGame:stat.gameschedule_id];
                cell.fbimageView.image = [agame opponentImage];
                cell.namelabel.text = [NSString stringWithFormat:@"%@%@", @"vs. ", agame.opponent_mascot];
            } else if ((game) && (indexPath.row < qbs.count)) { // game
                stat = [qbs objectAtIndex:indexPath.row];
                Athlete *aplayer = [currentSettings findAthlete:stat.athlete_id];
                cell.fbimageView.image = [currentSettings getRosterTinyImage:aplayer];
                cell.namelabel.text = aplayer.numberLogname;
            } else {
                cell.namelabel.text = @"Totals";
                
                for (int cnt = 0; cnt < qbs.count; cnt++) {
                    FootballPassingStat *astat = [qbs objectAtIndex:cnt];
                    stat.attempts = [NSNumber numberWithInt:[stat.attempts intValue] + [astat.attempts intValue]];
                    stat.completions = [NSNumber numberWithInt:[stat.completions intValue] + [astat.completions intValue]];
                    stat.td = [NSNumber numberWithInt:[stat.td intValue] + [astat.td intValue]];
                    stat.yards = [NSNumber numberWithInt:[stat.yards intValue] + [astat.yards intValue]];
                    stat.interceptions = [NSNumber numberWithInt:[stat.interceptions intValue] + [astat.interceptions intValue]];
                    stat.sacks = [NSNumber numberWithInt:[stat.sacks intValue] + [astat.sacks intValue]];
                    stat.firstdowns = [NSNumber numberWithInt:[stat.firstdowns intValue] + [astat.firstdowns intValue]];
                    stat.yards_lost = [NSNumber numberWithInt:[stat.yards_lost intValue] + [astat.yards_lost intValue]];
                    stat.twopointconv = [NSNumber numberWithInt:[stat.twopointconv intValue] + [astat.twopointconv intValue]];
                }
            }
           
            cell.label1.text = [stat.attempts stringValue];
            cell.label2.text = [stat.completions stringValue];
            
            if ([stat.attempts intValue] > 0)
                cell.label3.text = [NSString stringWithFormat:@"%.02f", [stat.completions floatValue]/[stat.attempts floatValue]];
            else
                cell.label3.text = @"0.0";
            
            cell.label4.text = [stat.yards stringValue];
            cell.label5.text = [stat.td stringValue];
            cell.label6.text = [stat.interceptions stringValue];
            cell.label7.text = [stat.sacks stringValue];
            cell.label8.text = [stat.firstdowns stringValue];
            cell.label9.text = [stat.yards_lost stringValue];
            cell.label10.text = [stat.twopointconv stringValue];
            cell.label11.text = @"";
        } else if (indexPath.section == 1) {
            FootballRushingStat *stat = [[FootballRushingStat alloc] init];
            
            if ((player)  && (indexPath.row < rbs.count)) {
                stat = [rbs objectAtIndex:indexPath.row];
                GameSchedule *agame = [currentSettings findGame:stat.gameschedule_id];
                cell.fbimageView.image = [agame opponentImage];
                cell.namelabel.text = [NSString stringWithFormat:@"%@%@", @"vs. ", agame.opponent_mascot];
            } else if ((game) && (indexPath.row < rbs.count)) { // game
                stat = [rbs objectAtIndex:indexPath.row];
                Athlete *aplayer = [currentSettings findAthlete:stat.athlete_id];
                cell.fbimageView.image = [currentSettings getRosterTinyImage:aplayer];
                cell.namelabel.text = aplayer.numberLogname;
            } else {
                cell.namelabel.text = @"Totals";
                
                for (int cnt = 0; cnt < rbs.count; cnt++) {
                    FootballRushingStat *astat = [rbs objectAtIndex:cnt];
                    stat.attempts = [NSNumber numberWithInt:[stat.attempts intValue] + [astat.attempts intValue]];
                    stat.yards = [NSNumber numberWithInt:[stat.yards intValue] + [astat.yards intValue]];
                    
                    if ([stat.attempts intValue] > 0)
                        stat.average = [NSNumber numberWithFloat:[stat.yards floatValue] / [stat.attempts floatValue]];
                    else
                        stat.average = [NSNumber numberWithFloat:0.0];
                    
                    stat.td = [NSNumber numberWithInt:[stat.td intValue] + [astat.td intValue]];
                    stat.firstdowns = [NSNumber numberWithInt:[stat.firstdowns intValue] + [astat.firstdowns intValue]];
                    stat.fumbles = [NSNumber numberWithInt:[stat.fumbles intValue] + [astat.fumbles intValue]];
                    stat.fumbles_lost = [NSNumber numberWithInt:[stat.fumbles_lost intValue] + [astat.fumbles_lost intValue]];
                    
                    if ([stat.longest intValue] < [astat.longest intValue])
                        stat.longest = astat.longest;
                    
                    stat.twopointconv = [NSNumber numberWithInt:[stat.twopointconv intValue] + [astat.twopointconv intValue]];
                }
            }
            
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
        } else {
            FootballReceivingStat *stat = [[FootballReceivingStat alloc] init];
            
            if ((player) && (indexPath.row < wrs.count)) {
                stat = [wrs objectAtIndex:indexPath.row];
                GameSchedule *agame = [currentSettings findGame:stat.gameschedule_id];
                cell.fbimageView.image = [agame opponentImage];
                cell.namelabel.text = [NSString stringWithFormat:@"%@%@", @"vs. ", agame.opponent_mascot];
            } else if ((game) && (indexPath.row < wrs.count)) {
                stat = [wrs objectAtIndex:indexPath.row];
                Athlete *aplayer = [currentSettings findAthlete:stat.athlete_id];
                cell.fbimageView.image = [currentSettings getRosterTinyImage:aplayer];
                cell.namelabel.text = aplayer.logname;
            } else {
                cell.namelabel.text = @"Totals";
                
                for (int cnt = 0; cnt < wrs.count; cnt++) {
                    FootballReceivingStat *astat = [wrs objectAtIndex:cnt];
                    stat.receptions = [NSNumber numberWithInt:[stat.receptions intValue] + [astat.receptions intValue]];
                    stat.yards = [NSNumber numberWithInt:[stat.yards intValue] + [astat.yards intValue]];
                    
                    if ([stat.receptions intValue] > 0)
                        stat.average = [NSNumber numberWithFloat:[stat.yards floatValue] / [stat.receptions floatValue]];
                    else
                        stat.average = [NSNumber numberWithFloat:0.0];
                    
                    stat.td = [NSNumber numberWithInt:[stat.td intValue] + [astat.td intValue]];
                    stat.firstdowns = [NSNumber numberWithInt:[stat.firstdowns intValue] + [astat.firstdowns intValue]];
                    stat.fumbles = [NSNumber numberWithInt:[stat.fumbles intValue] + [astat.fumbles intValue]];
                    stat.fumbles_lost = [NSNumber numberWithInt:[stat.fumbles_lost intValue] + [astat.fumbles_lost intValue]];
                    
                    if ([stat.longest intValue] < [astat.longest intValue])
                        stat.longest = astat.longest;
                    
                    stat.twopointconv = [NSNumber numberWithInt:[stat.twopointconv intValue] + [astat.twopointconv intValue]];
                }
            }

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
        }
        
    } else if (specialteams) {
        if (indexPath.section == 0) {
            FootballPlaceKickerStats *stat = [[FootballPlaceKickerStats alloc] init];
            
            if ((player) && (indexPath.row < pks.count)) {
                stat = [pks objectAtIndex:indexPath.row];
                GameSchedule *agame = [currentSettings findGame:stat.gameschedule_id];
                cell.fbimageView.image = [agame opponentImage];
                cell.namelabel.text = [NSString stringWithFormat:@"%@%@", @"vs. ", agame.opponent_mascot];
            } else if ((game) && (indexPath.row < pks.count)) {
                stat = [pks objectAtIndex:indexPath.row];
                Athlete *aplayer = [currentSettings findAthlete:stat.athlete_id];
                cell.fbimageView.image = [currentSettings getRosterTinyImage:aplayer];
                cell.namelabel.text = aplayer.logname;
            } else {
                cell.namelabel.text = @"Totals";
                
                for (int cnt = 0; cnt < pks.count; cnt++) {
                    FootballPlaceKickerStats *astat = [pks objectAtIndex:cnt];
                    stat.fgattempts = [NSNumber numberWithInt:[stat.fgattempts intValue] + [astat.fgattempts intValue]];
                    stat.fgmade = [NSNumber numberWithInt:[stat.fgmade intValue] + [astat.fgmade intValue]];
                    stat.fgblocked = [NSNumber numberWithInt:[stat.fgblocked intValue] + [astat.fgblocked intValue]];
                    stat.xpattempts = [NSNumber numberWithInt:[stat.xpattempts intValue] + [astat.xpattempts intValue]];
                    stat.xpmade = [NSNumber numberWithInt:[stat.xpmade intValue] + [astat.xpmade intValue]];
                    stat.xpblocked = [NSNumber numberWithInt:[stat.xpblocked intValue] + [astat.xpblocked intValue]];
 
                    if ([stat.fglong intValue] < [astat.fglong intValue]) {
                        stat.fglong = astat.fglong;
                    }
                }
            }
            
            cell.fbimageView.image = [currentSettings getRosterTinyImage:player];
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
            FootballKickerStats *stat = [[FootballKickerStats alloc] init];
            
            if ((player) && (indexPath.row < kickerlist.count)) {
                stat = [kickerlist objectAtIndex:indexPath.row];
                GameSchedule *agame = [currentSettings findGame:stat.gameschedule_id];
                cell.fbimageView.image = [agame opponentImage];
                cell.namelabel.text = [NSString stringWithFormat:@"%@%@", @"vs. ", agame.opponent_mascot];
            } else if ((game) && (indexPath.row < kickerlist.count)) {
                stat = [kickerlist objectAtIndex:indexPath.row];
                Athlete *aplayer = [currentSettings findAthlete:stat.athlete_id];
                cell.fbimageView.image = [currentSettings getRosterTinyImage:aplayer];
                cell.namelabel.text = aplayer.logname;
            } else {
                cell.namelabel.text = @"Totals";
                
                for (int cnt = 0; cnt < kickerlist.count; cnt++) {
                    FootballKickerStats *astat = [kickerlist objectAtIndex:cnt];
                    stat.koattempts = [NSNumber numberWithInt:[stat.koattempts intValue] + [astat.koattempts intValue]];
                    stat.koreturned = [NSNumber numberWithInt:[stat.koreturned intValue] + [astat.koreturned intValue]];
                    stat.kotouchbacks = [NSNumber numberWithInt:[stat.kotouchbacks intValue] + [astat.kotouchbacks intValue]];
                }
            }
            
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
            FootballPunterStats *stat = [[FootballPunterStats alloc] init];
            
            if ((player) && (indexPath.row < punterlist.count)) {
                stat = [punterlist objectAtIndex:indexPath.row];
                GameSchedule *agame = [currentSettings findGame:stat.gameschedule_id];
                cell.fbimageView.image = [agame opponentImage];
                cell.namelabel.text = [NSString stringWithFormat:@"%@%@", @"vs. ", agame.opponent_mascot];
            } else if ((game) && (indexPath.row < punterlist.count)) {
                stat = [punterlist objectAtIndex:indexPath.row];
                Athlete *aplayer = [currentSettings findAthlete:stat.athlete_id];
                cell.fbimageView.image = [currentSettings getRosterTinyImage:aplayer];
                cell.namelabel.text = aplayer.logname;
            } else {
                cell.namelabel.text = @"Totals";
                
                for (int cnt = 0; cnt < punterlist.count; cnt++) {
                    FootballPunterStats *astat = [punterlist objectAtIndex:cnt];
                    stat.punts = [NSNumber numberWithInt:[stat.punts intValue] + [astat.punts intValue]];
                    stat.punts_blocked = [NSNumber numberWithInt:[stat.punts_blocked intValue] + [astat.punts_blocked intValue]];
                    stat.punts_yards = [NSNumber numberWithInt:[stat.punts_yards intValue] + [astat.punts_yards intValue]];
 
                    if ([stat.punts_long intValue] < [astat.punts_long intValue]) {
                        stat.punts_long = astat.punts_long;
                    }
                }
                
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
            }
        } else {
            FootballReturnerStats *stat = [[FootballReturnerStats alloc] init];
            
            if ((player) && (indexPath.row < retrunerlist.count)) {
                stat = [retrunerlist objectAtIndex:indexPath.row];
                GameSchedule *agame = [currentSettings findGame:stat.gameschedule_id];
                cell.fbimageView.image = [agame opponentImage];
                cell.namelabel.text = [NSString stringWithFormat:@"%@%@", @"vs. ", agame.opponent_mascot];
            } else if ((game) && (indexPath.row < retrunerlist.count)) {
                stat = [retrunerlist objectAtIndex:indexPath.row];
                Athlete *aplayer = [currentSettings findAthlete:stat.athlete_id];
                cell.fbimageView.image = [currentSettings getRosterTinyImage:aplayer];
                cell.namelabel.text = aplayer.logname;
            } else {
                cell.namelabel.text = @"Totals";
                
                for (int cnt = 0; cnt < retrunerlist.count; cnt++) {
                    FootballReturnerStats *astat = [retrunerlist objectAtIndex:cnt];
                    stat.koreturn = [NSNumber numberWithInt:[stat.koreturn intValue] + [astat.koreturn intValue]];
                    stat.kotd = [NSNumber numberWithInt:[stat.kotd intValue] + [astat.kotd intValue]];
                    stat.koyards = [NSNumber numberWithInt:[stat.koyards intValue] + [astat.koyards intValue]];
                    
                    if ([stat.kolong intValue] < [astat.kolong intValue]) {
                        stat.kolong = astat.kolong;
                    }
                    
                    stat.punt_return = [NSNumber numberWithInt:[stat.punt_return intValue] + [astat.punt_return intValue]];
                    stat.punt_returntd = [NSNumber numberWithInt:[stat.punt_returntd intValue] + [astat.punt_returntd intValue]];
                    stat.punt_returnyards = [NSNumber numberWithInt:[stat.punt_returnyards intValue] + [astat.punt_returnyards intValue]];
                    
                    if ([stat.punt_returnlong intValue] < [astat.punt_returnlong intValue]) {
                        stat.punt_returnlong = astat.punt_returnlong;
                    }
                }
                
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
            }
        }
        
    } else if (defense) {
        if (indexPath.section == 0) {
            FootballDefenseStats *stat = [[FootballDefenseStats alloc] init];
            
            if ((player) && (indexPath.row < defenselist.count)) {
                stat = [defenselist objectAtIndex:indexPath.row];
                GameSchedule *agame = [currentSettings findGame:stat.gameschedule_id];
                cell.namelabel.text = [NSString stringWithFormat:@"%@%@", @"vs. ", agame.opponent_mascot];
            } else if ((game) && (indexPath.row < defenselist.count)) {
                stat = [defenselist objectAtIndex:indexPath.row];
                Athlete *aplayer = [currentSettings findAthlete:stat.athlete_id];
                cell.fbimageView.image = [currentSettings getRosterTinyImage:aplayer];
                cell.namelabel.text = aplayer.logname;
            } else {
                cell.namelabel.text = @"Totals";
                
                for (int cnt = 0; cnt < defenselist.count; cnt++) {
                    FootballDefenseStats *astat = [defenselist objectAtIndex:cnt];
                    stat.tackles = [NSNumber numberWithInt:[stat.tackles intValue] + [astat.tackles intValue]];
                    stat.assists = [NSNumber numberWithInt:[stat.assists intValue] + [astat.assists intValue]];
                    stat.sacks = [NSNumber numberWithInt:[stat.sacks intValue] + [astat.sacks intValue]];
                    stat.sackassist = [NSNumber numberWithInt:[stat.sackassist intValue] + [astat.sackassist intValue]];
                    stat.interceptions = [NSNumber numberWithInt:[stat.interceptions intValue] + [astat.interceptions intValue]];
                    stat.pass_defended = [NSNumber numberWithInt:[stat.pass_defended intValue] + [astat.pass_defended intValue]];
                    stat.int_yards = [NSNumber numberWithInt:[stat.int_yards intValue] + [astat.int_yards intValue]];
                    stat.int_long = [NSNumber numberWithInt:[stat.int_long intValue] + [astat.int_long intValue]];
                    stat.td = [NSNumber numberWithInt:[stat.td intValue] + [astat.td intValue]];
                    stat.fumbles_recovered = [NSNumber numberWithInt:[stat.fumbles_recovered intValue] + [astat.fumbles_recovered intValue]];
                    stat.safety = [NSNumber numberWithInt:[stat.safety intValue] + [astat.safety intValue]];
                }
            }
            
            if ([stat.assists intValue] > 0)
                cell.label1.text = [NSString stringWithFormat:@"%01f", ([stat.tackles floatValue] + ([stat.assists floatValue]/2))];
            else
                cell.label1.text = [stat.tackles stringValue];
            
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
       }
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
            return @"                WR                      REC    YDS       AVG     TD       FD      LNG    FUMB        LSTFUMB  2PT";
        
    } else if (specialteams) {
        if (section == 0)
            return @"                Place Kicker        FGA    FGM   FGBLK  FGLNG XPA   XPM  XPBLK";
        else if (section == 1)
            return @"                Kicker                Kickoffs      Touchbacks      Returned";
        else if (section== 2)
            return @"                Punter                Punts    Blkd    Yards   Long    AVG";
        else
            return @"                Returner             Punts  Yards     TD      Long    AVG   Kickoffs Yards     TD      Long    AVG";
        
    } else if (defense)
        return @"                Defender              TK      SACK    INT    PDEF  RYDS  RLNG    TD     FUMREC   SFTY";
    else
        return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
