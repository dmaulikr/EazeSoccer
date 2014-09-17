//
//  EazeFootballPlayerStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 1/21/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazeFootballPlayerStatsViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzStatTableHeaderCell.h"

#import "EazesportzFootballPassingTotalsViewController.h"
#import "EazesportzFootballRushingTotalsViewController.h"
#import "EazesportzFootballReceivingTotalsViewController.h"
#import "EazesportzFootballDefenseTotalsViewController.h"
#import "EazesportzFootballPlaceKickerTotalsViewController.h"
#import "EazesportzFootballPunterTotalsViewController.h"
#import "EazesportzFootballReturnerTotalsViewController.h"
#import "EazesportzFootballKickerTotalsViewController.h"
#import "EazesportzDisplayAdBannerViewController.h"

@interface EazeFootballPlayerStatsViewController ()

@end

@implementation EazeFootballPlayerStatsViewController {
    NSString *visiblestats;
    EazesportzDisplayAdBannerViewController *adBannerController;
}

@synthesize player;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = player.full_name;
    
    if ([player isQB:nil])
        visiblestats = @"Pass";
    else if ([player isRB:nil])
        visiblestats = @"Rush";
    else if ([player isWR:nil])
        visiblestats = @"Rec";
    else if ([player isDEF:nil])
        visiblestats = @"Def";
    else if (([player isKicker:nil]) || ([player isPK:nil]) || ([player isPunter:nil]))
        visiblestats = @"Kick";
    else if ([player isReturner:nil])
        visiblestats = @"Ret";
    else
        visiblestats = @"Rush";

    [_playerStatTableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ([visiblestats isEqualToString:@"Kick"])
        return 4;
    else
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return currentSettings.gameList.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([visiblestats isEqualToString:@"Pass"]) {
        EazesportzStatTableHeaderCell *cell = [[EazesportzStatTableHeaderCell alloc] init];
        static NSString *CellIdentifier = @"StatTableCell";
        
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        if (cell == nil) {
            cell = [[EazesportzStatTableHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        FootballPassingStat *stat;
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        if (indexPath.row < currentSettings.gameList.count) {
            stat = [player findFootballPassingStat:[[currentSettings.gameList objectAtIndex:indexPath.row] id]];
            cell.playerLabel.text = [[currentSettings.gameList objectAtIndex:indexPath.row] opponent_mascot];
        } else {
            stat = [[FootballPassingStat alloc] init];
            cell.playerLabel.text = @"Totals";
            
            for (int cnt = 0; cnt < currentSettings.gameList.count; cnt++) {
                FootballPassingStat *astat = [player findFootballPassingStat:[[currentSettings.gameList objectAtIndex:cnt] id]];
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
        
        if (indexPath.section == 0) {
            cell.label1.text = @"";
            cell.label2.text = [stat.completions stringValue];
            cell.label3.text = [stat.attempts stringValue];
        
            if ([stat.attempts intValue] > 0)
                cell.label4.text = [NSString stringWithFormat:@"%.02f", [stat.completions floatValue]/[stat.attempts floatValue]];
            else
                cell.label4.text = @"0.0";
            
            cell.label5.text = [stat.yards stringValue];
            cell.label6.text = [stat.td stringValue];
        } else {
            cell.label1.text = @"";
            cell.label2.text = [stat.firstdowns stringValue];
            cell.label3.text = [stat.interceptions stringValue];
            cell.label4.text = [stat.sacks stringValue];
            cell.label5.text = [stat.yards_lost stringValue];
            cell.label6.text = [stat.twopointconv stringValue];
        }
        
        return cell;
    } else if ([visiblestats isEqualToString:@"Rush"]) {
        EazesportzStatTableHeaderCell *cell = [[EazesportzStatTableHeaderCell alloc] init];
        static NSString *CellIdentifier = @"StatTableCell";
        
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        if (cell == nil) {
            cell = [[EazesportzStatTableHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        FootballRushingStat *stat;
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        if (indexPath.row < currentSettings.gameList.count) {
            stat = [player findFootballRushingStat:[[currentSettings.gameList objectAtIndex:indexPath.row] id]];
            cell.playerLabel.text = [[currentSettings.gameList objectAtIndex:indexPath.row] opponent_mascot];
        } else {
            stat = [[FootballRushingStat alloc] init];
            cell.playerLabel.text = @"Totals";
            
            for (int cnt = 0; cnt < currentSettings.gameList.count; cnt++) {
                FootballRushingStat *astat = [player findFootballRushingStat:[[currentSettings.gameList objectAtIndex:cnt] id]];
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
        
        if (indexPath.section == 0) {
            cell.label1.text = @"";
            cell.label2.text = [stat.attempts stringValue];
            cell.label3.text = [stat.yards stringValue];
            cell.label4.text = [NSString stringWithFormat:@"%.02f", [stat.average floatValue]];
            cell.label5.text = [stat.longest stringValue];
            cell.label6.text = [stat.td stringValue];
        } else {
            cell.label1.text = @"";
            cell.label2.text = @"";
            cell.label3.text = [stat.firstdowns stringValue];
            cell.label4.text = [stat.fumbles stringValue];
            cell.label5.text = [stat.fumbles_lost stringValue];
            cell.label6.text = [stat.twopointconv stringValue];
        }
    
        return cell;
    } else if ([visiblestats isEqualToString:@"Rec"]) {
        EazesportzStatTableHeaderCell *cell = [[EazesportzStatTableHeaderCell alloc] init];
        static NSString *CellIdentifier = @"StatTableCell";
        
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        if (cell == nil) {
            cell = [[EazesportzStatTableHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        FootballReceivingStat *stat;
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        if (indexPath.row < currentSettings.gameList.count) {
            stat = [player findFootballReceivingStat:[[currentSettings.gameList objectAtIndex:indexPath.row] id]];
            cell.playerLabel.text = [[currentSettings.gameList objectAtIndex:indexPath.row] opponent_mascot];
        } else {
            stat = [[FootballReceivingStat alloc] init];
            cell.playerLabel.text = @"Totals";

            for (int cnt = 0; cnt < currentSettings.gameList.count; cnt++) {
                FootballReceivingStat *astat = [player findFootballReceivingStat:[[currentSettings.gameList objectAtIndex:cnt] id]];
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
        
        if (indexPath.section == 0) {
            cell.label1.text = @"";
            cell.label2.text = [stat.receptions stringValue];
            cell.label3.text = [stat.yards stringValue];
            cell.label4.text = [NSString stringWithFormat:@"%.02f", [stat.average floatValue]];
            cell.label5.text = [stat.longest stringValue];
            cell.label6.text = [stat.td stringValue];
        } else {
            cell.label1.text = @"";
            cell.label2.text = @"";
            cell.label3.text = [stat.firstdowns stringValue];
            cell.label4.text = [stat.fumbles stringValue];
            cell.label5.text = [stat.fumbles_lost stringValue];
            cell.label6.text = [stat.twopointconv stringValue];
        }
 
        return cell;
    } else if ([visiblestats isEqualToString:@"Def"]) {
        EazesportzStatTableHeaderCell *cell = [[EazesportzStatTableHeaderCell alloc] init];
        static NSString *CellIdentifier = @"StatTableCell";
        
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        if (cell == nil) {
            cell = [[EazesportzStatTableHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        FootballDefenseStats *stat;
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        if (indexPath.row < currentSettings.gameList.count) {
            stat = [player findFootballDefenseStat:[[currentSettings.gameList objectAtIndex:indexPath.row] id]];
            cell.playerLabel.text = [[currentSettings.gameList objectAtIndex:indexPath.row] opponent_mascot];
        } else {
            stat = [[FootballDefenseStats alloc] init];
            cell.playerLabel.text = @"Totals";
            
            for (int cnt = 0; cnt < currentSettings.gameList.count; cnt++) {
                FootballDefenseStats *astat = [player findFootballDefenseStat:[[currentSettings.gameList objectAtIndex:cnt] id]];
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
        
        if (indexPath.section == 0) {
            cell.label1.text = [stat.tackles stringValue];
            cell.label2.text = [stat.assists stringValue];
            
            if ([stat.assists intValue] > 0)
                cell.label3.text = [NSString stringWithFormat:@"%01f", ([stat.tackles floatValue] + ([stat.assists floatValue]/2))];
            else
                cell.label3.text = [stat.tackles stringValue];
            
            cell.label4.text = [stat.sacks stringValue];
            cell.label5.text = [stat.sackassist stringValue];
            
            if ([stat.sackassist intValue] > 0)
                cell.label6.text = [NSString stringWithFormat:@"%.01f", ([stat.sacks floatValue] + ([stat.sackassist floatValue]/2))];
            else
                cell.label6.text = [stat.sacks stringValue];
        } else {
            cell.label1.text = [stat.interceptions stringValue];
            cell.label2.text = [stat.pass_defended stringValue];
            cell.label3.text = [stat.int_yards stringValue];
            cell.label4.text = [stat.fumbles_recovered stringValue];
            cell.label5.text = [stat.td stringValue];
            cell.label6.text = [stat.safety stringValue];
        }
        
        return cell;
    } else if ([visiblestats isEqualToString:@"Kick"]) {
        EazesportzStatTableHeaderCell *cell = [[EazesportzStatTableHeaderCell alloc] init];
        static NSString *CellIdentifier = @"StatTableCell";
        
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        if (cell == nil) {
            cell = [[EazesportzStatTableHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        if ((indexPath.section == 0) || (indexPath.section == 1)) {
            FootballPlaceKickerStats *stat;
            
            if (indexPath.row < currentSettings.gameList.count) {
                stat = [player findFootballPlaceKickerStat:[[currentSettings.gameList objectAtIndex:indexPath.row] id]];
                cell.playerLabel.text = [[currentSettings.gameList objectAtIndex:indexPath.row] opponent_mascot];
            } else {
                stat = [[FootballPlaceKickerStats alloc] init];
                cell.playerLabel.text = @"Totals";
                
                for (int cnt = 0; cnt < currentSettings.gameList.count; cnt++) {
                    FootballPlaceKickerStats *astat = [player findFootballPlaceKickerStat:[[currentSettings.gameList objectAtIndex:cnt] id]];
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
            
            if (indexPath.section == 0) {
                cell.label1.text = @"";
                cell.label2.text = [stat.fgattempts stringValue];
                cell.label3.text = [stat.fgmade stringValue];
                cell.label4.text = [stat.fgblocked stringValue];
                cell.label5.text = [stat.fglong stringValue];
                cell.label6.text = [NSString stringWithFormat:@"%d", ([stat.fgmade intValue] * 3)];
            } else if (indexPath.section == 1) {
                cell.label1.text = @"";
                cell.label2.text = [stat.xpattempts stringValue];
                cell.label3.text = [stat.xpmade stringValue];
                cell.label4.text = [stat.xpmissed stringValue];
                cell.label5.text = [stat.xpblocked stringValue];
                cell.label6.text = [NSString stringWithFormat:@"%d", [stat.xpmade intValue]];
            }
        } else if (indexPath.section == 3) {
            FootballPunterStats *stat;
            
            if (indexPath.row < currentSettings.gameList.count) {
                stat = [player findFootballPunterStat:[[currentSettings.gameList objectAtIndex:indexPath.row] id]];
                cell.playerLabel.text = [[currentSettings.gameList objectAtIndex:indexPath.row] opponent_mascot];
            } else {
                stat = [[FootballPunterStats alloc] init];
                cell.playerLabel.text = @"Totals";
            }
            
            for (int cnt = 0; cnt < currentSettings.gameList.count; cnt++) {
                FootballPunterStats *astat = [player findFootballPunterStat:[[currentSettings.gameList objectAtIndex:cnt] id]];
                stat.punts = [NSNumber numberWithInt:[stat.punts intValue] + [astat.punts intValue]];
                stat.punts_blocked = [NSNumber numberWithInt:[stat.punts_blocked intValue] + [astat.punts_blocked intValue]];
                stat.punts_yards = [NSNumber numberWithInt:[stat.punts_yards intValue] + [astat.punts_yards intValue]];
                
                if ([stat.punts_long intValue] < [astat.punts_long intValue]) {
                    stat.punts_long = astat.punts_long;
                }
            }
            
            cell.label1.text = @"";
            cell.label2.text = [stat.punts stringValue];
            cell.label3.text = [stat.punts_blocked stringValue];
            cell.label4.text = [stat.punts_yards stringValue];
            cell.label5.text =  [stat.punts_long stringValue];
            
            if ([stat.punts intValue] > 0)
                cell.label6.text = [[NSNumber numberWithFloat:([stat.punts_yards floatValue]/[stat.punts floatValue])] stringValue];
            else
                cell.label6.text = @"0.0";
         } else if (indexPath.section == 2) {
            FootballKickerStats *stat;
            
            if (indexPath.row < currentSettings.gameList.count) {
                stat = [player findFootballKickerStat:[[currentSettings.gameList objectAtIndex:indexPath.row] id]];
                cell.playerLabel.text = [[currentSettings.gameList objectAtIndex:indexPath.row] opponent_mascot];
            } else {
                stat = [[FootballKickerStats alloc] init];
                cell.playerLabel.text = @"Totals";
                
                for (int cnt = 0; cnt < currentSettings.gameList.count; cnt++) {
                    FootballKickerStats *astat = [player findFootballKickerStat:[[currentSettings.gameList objectAtIndex:cnt] id]];
                    stat.koattempts = [NSNumber numberWithInt:[stat.koattempts intValue] + [astat.koattempts intValue]];
                    stat.koreturned = [NSNumber numberWithInt:[stat.koreturned intValue] + [astat.koreturned intValue]];
                    stat.kotouchbacks = [NSNumber numberWithInt:[stat.kotouchbacks intValue] + [astat.kotouchbacks intValue]];
                }
             }
             
            cell.label1.text = @"";
            cell.label2.text = @"";
            cell.label3.text = @"";
            cell.label4.text = [stat.koattempts stringValue];
            cell.label5.text = [stat.koreturned stringValue];
            cell.label6.text = [stat.kotouchbacks stringValue];
        }
        
        return cell;
    } else if ([visiblestats isEqualToString:@"Ret"]) {
        EazesportzStatTableHeaderCell *cell = [[EazesportzStatTableHeaderCell alloc] init];
        static NSString *CellIdentifier = @"StatTableCell";
        
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        if (cell == nil) {
            cell = [[EazesportzStatTableHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        FootballReturnerStats *stat;
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        if (indexPath.row < currentSettings.gameList.count) {
            stat = [player findFootballReturnerStat:[[currentSettings.gameList objectAtIndex:indexPath.row] id]];
            cell.playerLabel.text = [[currentSettings.gameList objectAtIndex:indexPath.row] opponent_mascot];
        } else {
            stat = [[FootballReturnerStats alloc] init];
            cell.playerLabel.text = @"Totals";

            for (int cnt = 0; cnt < currentSettings.gameList.count; cnt++) {
                FootballReturnerStats *astat = [player findFootballReturnerStat:[[currentSettings.gameList objectAtIndex:cnt] id]];
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
        }
        
        if (indexPath.section == 0) {
            cell.label1.text = @"";
            cell.label2.text = [stat.punt_return stringValue];
            cell.label3.text = [stat.punt_returnyards stringValue];
            
            if ([stat.punt_return intValue] > 0)
                cell.label4.text = [[NSNumber numberWithFloat:([stat.punt_returnyards floatValue]/[stat.punt_return floatValue])] stringValue];
            else
                cell.label4.text = @"0.0";
            
            cell.label5.text =  [stat.punt_returnlong stringValue];
            cell.label6.text = [stat.punt_returntd stringValue];
        } else {
            cell.label1.text = @"";
            cell.label2.text =  [stat.koreturn stringValue];
            cell.label3.text =  [stat.koyards stringValue];
            
            if ([stat.koreturn intValue] > 0)
                cell.label4.text = [[NSNumber numberWithFloat:([stat.koyards floatValue]/[stat.koreturn floatValue])] stringValue];
            else
                cell.label4.text = @"0.0";
            
            cell.label5.text = [stat.kolong stringValue];
            cell.label6.text = [stat.kotd stringValue];
        }
        
        return cell;
    } else {
        UITableViewCell *cell;
        
        return cell;
    }
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([currentSettings isSiteOwner]) {
        if (indexPath.row < currentSettings.gameList.count) {
            if ([visiblestats isEqualToString:@"Pass"])
                [self performSegueWithIdentifier:@"PassingTotalsSegue" sender:self];
            else if ([visiblestats isEqualToString:@"Rush"])
                [self performSegueWithIdentifier:@"RushingTotalsSegue" sender:self];
            else if ([visiblestats isEqualToString:@"Rec"])
                [self performSegueWithIdentifier:@"ReceivingTotalsSegue" sender:self];
            else if ([visiblestats isEqualToString:@"Def"])
                [self performSegueWithIdentifier:@"DefensiveTotalsSegue" sender:self];
            else if ([visiblestats isEqualToString:@"Kick"]) {
                switch (indexPath.section) {
                    case 0:
                        [self performSegueWithIdentifier:@"PlaceKickerTotalsSegue" sender:self];
                        break;
                        
                    case 1:
                        [self performSegueWithIdentifier:@"PlaceKickerTotalsSegue" sender:self];
                        break;
                        
                    case 2:
                        [self performSegueWithIdentifier:@"KickerTotalsSegue" sender:self];
                        break;
                        
                    default:
                        [self performSegueWithIdentifier:@"PunterTotalsSegue" sender:self];
                        break;
                }
            } else if ([visiblestats isEqualToString:@"Ret"])
                [self performSegueWithIdentifier:@"ReturnerTotalsSegue" sender:self];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *headerView;
    
    if ([visiblestats isEqualToString:@"Pass"]) {
        static NSString *CellIdentifier = @"StatTableHeaderCell";
        
        if (section == 0) {
            headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            headerView.backgroundColor = [UIColor blueColor];
            UILabel *label = (UILabel *)[headerView viewWithTag:1];
            label.text = @"";
            label = (UILabel *)[headerView viewWithTag:2];
            label.text = @"CMP";
            label = (UILabel *)[headerView viewWithTag:3];
            label.text = @"ATT";
            label = (UILabel *)[headerView viewWithTag:4];
            label.text = @"PCT";
            label = (UILabel *)[headerView viewWithTag:5];
            label.text = @"YDS";
            label = (UILabel *)[headerView viewWithTag:6];
            label.text = @"TD";
            label = (UILabel *)[headerView viewWithTag:9];
            label.text = @"Game";
        } else {
            headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            headerView.backgroundColor = [UIColor blueColor];
            UILabel *label = (UILabel *)[headerView viewWithTag:1];
            label.text = @"";
            label = (UILabel *)[headerView viewWithTag:2];
            label.text = @"FD";
            label = (UILabel *)[headerView viewWithTag:3];
            label.text = @"INT";
            label = (UILabel *)[headerView viewWithTag:4];
            label.text = @"SCK";
            label = (UILabel *)[headerView viewWithTag:5];
            label.text = @"YDL";
            label = (UILabel *)[headerView viewWithTag:6];
            label.text = @"2PT";
            label = (UILabel *)[headerView viewWithTag:9];
            label.text = @"Game";
        }
        
    } else if ([visiblestats isEqualToString:@"Rush"]) {
        static NSString *CellIdentifier = @"StatTableHeaderCell";
        
        if (section == 0) {
            headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            headerView.backgroundColor = [UIColor blueColor];
            UILabel *label = (UILabel *)[headerView viewWithTag:1];
            label.text = @"";
            label = (UILabel *)[headerView viewWithTag:2];
            label.text = @"ATT";
            label = (UILabel *)[headerView viewWithTag:3];
            label.text = @"YDS";
            label = (UILabel *)[headerView viewWithTag:4];
            label.text = @"AVG";
            label = (UILabel *)[headerView viewWithTag:5];
            label.text = @"LNG";
            label = (UILabel *)[headerView viewWithTag:6];
            label.text = @"TD";
            label = (UILabel *)[headerView viewWithTag:9];
            label.text = @"Game";
        } else {
            headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            headerView.backgroundColor = [UIColor blueColor];
            UILabel *label = (UILabel *)[headerView viewWithTag:1];
            label.text = @"";
            label = (UILabel *)[headerView viewWithTag:2];
            label.text = @"";
            label = (UILabel *)[headerView viewWithTag:3];
            label.text = @"FD";
            label = (UILabel *)[headerView viewWithTag:4];
            label.text = @"FUM";
            label = (UILabel *)[headerView viewWithTag:5];
            label.text = @"LST";
            label = (UILabel *)[headerView viewWithTag:6];
            label.text = @"2PT";
            label = (UILabel *)[headerView viewWithTag:9];
            label.text = @"Game";
        }
        
    } else if ([visiblestats isEqualToString:@"Rec"]) {
        static NSString *CellIdentifier = @"StatTableHeaderCell";
        
        if (section == 0) {
            headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            headerView.backgroundColor = [UIColor blueColor];
            UILabel *label = (UILabel *)[headerView viewWithTag:1];
            label.text = @"";
            label = (UILabel *)[headerView viewWithTag:2];
            label.text = @"REC";
            label = (UILabel *)[headerView viewWithTag:3];
            label.text = @"YDS";
            label = (UILabel *)[headerView viewWithTag:4];
            label.text = @"AVG";
            label = (UILabel *)[headerView viewWithTag:5];
            label.text = @"LNG";
            label = (UILabel *)[headerView viewWithTag:6];
            label.text = @"TD";
            label = (UILabel *)[headerView viewWithTag:9];
            label.text = @"Game";
        } else {
            headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            headerView.backgroundColor = [UIColor blueColor];
            UILabel *label = (UILabel *)[headerView viewWithTag:1];
            label.text = @"";
            label = (UILabel *)[headerView viewWithTag:2];
            label.text = @"";
            label = (UILabel *)[headerView viewWithTag:3];
            label.text = @"FD";
            label = (UILabel *)[headerView viewWithTag:4];
            label.text = @"FUM";
            label = (UILabel *)[headerView viewWithTag:5];
            label.text = @"LST";
            label = (UILabel *)[headerView viewWithTag:6];
            label.text = @"2PT";
            label = (UILabel *)[headerView viewWithTag:9];
            label.text = @"Game";
        }
        
    } else if ([visiblestats isEqualToString:@"Def"]) {
        static NSString *CellIdentifier = @"StatTableHeaderCell";
        
        if (section == 0) {
            headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            headerView.backgroundColor = [UIColor blueColor];
            UILabel *label = (UILabel *)[headerView viewWithTag:1];
            label.text = @"TKL";
            label = (UILabel *)[headerView viewWithTag:2];
            label.text = @"AST";
            label = (UILabel *)[headerView viewWithTag:3];
            label.text = @"TOT";
            label = (UILabel *)[headerView viewWithTag:4];
            label.text = @"SAK";
            label = (UILabel *)[headerView viewWithTag:5];
            label.text = @"AST";
            label = (UILabel *)[headerView viewWithTag:6];
            label.text = @"TOT";
            label = (UILabel *)[headerView viewWithTag:9];
            label.text = @"Game";
        } else {
            headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            headerView.backgroundColor = [UIColor blueColor];
            UILabel *label = (UILabel *)[headerView viewWithTag:1];
            label.text = @"INT";
            label = (UILabel *)[headerView viewWithTag:2];
            label.text = @"PD";
            label = (UILabel *)[headerView viewWithTag:3];
            label.text = @"RYD";
            label = (UILabel *)[headerView viewWithTag:4];
            label.text = @"FRC";
            label = (UILabel *)[headerView viewWithTag:5];
            label.text = @"TD";
            label = (UILabel *)[headerView viewWithTag:6];
            label.text = @"SFY";
            label = (UILabel *)[headerView viewWithTag:9];
            label.text = @"Game";
        }
        
    } else if ([visiblestats isEqualToString:@"Kick"]) {
        static NSString *CellIdentifier = @"StatTableHeaderCell";
        
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        headerView.backgroundColor = [UIColor blueColor];

        if (section == 0) {
            UILabel *label = (UILabel *)[headerView viewWithTag:1];
            label.text = @"";
            label = (UILabel *)[headerView viewWithTag:2];
            label.text = @"FGA";
            label = (UILabel *)[headerView viewWithTag:3];
            label.text = @"FGM";
            label = (UILabel *)[headerView viewWithTag:4];
            label.text = @"BLK";
            label = (UILabel *)[headerView viewWithTag:5];
            label.text = @"LNG";
            label = (UILabel *)[headerView viewWithTag:6];
            label.text = @"PTS";
            label = (UILabel *)[headerView viewWithTag:9];
            label.text = @"Place Kicker";
        } else if (section == 1) {
            UILabel *label = (UILabel *)[headerView viewWithTag:1];
            label.text = @"";
            label = (UILabel *)[headerView viewWithTag:2];
            label.text = @"XPA";
            label = (UILabel *)[headerView viewWithTag:3];
            label.text = @"XPM";
            label = (UILabel *)[headerView viewWithTag:4];
            label.text = @"MIS";
            label = (UILabel *)[headerView viewWithTag:5];
            label.text = @"BLK";
            label = (UILabel *)[headerView viewWithTag:6];
            label.text = @"PTS";
            label = (UILabel *)[headerView viewWithTag:9];
            label.text = @"Place Kicker";
        } else if (section == 3) {
            UILabel *label = (UILabel *)[headerView viewWithTag:1];
            label.text = @"";
            label = (UILabel *)[headerView viewWithTag:2];
            label.text = @"ATT";
            label = (UILabel *)[headerView viewWithTag:3];
            label.text = @"BLK";
            label = (UILabel *)[headerView viewWithTag:4];
            label.text = @"YDS";
            label = (UILabel *)[headerView viewWithTag:5];
            label.text = @"LNG";
            label = (UILabel *)[headerView viewWithTag:6];
            label.text = @"AVG";
            label = (UILabel *)[headerView viewWithTag:9];
            label.text = @"Punter";
        } else {
            UILabel *label = (UILabel *)[headerView viewWithTag:1];
            label.text = @"";
            label = (UILabel *)[headerView viewWithTag:2];
            label.text = @"";
            label = (UILabel *)[headerView viewWithTag:3];
            label.text = @"";
            label = (UILabel *)[headerView viewWithTag:4];
            label.text = @"ATT";
            label = (UILabel *)[headerView viewWithTag:5];
            label.text = @"RET";
            label = (UILabel *)[headerView viewWithTag:6];
            label.text = @"TCB";
            label = (UILabel *)[headerView viewWithTag:9];
            label.text = @"Kicker";
        }
        
    } else if ([visiblestats isEqualToString:@"Ret"]) {
        static NSString *CellIdentifier = @"StatTableHeaderCell";
        
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        headerView.backgroundColor = [UIColor blueColor];

        if (section == 0) {
            UILabel *label = (UILabel *)[headerView viewWithTag:1];
            label.text = @"";
            label = (UILabel *)[headerView viewWithTag:2];
            label.text = @"RET";
            label = (UILabel *)[headerView viewWithTag:3];
            label.text = @"YDS";
            label = (UILabel *)[headerView viewWithTag:4];
            label.text = @"AVG";
            label = (UILabel *)[headerView viewWithTag:5];
            label.text = @"LNG";
            label = (UILabel *)[headerView viewWithTag:6];
            label.text = @"TD";
            label = (UILabel *)[headerView viewWithTag:9];
            label.text = @"Punts";
        } else {
            UILabel *label = (UILabel *)[headerView viewWithTag:1];
            label.text = @"";
            label = (UILabel *)[headerView viewWithTag:2];
            label.text = @"RET";
            label = (UILabel *)[headerView viewWithTag:3];
            label.text = @"YDS";
            label = (UILabel *)[headerView viewWithTag:4];
            label.text = @"AVG";
            label = (UILabel *)[headerView viewWithTag:5];
            label.text = @"LNG";
            label = (UILabel *)[headerView viewWithTag:6];
            label.text = @"TD";
            label = (UILabel *)[headerView viewWithTag:9];
            label.text = @"Kickoffs";
        }
        
    } else {
        static NSString *CellIdentifier = @"TotalsHeaderCell";
        
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        headerView.backgroundColor = [UIColor blueColor];
    }
    
    if (headerView == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"])
        return 30.0;
    else
        return 44.0;
}

- (IBAction)passButtonClicked:(id)sender {
    visiblestats = @"Pass";
    [_playerStatTableView reloadData];
}

- (IBAction)rushButtonClicked:(id)sender {
    visiblestats = @"Rush";
    [_playerStatTableView reloadData];
}

- (IBAction)receiverButtonClicked:(id)sender {
    visiblestats = @"Rec";
    [_playerStatTableView reloadData];
}

- (IBAction)defenseButtonClicked:(id)sender {
    visiblestats = @"Def";
    [_playerStatTableView reloadData];
}

- (IBAction)kickerButtonClicked:(id)sender {
    visiblestats = @"Kick";
    [_playerStatTableView reloadData];
}

- (IBAction)returnerButtonClicked:(id)sender {
    visiblestats = @"Ret";
    [_playerStatTableView reloadData];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (currentSettings.sport.hideAds) {
        _bannerView.hidden = YES;
        _adBannerContainer.hidden = NO;
        [adBannerController displayAd];
    } else {
        _adBannerContainer.hidden = YES;
        _bannerView.hidden = NO;
    }
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    _bannerView.hidden = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [_playerStatTableView indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"PassingTotalsSegue"]) {
        EazesportzFootballPassingTotalsViewController *destController = segue.destinationViewController;
        destController.player = player;
        destController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"RushingTotalsSegue"]) {
        EazesportzFootballPassingTotalsViewController *destController = segue.destinationViewController;
        destController.player = player;
        destController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"ReceivingTotalsSegue"]) {
        EazesportzFootballReceivingTotalsViewController *destController = segue.destinationViewController;
        destController.player = player;
        destController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"DefensiveTotalsSegue"]) {
        EazesportzFootballDefenseTotalsViewController *destController = segue.destinationViewController;
        destController.player = player;
        destController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"PlaceKickerTotalsSegue"]) {
        EazesportzFootballPlaceKickerTotalsViewController *destController = segue.destinationViewController;
        destController.player = player;
        destController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"PunterTotalsSegue"]) {
        EazesportzFootballPunterTotalsViewController *destController = segue.destinationViewController;
        destController.player = player;
        destController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"ReturnerTotalsSegue"]) {
        EazesportzFootballReturnerTotalsViewController *destController = segue.destinationViewController;
        destController.player = player;
        destController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"KickerTotalsSegue"]) {
        EazesportzFootballKickerTotalsViewController *destController = segue.destinationViewController;
        destController.player = player;
        destController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"AdDisplaySegue"]) {
        adBannerController = segue.destinationViewController;
    }
}

- (IBAction)passBarButtonClicked:(id)sender {
    [self passButtonClicked:sender];
}

- (IBAction)rushBarButtonClicked:(id)sender {
    [self rushButtonClicked:sender];
}

- (IBAction)recBarButtonClicked:(id)sender {
    [self receiverButtonClicked:sender];
}

- (IBAction)defBarButtonClicked:(id)sender {
    [self defenseButtonClicked:sender];
}

- (IBAction)retBarButtonClicked:(id)sender {
    [self returnerButtonClicked:sender];
}

- (IBAction)kickBarButtonClicked:(id)sender {
    [self kickerButtonClicked:sender];
}
@end
