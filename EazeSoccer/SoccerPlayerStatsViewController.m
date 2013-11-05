//
//  SoccerPlayerStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 11/4/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "SoccerPlayerStatsViewController.h"
#import "EazesportzAppDelegate.h"
#import "SoccerPlayerStasTableCell.h"
#import "LiveSoccerStatsViewController.h"

@interface SoccerPlayerStatsViewController ()

@end

@implementation SoccerPlayerStatsViewController {
    NSMutableArray *goalies;
    
    LiveSoccerStatsViewController *liveStatsController;
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
    
    if ((game) || (athlete)) {
        [_soccerPlayerStatsTableView reloadData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select Game"  message:@"Select game to record stats!"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
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
                Soccer *stats = [aplayer findSoccerGameStats:game.id];
                if ([stats goalieStats]) {
                    [goalies addObject:aplayer];
                }
            }
            return goalies.count;
        }
    } else if (athlete) {
        if (section == 0)
            return currentSettings.gameList.count;
        else {
            return currentSettings.gameList.count;
        }
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SoccerStatsTableCell";
    SoccerPlayerStasTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[SoccerPlayerStasTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        Soccer *stats;
        
        if (game) {
            Athlete *player = [currentSettings.roster objectAtIndex:indexPath.row];
            cell.playerName.text = player.logname;
            stats = [player findSoccerGameStats:game.id];
            cell.imageView.image = [player getImage:@"tiny"];
        } else {
            GameSchedule *agame = [currentSettings.gameList objectAtIndex:indexPath.row];
            cell.playerName.text = agame.opponent;
            stats = [athlete findSoccerGameStats:agame.id];
            
            if ([agame.opponentpic isEqualToString:@"/opponentpics/tiny/missing.png"]) {
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
        cell.label5.text = [NSString stringWithFormat:@"%d", ([stats.goals intValue] * 2) + [stats.assists intValue]];
    } else {
        Athlete *player = [goalies objectAtIndex:indexPath.row];
        cell.playerName.text = player.logname;
        cell.imageView.image = [player getImage:@"tiny"];
        Soccer *stats = [player findSoccerGameStats:game.id];
        cell.label1.text = [stats.goalssaved stringValue];
        cell.label2.text = [stats.goalsagainst stringValue];
        cell.label3.text = @"";
        cell.label4.text = [stats.minutesplayed stringValue];
        cell.label5.text = @"";
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"               Player                   Goals    Shots    Assists   Steals   Points";
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
            liveStatsController.game = [goalies objectAtIndex:indexPath.row];
        
        liveStatsController.player = athlete;
    }
    [liveStatsController viewWillAppear:YES];
    _soccerStatsContainer.hidden = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayerStatsSegue"]) {
        liveStatsController = segue.destinationViewController;
    } else {
        NSIndexPath *indexPath = [_soccerPlayerStatsTableView indexPathForSelectedRow];
        
        if (indexPath.section == 0) {
            
        } else {
            
        }
    }
}

- (IBAction)liveSoccerPlayerStats:(UIStoryboardSegue *)segue {
    [liveStatsController.player updateSoccerGameStats:liveStatsController.playerStats Game:liveStatsController.game.id];
    _soccerStatsContainer.hidden = YES;
}

@end
