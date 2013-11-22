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

@interface EazesportzFootballStatsViewController ()

@end

@implementation EazesportzFootballStatsViewController {
    BOOL offense, defense, specialteams;
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
    offense = NO;
    defense = NO;
    specialteams = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    _basketballLiveStatsContainer.hidden = YES;
//    _basketballTotalStatsContainer.hidden = YES;
    
    if (game)
        _statLabel.text = [NSString stringWithFormat:@"%@%@", @"Stats vs. ", game.opponent_name];
    else if (athlete)
        _statLabel.text = [NSString stringWithFormat:@"%@%@", @"Stats for ", athlete.logname];
    else
        _statLabel.text = @"Select game to enter stats";
    
    if ((game) || (athlete)) {
        [_statsTableView reloadData];
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

- (IBAction)addplayerButtonClicked:(id)sender {
}

- (IBAction)savestatsButtonClicked:(id)sender {
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (offense)
        return 3;
    else if (specialteams)
        return 4;
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (offense) {
        if (section == 0)
            return currentSettings.team.fb_pass_players.count;
        else if (section == 1)
            return currentSettings.team.fb_rush_players.count;
        else
            return currentSettings.team.fb_rec_players.count;
    } else if (specialteams) {
        if (section == 0)
            return currentSettings.team.fb_placekickers.count;
        else if (section == 1)
            return currentSettings.team.fb_kickers.count;
        else if (section == 2)
             return currentSettings.team.fb_punters.count;
       else
            return currentSettings.team.fb_returners.count;
    } else {
        return currentSettings.team.fb_def_players.count;
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
            player = [currentSettings findAthlete:[currentSettings.team.fb_pass_players objectAtIndex:indexPath.row]];
            FootballPassingStat *stat = [player findFootballPassingStat:game.id];
            cell.label1.text = [stat.attempts stringValue];
            cell.label2.text = [stat.completions stringValue];
            cell.label3.text = [stat.comp_percentage stringValue];
            cell.label4.text = [stat.yards stringValue];
            cell.label5.text = [stat.td stringValue];
            cell.label6.text = [stat.interceptions stringValue];
            cell.label7.text = [stat.sacks stringValue];
            cell.label8.text = [stat.firstdowns stringValue];
            cell.label9.text = [stat.yards_lost stringValue];
            cell.label10.text = [stat.twopointconv stringValue];
            cell.label11.hidden = YES;
        } else if (indexPath.section == 1) {
            player = [currentSettings findAthlete:[currentSettings.team.fb_rush_players objectAtIndex:indexPath.row]];
            FootballRushingStat *stat = [player findFootballRushingStat:game.id];
            cell.imageView.image = [player getImage:@"tiny"];
            cell.namelabel.text = player.logname;
            cell.label1.text = [stat.attempts stringValue];
            cell.label2.text = [stat.yards stringValue];
            cell.label3.text = [stat.average stringValue];
            cell.label4.text = [stat.td stringValue];
            cell.label5.text = [stat.firstdowns stringValue];
            cell.label6.text = [stat.longest stringValue];
            cell.label7.text = [stat.fumbles stringValue];
            cell.label8.text = [stat.fumbles_lost stringValue];
            cell.label9.text = [stat.twopointconv stringValue];
            cell.label10.hidden = YES;
            cell.label11.hidden = YES;
        } else {
            player = [currentSettings findAthlete:[currentSettings.team.fb_rec_players objectAtIndex:indexPath.row]];
        }
        
    } else if (specialteams) {
        
    } else {
        
    }

    cell.imageView.image = [player getImage:@"tiny"];
    cell.namelabel.text = player.logname;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (offense) {
        
        if (section == 0)
            return @"              Player                Att    CMP      AVG   3PA    3PM       3FGP  FTM     FTA        FTP  FOULS POINTS";
        else if (section == 1)
            return @"              Player                FGM    FGA      FGP   3PA    3PM       3FGP  FTM     FTA        FTP  FOULS POINTS";
        else
            return @"              Player                FGM    FGA      FGP   3PA    3PM       3FGP  FTM     FTA        FTP  FOULS POINTS";

    } else if (specialteams)
        return @"              Player                FGM    FGA      FGP   3PA    3PM       3FGP  FTM     FTA        FTP  FOULS POINTS";
    else
        return @"              Player                FGM    FGA      FGP   3PA    3PM       3FGP  FTM     FTA        FTP  FOULS POINTS";

//    else
//        return @"              Game                  FGM    FGA      FGP   3PA    3PM       3FGP  FTM     FTA        FTP  FOULS POINTS";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (game) {
//        liveStatsController.player = [currentSettings.roster objectAtIndex:indexPath.row];
//        liveStatsController.game = game;
    } else if (athlete) {
//        liveStatsController.player = athlete;
//        liveStatsController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"  message:@"Select game to update stats for player!"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
    
//    [liveStatsController viewWillAppear:YES];
//    _basketballLiveStatsContainer.hidden = NO;
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
    if ([segue.identifier isEqualToString:@"LiveStatsSegue"]) {
//        liveStatsController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"TotalStatsSegue"]) {
//        totalStatsController = segue.destinationViewController;
    }
}

@end
