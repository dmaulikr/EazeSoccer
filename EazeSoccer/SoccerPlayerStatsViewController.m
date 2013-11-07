//
//  SoccerPlayerStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 11/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "SoccerPlayerStatsViewController.h"
#import "EazesportzAppDelegate.h"
#import "SoccerPlayerStatsTableCell.h"
#import "LiveSoccerStatsViewController.h"
#import "UpdateSoccerTotalsViewController.h"

@interface SoccerPlayerStatsViewController ()

@end

@implementation SoccerPlayerStatsViewController {
    NSMutableArray *goalies;
    
    LiveSoccerStatsViewController *liveStatsController;
    UpdateSoccerTotalsViewController *totalStatsController;
}

@synthesize game;
@synthesize athlete;

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _soccerStatsContainer.hidden = YES;
    _totalStatsContainer.hidden = YES;
    
    if ((game) || (athlete)) {
        [_soccerPlayerStatsTableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (game)
        return 2;
    else if (athlete) {
        if ([athlete isSoccerGoalie])
            return 2;
        else
            return 1;
    } else
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (game) {
        if (section == 0)
            return currentSettings.roster.count;
        else {
           goalies = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < currentSettings.roster.count; i++) {
                Athlete *aplayer = [currentSettings.roster objectAtIndex:i];
                if ([aplayer isSoccerGoalie]) {
                    [goalies addObject:aplayer];
                }
            }
            return goalies.count;
        }
    } else if (athlete) {
        if (section == 0)
            return currentSettings.gameList.count;
        else if ([athlete isSoccerGoalie]) {
            return currentSettings.gameList.count;
        } else {
            return 0;
        }
    } else {
        return 0;
    }
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
        
        if (game) {
            Athlete *player = [currentSettings.roster objectAtIndex:indexPath.row];
            cell.playerName.text = player.logname;
            stats = [player findSoccerGameStats:game.id];
            cell.imageView.image = [player getImage:@"tiny"];
        } else {
            GameSchedule *agame = [currentSettings.gameList objectAtIndex:indexPath.row];
            cell.playerName.text = agame.opponent;
            stats = [athlete findSoccerGameStats:agame.id];
            
            if ([agame.opponentpic isEqualToString:@"/opponentpics/original/missing.png"]) {
                cell.imageView.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
            } else {
                NSURL * imageURL = [NSURL URLWithString:game.opponentpic];
                NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
                cell.imageView.image = [UIImage imageWithData:imageData];
            }
        }
        
        cell.label1.text = [stats.goals stringValue];
        cell.label2.text = [stats.shotstaken stringValue];
        cell.label3.text = [stats.assists stringValue];
        cell.label4.text = [stats.steals stringValue];
        cell.label5.text = [stats.cornerkicks stringValue];
        cell.label6.text = [NSString stringWithFormat:@"%d", ([stats.goals intValue] * 2) + [stats.assists intValue]];
    } else {
        if (game) {
            Athlete *player = [goalies objectAtIndex:indexPath.row];
            cell.playerName.text = player.logname;
            stats = [player findSoccerGameStats:game.id];
            cell.imageView.image = [player getImage:@"tiny"];
        } else {
            GameSchedule *agame = [currentSettings.gameList objectAtIndex:indexPath.row];
            cell.playerName.text = agame.opponent;
            stats = [athlete findSoccerGameStats:agame.id];
            
            if ([agame.opponentpic isEqualToString:@"/opponentpics/original/missing.png"]) {
                cell.imageView.image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
            } else {
                NSURL * imageURL = [NSURL URLWithString:agame.opponentpic];
                NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
                cell.imageView.image = [UIImage imageWithData:imageData];
            }
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
    if (section == 0)
        return @"               Player                   Goals    Shots    Assists   Steals   C/K      Points";
    else
        return @"               Goalie                   Saves    Goals Against      Minutes";
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (game) {
        if (indexPath.section == 0)
            liveStatsController.player = [currentSettings.roster objectAtIndex:indexPath.row];
        else
            liveStatsController.player = [goalies objectAtIndex:indexPath.row];
        
        liveStatsController.game = game;
    } else {
        if (indexPath.section == 0)
            liveStatsController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
        else
            liveStatsController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
        
        liveStatsController.player = athlete;
    }
    
    [liveStatsController viewWillAppear:YES];
    _soccerStatsContainer.hidden = NO;
/*    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"  message:@"Update Stats by selecting Live Stats on Menu below!"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } */
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 0) {
            totalStatsController.soccerstats = [[currentSettings.roster objectAtIndex:indexPath.row] findSoccerGameStats:game.id];
            totalStatsController.player = [currentSettings.roster objectAtIndex:indexPath.row];
        } else {
            totalStatsController.soccerstats = [[goalies objectAtIndex:indexPath.row] findSoccerGameStats:game.id];
            totalStatsController.player = [goalies objectAtIndex:indexPath.row];
        }
        [totalStatsController viewWillAppear:YES];
        _totalStatsContainer.hidden = NO;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Enter Totals";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SoccerPlayerStatsSegue"]) {
        liveStatsController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"SoccerStatTotalsSegue"]) {
        totalStatsController = segue.destinationViewController;
    } else {
        NSIndexPath *indexPath = [_soccerPlayerStatsTableView indexPathForSelectedRow];
        
        if (indexPath.section == 0) {
            
        } else {
            
        }
    }
}

- (IBAction)liveSoccerPlayerStats:(UIStoryboardSegue *)segue {
    [liveStatsController.player updateSoccerGameStats:liveStatsController.playerStats Game:liveStatsController.playerStats.gameschedule_id];
    _soccerStatsContainer.hidden = YES;
    [_soccerPlayerStatsTableView reloadData];
}

- (IBAction)updateTotalSoccerStats:(UIStoryboardSegue *)segue {
    [totalStatsController.player updateSoccerGameStats:totalStatsController.soccerstats Game:totalStatsController.soccerstats.gameschedule_id];
    _totalStatsContainer.hidden = YES;
    [_soccerPlayerStatsTableView reloadData];
}

- (IBAction)saveButtonClicked:(id)sender {
    if (game) {
        for (int cnt = 0; cnt < currentSettings.roster.count; cnt++) {
            if (![[currentSettings.roster objectAtIndex:cnt] saveSoccerGameStats:game.id]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[NSString stringWithFormat:@"%@%@", @"Update failed for  ", [[currentSettings.roster objectAtIndex:cnt] logname]]
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
                return;
            }
        }
    } else {
        for (int i = 0; i < currentSettings.gameList.count; i++) {
            if (![athlete saveSoccerGameStats:[[currentSettings.gameList objectAtIndex:i] id]]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[NSString stringWithFormat:@"%@%@", @"Update failed for  ", [athlete logname]]
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
                return;
            }
        }
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Stats Posted!"
                                                    message:[NSString stringWithFormat:@"%@%@%@", @"Stats for current players vs. ", game.opponent, @" saved!"]
                                                   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

@end
