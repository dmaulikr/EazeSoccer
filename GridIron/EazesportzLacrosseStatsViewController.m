//
//  EazesportzLacrosseStatsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/23/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzLacrosseStatsViewController.h"

#import "EazesportzLacrosseStatTableViewCell.h"
#import "EazesportzLacrosseGoalieStatsTableViewCell.h"
#import "EazesportzLacrosseMinutesStatTableViewCell.h"
#import "EazesportzAppDelegate.h"
#import "Lacrosstat.h"
#import "LacrossPlayerStat.h"
#import "LacrossAllStats.h"
#import "EazesportzLacrosseShotsViewController.h"
#import "EazesportzLacrossePlayerStatsViewController.h"
#import "EazesportzLacrosseGoalieStatsViewController.h"
#import "EazesportzLacrosseScoresheetViewController.h"
#import "EazesportzRetrievePlayers.h"

@interface EazesportzLacrosseStatsViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzLacrosseStatsViewController {
    BOOL playerStats, visitorstats;
    VisitingTeam *visitors;
    NSIndexPath *deleteIndexPath, *selectedIndex;
    
    NSArray *gamestats;
    NSMutableArray *goaliestats;
    
    EazesportzLacrosseShotsViewController *shotsController;
    EazesportzLacrossePlayerStatsViewController *playerStatsController;
    EazesportzLacrosseGoalieStatsViewController *goalieController;
}

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
    playerStats = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _pickerView.hidden = YES;
    _shotsContainer.hidden = YES;
    _playerstatsContainer.hidden = YES;
    _goaliestatsContainer.hidden = YES;
    
    [_homeButton setTitle:currentSettings.team.mascot];
    [_visitorButton setTitle:game.opponent_mascot];
    
    if (game.lacross_game.visiting_team_id.length > 0) {
        visitors = [currentSettings findVisitingTeam:game.lacross_game.visiting_team_id];
    } else {
        _visitorButton.enabled = NO;
    }
    
    gamestats = [self sortedPlayerStats];
    [self getGoalieStats];
    
    if (currentSettings.isSiteOwner)
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshBarButton, self.scoreButton, nil];
    else
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshBarButton, nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShotStatsSegue"])
        shotsController = segue.destinationViewController;
    else if ([segue.identifier isEqualToString:@"PlayerStatsSegue"])
        playerStatsController = segue.destinationViewController;
    else if ([segue.identifier isEqualToString:@"GoalieStatSegue"])
        goalieController = segue.destinationViewController;
    else if ([segue.identifier isEqualToString:@"ScoreSheetSegue"]) {
        EazesportzLacrosseScoresheetViewController *destController = segue.destinationViewController;
        destController.game = game;
    }
}

- (IBAction)playerButtonClicked:(id)sender {
    playerStats = YES;
    [_statsTableView reloadData];
}

- (IBAction)goalieButtonClicked:(id)sender {
    playerStats = NO;
    [_statsTableView reloadData];
}

- (IBAction)homeButtonClicked:(id)sender {
    visitorstats = NO;
    gamestats = [self sortedPlayerStats];
    [self getGoalieStats];
    [_statsTableView reloadData];
}

