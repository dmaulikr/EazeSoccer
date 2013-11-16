//
//  EazeSoccerStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 11/12/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazeSoccerStatsViewController.h"
#import "SoccerPlayerStatsTableCell.h"
#import "EazesportzAppDelegate.h"
#import "EazeSoccerPlayerStatsViewController.h"

@interface EazeSoccerStatsViewController ()

@end

@implementation EazeSoccerStatsViewController

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SoccerStatsTableCell";
    SoccerPlayerStatsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[SoccerPlayerStatsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Soccer *stats;
    
    if (indexPath.section == 0) {
        
        if (self.game) {
            Athlete *player = [currentSettings.roster objectAtIndex:indexPath.row];
            cell.playerName.text = player.logname;
            stats = [player findSoccerGameStats:self.game.id];
        } else if (self.athlete) {
            GameSchedule *agame = [currentSettings.gameList objectAtIndex:indexPath.row];
            cell.playerName.text = agame.opponent;
            stats = [self.athlete findSoccerGameStats:agame.id];
        } else {
            Athlete *player = [currentSettings.roster objectAtIndex:indexPath.row];
            cell.playerName.text = player.logname;
            stats = [[Soccer alloc] init];
        }
        
        cell.label1.text = [stats.goals stringValue];
        cell.label2.text = [stats.shotstaken stringValue];
        cell.label3.text = [stats.assists stringValue];
        cell.label4.text = [stats.steals stringValue];
        cell.label5.text = [stats.cornerkicks stringValue];
        cell.label6.text = [NSString stringWithFormat:@"%d", ([stats.goals intValue] * 2) + [stats.assists intValue]];
    } else {
        if (self.game) {
            Athlete *player = [self.goalies objectAtIndex:indexPath.row];
            cell.playerName.text = player.logname;
            stats = [player findSoccerGameStats:self.game.id];
        } else {
            GameSchedule *agame = [currentSettings.gameList objectAtIndex:indexPath.row];
            cell.playerName.text = agame.opponent;
            stats = [self.athlete findSoccerGameStats:agame.id];
        }
        
        cell.label1.text = [stats.goalssaved stringValue];
        cell.label2.text = [stats.goalsagainst stringValue];
        cell.label3.text = @"";
        cell.label4.text = [stats.minutesplayed stringValue];
        cell.label5.text = @"";
        cell.label6.text = @"";
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.game)
            return @"Player       G     Sht     Ast    Stl    C/K      Pts";
        else
            return @"Game        G     Sht     Ast    Stl    C/K      Pts";
    } else {
        if (self.game)
            return @"Goalie     Save   GA         Minutes";
        else
            return @"Game       Save   GA         Minutes";
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (IBAction)refreshBurronClicked:(id)sender {
    [currentSettings retrievePlayers];
    
    if (self.athlete)
        self.athlete = [currentSettings findAthlete:self.athlete.athleteid];
    else
        self.game = [currentSettings findGame:self.game.id];
    
    [self.soccerPlayerStatsTableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.soccerPlayerStatsTableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"PlayerStatsSegue"]) {
        EazeSoccerPlayerStatsViewController *destController = segue.destinationViewController;
        
        if (self.game) {
            if (indexPath.section == 0)
                destController.player = [currentSettings.roster objectAtIndex:indexPath.row];
            else
                destController.player = [self.goalies objectAtIndex:indexPath.row];
            
            destController.game = self.game;
        } else {
            destController.game = [currentSettings.gameList objectAtIndex:indexPath.row];            
            destController.player = self.athlete;
        }
    }
}

@end
