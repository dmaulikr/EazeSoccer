//
//  EazesportzFootballTotalsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 3/25/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzFootballTotalsViewController.h"

#import "EazesportzFootballStatsTableViewCell.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzFootballPassingTotalsViewController.h"
#import "EazesportzFootballRushingTotalsViewController.h"
#import "EazesportzFootballDefenseTotalsViewController.h"
#import "EazesportzFootballPlaceKickerTotalsViewController.h"
#import "EazesportzFootballKickerTotalsViewController.h"
#import "EazesportzFootballPunterTotalsViewController.h"
#import "EazesportzFootballReturnerTotalsViewController.h"
#import "EazesportzFootballReceivingTotalsViewController.h"

@interface EazesportzFootballTotalsViewController ()

@end

@implementation EazesportzFootballTotalsViewController {
    BOOL offense, defense, specialteams;
}

@synthesize athlete;
@synthesize game;
@synthesize qbs, rbs, wrs, pks, kickerlist, returnerlist, punterlist, defenselist;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = [game vsOpponent];
    [_statsTableView reloadData];
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
                cell.fbimageView.image = [currentSettings getRosterTinyImage:player];
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
                cell.fbimageView.image = [currentSettings getRosterTinyImage:player];
                cell.namelabel.text = player.numberLogname;
                cell.label1.text = [stat.attempts stringValue];
                cell.label2.text = [stat.yards stringValue];
                cell.label3.text = [NSString stringWithFormat:@"%.02f", [stat.average floatValue]];
                cell.label4.text = [stat.td stringValue];
                cell.label5.text = [stat.firstdowns stringValue];
                cell.label6.text = [stat.longest stringValue];
                cell.label7.text = [stat.fumbles stringValue];
                cell.label8.text = [stat.fumbles_lost stringValue];
                cell.label9.text = [stat.twopointconv stringValue];
                cell.label10.text = @"";
                cell.label11.text = @"";
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
                cell.label8.text = [NSString stringWithFormat:@"%d", lostfumbles];
                cell.label9.text = [NSString stringWithFormat:@"%d", twopoint];
                cell.label10.text = @"";
                cell.label11.text = @"";
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row < wrs.count) {
                player = [wrs objectAtIndex:indexPath.row];
                FootballReceivingStat *stat = [player findFootballReceivingStat:game.id];
                cell.fbimageView.image = [currentSettings getRosterTinyImage:player];
                cell.namelabel.text = player.numberLogname;
                cell.label1.text = [stat.receptions stringValue];
                cell.label2.text = [stat.yards stringValue];
                cell.label3.text = [NSString stringWithFormat:@"%.02f", [stat.average floatValue]];
                cell.label4.text = [stat.td stringValue];
                cell.label5.text = [stat.firstdowns stringValue];
                cell.label6.text = [stat.longest stringValue];
                cell.label7.text = [stat.fumbles stringValue];
                cell.label8.text = [stat.fumbles_lost stringValue];
                cell.label9.text = [stat.twopointconv stringValue];
                cell.label10.text = @"";
                cell.label11.text = @"";
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
                cell.label8.text = [NSString stringWithFormat:@"%d", lostfumbles];
                cell.label9.text = [NSString stringWithFormat:@"%d", twopoint];
                cell.label10.text = @"";
                cell.label11.text = @"";
            }
        }
    } else if (specialteams) {
        if (indexPath.section == 0) {
            if (indexPath.row < pks.count) {
                player = [pks objectAtIndex:indexPath.row];
                FootballPlaceKickerStats *stat = [player findFootballPlaceKickerStat:game.id];
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
                cell.fbimageView.image = [currentSettings getRosterTinyImage:player];
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
                cell.fbimageView.image = [currentSettings getRosterTinyImage:player];
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
                cell.fbimageView.image = [currentSettings getRosterTinyImage:player];
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
            cell.fbimageView.image = [currentSettings getRosterTinyImage:player];
            cell.namelabel.text = player.numberLogname;
            
            if ([stat.assists intValue] > 0)
            cell.label1.text = [NSString stringWithFormat:@"%.01f", ([stat.tackles floatValue] + ([stat.assists floatValue]/2))];
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
            cell.label1.text = [NSString stringWithFormat:@"%.01f", ((float)tackles + ((float)assists/2))];
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
            return @"                QB                               ATT    CMP      PCT     YDS      TD       INT     SCK      FD      YDL     2PT ";
        else if (section == 1)
            return @"                Rusher                        ATT    YDS      AVG      TD       FD      LNG    FMB     LST      2PT";
        else
            return @"                WR                               REC    YDS       AVG     TD       FD       LNG    FMB     LST     2PT";
    } else if (specialteams) {
        if (section == 0)
            return @"                Place Kicker                FGA    FGM    BLK     LNG     XPA     XPM     BLK";
        else if (section == 1)
            return @"                Kicker                       Kickoffs         Returned         Touchbacks";
        else if (section== 2)
            return @"                Punter                        Punts    BLK     YDS     LNG     AVG";
        else
            return @"                Returner                     Punts   YDS      TD       LNG    AVG      KO      YDS      TD       LNG     AVG";
        
    } else
        return @"                Defender                      TK       SCK     INT       PD      RYD     LNG      TD      FRC     SFY";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (offense) {
        switch (indexPath.section) {
            case 0:
                if (indexPath.row < qbs.count)
                    [self performSegueWithIdentifier:@"PassingStatSegue" sender:self];
                break;
                
            case 1:
                if (indexPath.row < rbs.count)
                    [self performSegueWithIdentifier:@"RushingStatSegue" sender:self];
                break;
                
            default:
                if (indexPath.row < wrs.count)
                    [self performSegueWithIdentifier:@"ReceivingStatSegue" sender:self];
                break;
        }
    } else if (defense) {
        if (indexPath.row < defenselist.count)
            [self performSegueWithIdentifier:@"DefenseStatSegue" sender:self];
    } else {
        switch (indexPath.section) {
            case 0:
                if (indexPath.row < pks.count)
                    [self performSegueWithIdentifier:@"PlaceKickerStatSegue" sender:self];
                break;
                
            case 1:
                if (indexPath.row < pks.count)
                    [self performSegueWithIdentifier:@"KickerStatSegue" sender:self];
                break;
                
            case 2:
                if (indexPath.row < pks.count)
                    [self performSegueWithIdentifier:@"PunterStatSegue" sender:self];
                break;
                
            default:
                if (indexPath.row < pks.count)
                    [self performSegueWithIdentifier:@"ReturnerStatSegue" sender:self];
                break;
        }
        
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [_statsTableView indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"PassingStatSegue"]) {
        EazesportzFootballPassingTotalsViewController *destController = segue.destinationViewController;
        athlete = destController.player = [qbs objectAtIndex:indexPath.row];
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"RushingStatSegue"]) {
        EazesportzFootballRushingTotalsViewController *destController = segue.destinationViewController;
        destController.player = [rbs objectAtIndex:indexPath.row];
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"DefenseStatSegue"]) {
        EazesportzFootballDefenseTotalsViewController *destController = segue.destinationViewController;
        destController.player = [defenselist objectAtIndex:indexPath.row];
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"PlaceKickerStatSegue"]) {
        EazesportzFootballPlaceKickerTotalsViewController *destController = segue.destinationViewController;
        destController.player = [pks objectAtIndex:indexPath.row];
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"KickerStatSegue"]) {
        EazesportzFootballKickerTotalsViewController *destController = segue.destinationViewController;
        destController.player = [kickerlist objectAtIndex:indexPath.row];
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"PunterStatSegue"]) {
        EazesportzFootballPunterTotalsViewController *destController = segue.destinationViewController;
        destController.player = [punterlist objectAtIndex:indexPath.row];
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"ReturnerStatSegue"]) {
        EazesportzFootballReturnerTotalsViewController *destController = segue.destinationViewController;
        destController.player = [returnerlist objectAtIndex:indexPath.row];
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"TotalsReceivingSegue"]) {
        EazesportzFootballReceivingTotalsViewController *destController = segue.destinationViewController;
        destController.player = [wrs objectAtIndex:indexPath.row];
        destController.game = game;
    }
}


- (IBAction)specialteamsButtonClicked:(id)sender {
    offense = NO;
    defense = NO;
    specialteams = YES;
    [self viewWillAppear:YES];
}

- (IBAction)defenseButtonClicked:(id)sender {
    offense = NO;
    defense = YES;
    specialteams = NO;
    [self viewWillAppear:YES];
}

- (IBAction)offenseButtonClicked:(id)sender {
    offense = YES;
    defense = NO;
    specialteams = NO;
    [self viewWillAppear:YES];
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