- (IBAction)visitorButtonClicked:(id)sender {
    visitorstats = YES;
    gamestats = [self sortedPlayerStats];
    [self getGoalieStats];
    [_statsTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (playerStats)
        return 3;
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (playerStats) {
        if ((gamestats.count == 0) && ([currentSettings isSiteOwner])) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Player Stats" message:@"Select Stat to Add" delegate:self
                                                  cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Shot", @"Player Stats", nil];
            [alert show];
        }
        return gamestats.count;
    } else {
        if ((goaliestats.count == 0) && ([currentSettings isSiteOwner])) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Goalie Stats" message:@"Select Add to add goalie stats" delegate:self
                                                  cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Goalie", nil];
            [alert show];
        }
        return goaliestats.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    
    if ((playerStats) && (indexPath.section == 0)) {
        EazesportzLacrosseStatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerTableCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        LacrossAllStats *thestat = [gamestats objectAtIndex:indexPath.row];
        
        if (visitorstats) {
            VisitorRoster *player = [visitors findAthlete:[[gamestats objectAtIndex:indexPath.row] visitor_roster_id]];
            cell.numberLabel.text = [player.number stringValue];
            cell.playerLabel.text = player.logname;
            cell.positionLabel.text = player.position;
        } else {
            Athlete *player = [currentSettings findAthlete:[[gamestats objectAtIndex:indexPath.row] athlete_id]];
            cell.numberLabel.text = [player.number stringValue];
            cell.playerLabel.text = player.logname;
            cell.positionLabel.text = player.position;
        }
        
        cell.label1.text = [thestat.goals stringValue];
        cell.label2.text = [thestat.assists stringValue];
        cell.label3.text = [thestat.shots stringValue];
        cell.label4.text = [thestat.ground_ball stringValue];
        
        return cell;
    } else if ((playerStats) && (indexPath.section == 1)) {
        EazesportzLacrosseStatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerTableCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        LacrossAllStats *thestat = [gamestats objectAtIndex:indexPath.row];
        
        if (visitorstats) {
            VisitorRoster *player = [visitors findAthlete:[[gamestats objectAtIndex:indexPath.row] visitor_roster_id]];
            cell.numberLabel.text = [player.number stringValue];
            cell.playerLabel.text = player.logname;
            cell.positionLabel.text = player.position;
        } else {
            Athlete *player = [currentSettings findAthlete:[[gamestats objectAtIndex:indexPath.row] athlete_id]];
            cell.numberLabel.text = [player.number stringValue];
            cell.playerLabel.text = player.logname;
            cell.positionLabel.text = player.position;
        }
        
        cell.label1.text = [thestat.turnover stringValue];
        cell.label2.text = [thestat.caused_turnover stringValue];
        cell.label3.text = [thestat.steals stringValue];
        cell.label4.text = [thestat.penalties stringValue];
        
        return cell;
    } else if ((playerStats) && (indexPath.section == 2)) {
        EazesportzLacrosseMinutesStatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerFaceoffTableCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        LacrossAllStats *thestat = [gamestats objectAtIndex:indexPath.row];
        
        if (visitorstats) {
            VisitorRoster *player = [visitors findAthlete:[[gamestats objectAtIndex:indexPath.row] visitor_roster_id]];
            cell.numberLabel.text = [player.number stringValue];
            cell.playerLabel.text = player.logname;
            cell.positionLabel.text = player.position;
        } else {
            Athlete *player = [currentSettings findAthlete:[[gamestats objectAtIndex:indexPath.row] athlete_id]];
            cell.numberLabel.text = [player.number stringValue];
            cell.playerLabel.text = player.logname;
            cell.positionLabel.text = player.position;
        }
        
        cell.faceoffLabel.text = [NSString stringWithFormat:@"%@-%@", [thestat.face_off_won stringValue], [thestat.face_off_lost stringValue]];
        cell.penaltyLabel.text = thestat.penaltytime;
        
        return cell;
    } else {
        EazesportzLacrosseGoalieStatsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoalieTableCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        LacrossAllStats *thestat = [gamestats objectAtIndex:indexPath.row];
        
        if (visitorstats) {
            VisitorRoster *player = [visitors findAthlete:[[gamestats objectAtIndex:indexPath.row] visitor_roster_id]];
            cell.numberLabel.text = [player.number stringValue];
            cell.playerLabel.text = player.logname;
        } else {
            Athlete *player = [currentSettings findAthlete:[[gamestats objectAtIndex:indexPath.row] athlete_id]];
            cell.numberLabel.text = [player.number stringValue];
            cell.playerLabel.text = player.logname;
        }
        
        cell.savesLabel.text = [thestat.saves stringValue];
        cell.minutesLabel.text = thestat.minutesplayed;
        cell.decisionLabel.text = @"";
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([currentSettings isSiteOwner]) {
        if (playerStats) {
            selectedIndex = indexPath;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Stats" message:@"Select Stat to Add" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Shot", @"Player Stats", nil];
            [alert show];
        } else {
            _goaliestatsContainer.hidden = NO;
            
            if (visitorstats) {
                goalieController.visitingPlayer = [visitors findAthlete:[[goaliestats objectAtIndex:selectedIndex.row] visitor_roster_id]];
                goalieController.player = nil;
            } else {
                goalieController.player = [currentSettings findAthlete:[[goaliestats objectAtIndex:selectedIndex.row] athlete_id]];
                goalieController.visitingPlayer = nil;
            }
            
            goalieController.game = game;
            [goalieController viewWillAppear:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([currentSettings isSiteOwner]) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            deleteIndexPath = indexPath;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"Stats will be automatically updated. Click Confirm to Proceed"
                                                           delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:@"Cancel", nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if ((playerStats) && (section == 0)) {
        EazesportzLacrosseStatTableViewCell *headerView;
        static NSString *CellIdentifier = @"PlayerHeaderCell";
        
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UILabel *label = (UILabel *)[headerView viewWithTag:1];
        label.text = @"P";
        label = (UILabel *)[headerView viewWithTag:2];
        label.text = @"No.";
        label = (UILabel *)[headerView viewWithTag:3];
        label.text = @"Player";
        label = (UILabel *)[headerView viewWithTag:4];
        label.text = @"G";
        label = (UILabel *)[headerView viewWithTag:5];
        label.text = @"A";
        label = (UILabel *)[headerView viewWithTag:6];
        label.text = @"SH";
        label = (UILabel *)[headerView viewWithTag:7];
        label.text = @"GB";
        return headerView;
    } else if ((playerStats) && (section == 1)) {
        EazesportzLacrosseStatTableViewCell *headerView;
        static NSString *CellIdentifier = @"PlayerHeaderCell";
        
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UILabel *label = (UILabel *)[headerView viewWithTag:1];
        label.text = @"P";
        label = (UILabel *)[headerView viewWithTag:2];
        label.text = @"No.";
        label = (UILabel *)[headerView viewWithTag:3];
        label.text = @"Player";
        label = (UILabel *)[headerView viewWithTag:4];
        label.text = @"T";
        label = (UILabel *)[headerView viewWithTag:5];
        label.text = @"CT";
        label = (UILabel *)[headerView viewWithTag:6];
        label.text = @"ST";
        label = (UILabel *)[headerView viewWithTag:7];
        label.text = @"PN";
        return headerView;
    } else if ((playerStats) && (section == 2)) {
        EazesportzLacrosseStatTableViewCell *headerView;
        static NSString *CellIdentifier = @"PlayerFaceoffHeaderCell";
        
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        return headerView;
    } else {
        EazesportzLacrosseGoalieStatsTableViewCell *headerView;
        static NSString *CellIdentifier = @"GoalieHeaderCell";
        
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"])
        return 30.0;
    else
        return 44.0;
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (NSMutableArray *)sortRosterByGoal {
    
    NSMutableArray *sortedroster = [currentSettings.roster mutableCopy];
    
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"period" ascending:YES];
    NSSortDescriptor *secondDescriptor = [[NSSortDescriptor alloc] initWithKey:@"gametime" ascending:NO
                                                                      selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *descriptors = [NSArray arrayWithObjects:firstDescriptor, secondDescriptor, nil];
    [sortedroster sortUsingDescriptors:descriptors];
    
    return sortedroster;
}

- (NSArray *)sortedPlayerStats {
    NSArray *sortedstats;
    NSMutableArray *statsarray = [[NSMutableArray alloc] init];
    
    if (visitorstats) {
        for (int i = 0; i < visitors.visitor_roster.count; i++) {
            LacrossAllStats *allstats = [[[visitors.visitor_roster objectAtIndex:i] findLacrossStat:game] summarizeStats];
            [statsarray addObject:allstats];
        }
    } else {
        for (int i = 0; i < currentSettings.roster.count; i++) {
            LacrossAllStats *allstats = [[[currentSettings.roster objectAtIndex:i] findLacrosstat:game] summarizeStats];
            [statsarray addObject:allstats];
        }
    }
    
    NSSortDescriptor* descriptor= [NSSortDescriptor sortDescriptorWithKey: @"goals" ascending: NO];
    sortedstats = [statsarray sortedArrayUsingDescriptors: @[ descriptor ]];
    
    return sortedstats;
}

- (void)getGoalieStats {
    goaliestats = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < gamestats.count; i++) {
        if ([[gamestats objectAtIndex:i] hasGoalieStats]) {
            [goaliestats addObject:[gamestats objectAtIndex:i]];
        }
    }
}

- (IBAction)lacrosseShotsAdded:(UIStoryboardSegue *)segue {
    _shotsContainer.hidden = YES;
    gamestats = [self sortedPlayerStats];
    [_statsTableView reloadData];
}

- (IBAction)lacrosseCancelStats:(UIStoryboardSegue *)segue {
    _shotsContainer.hidden = YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Add Shot"]) {
        _shotsContainer.hidden = NO;
        
        if (visitorstats) {
            shotsController.visitingPlayer = [visitors findAthlete:[[gamestats objectAtIndex:selectedIndex.row] visitor_roster_id]];
            shotsController.player = nil;
        } else {
            shotsController.player = [currentSettings findAthlete:[[gamestats objectAtIndex:selectedIndex.row] athlete_id]];
            shotsController.visitingPlayer = nil;
        }
        shotsController.game = game;
        [shotsController viewWillAppear:YES];
    } else if ([title isEqualToString:@"Player Stats"]) {
        _playerstatsContainer.hidden = NO;
        
        if (visitorstats) {
            playerStatsController.visitingPlayer = [visitors findAthlete:[[gamestats objectAtIndex:selectedIndex.row] visitor_roster_id]];
            playerStatsController.player = nil;
        } else {
            playerStatsController.player = [currentSettings findAthlete:[[gamestats objectAtIndex:selectedIndex.row] athlete_id]];
            playerStatsController.visitingPlayer = nil;
        }
        playerStatsController.game = game;
        [playerStatsController viewWillAppear:YES];
    } else if ([title isEqualToString:@"Add Goalie"]) {
        _pickerView.hidden = NO;
    } else if ([title isEqualToString:@"Add Player Stat"]) {
        _pickerView.hidden = NO;
    }
}

- (IBAction)lacrossePlayerStatsAdded:(UIStoryboardSegue *)segue {
    _playerstatsContainer.hidden = YES;
    gamestats = [self sortedPlayerStats];
    [_statsTableView reloadData];
}

- (IBAction)lacrosseGoalieStatsAdded:(UIStoryboardSegue *)segue {
    _goaliestatsContainer.hidden = YES;
    gamestats = [self sortedPlayerStats];
    [_statsTableView reloadData];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// Method to define the numberOfRows in a component using the array.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component {
    if (visitorstats)
        return visitors.visitor_roster.count;
    else
        return currentSettings.roster.count;
}

// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (visitorstats)
        return [[visitors.visitor_roster objectAtIndex:row] numberLogname];
    else
        return [[currentSettings.roster objectAtIndex:row] numberLogname];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _pickerView.hidden = YES;
    
    if (playerStats) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Player Stat" message:@"Add Shot or Other Player Statistic?" delegate:self
                                              cancelButtonTitle:@"Ok" otherButtonTitles:@"Add Shot", @"Player Stats", nil];
        [alert show];
    } else {
        _goaliestatsContainer.hidden = NO;
        goalieController.game = game;
        
        if (visitorstats) {
            goalieController.visitingPlayer = [visitors.visitor_roster objectAtIndex:row];
            goalieController.player = nil;
        } else {
            goalieController.player = [currentSettings.roster objectAtIndex:row];
            goalieController.visitingPlayer = nil;
        }
        
        [goalieController viewWillAppear:YES];
    }
}

- (IBAction)refreshBarButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotRoster:) name:@"RosterChangedNotification" object:nil];
    [[EazesportzRetrievePlayers alloc] retrievePlayers:currentSettings.sport.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken];
}

- (void)gotRoster:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        [_statsTableView reloadData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error refreshing stats" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RosterChangedNotification" object:nil];
}

- (IBAction)scoreButtonClicked:(id)sender {
}
@end
