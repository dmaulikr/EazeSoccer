//
//  EazesportzWaterPoloStatsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/22/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzWaterPoloStatsViewController.h"
#import "EazesportzAppDelegate.h"
#import "SoccerPlayerStatsTableCell.h"

@interface EazesportzWaterPoloStatsViewController ()

@end

@implementation EazesportzWaterPoloStatsViewController {
    NSString *visiblestats;
    VisitingTeam *visitingteam;
    NSMutableArray *goalies, *scorings, *penalties;
}

@synthesize game;
@synthesize isVisitingTeam;

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
    
    if (isVisitingTeam)
        visitingteam = [currentSettings findVisitingTeam:game.soccer_game.visiting_team_id];
    else
        visitingteam = nil;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([visiblestats isEqualToString:@"Stats"]) {
        if (isVisitingTeam) {
            if (section == 0) {
                return visitingteam.visitor_roster.count;
            } else {
                goalies = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < visitingteam.visitor_roster.count; i++) {
                    VisitorRoster *aplayer = [visitingteam.visitor_roster objectAtIndex:i];
                    if ([aplayer isWaterPoloGoalie]) {
                        [goalies addObject:aplayer];
                    }
                }
                
                return goalies.count;
            }
        } else {
            if (section == 0)
                return currentSettings.roster.count;
            else {
                goalies = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < currentSettings.roster.count; i++) {
                    Athlete *aplayer = [currentSettings.roster objectAtIndex:i];
                    if ([aplayer isWaterPoloGoalie]) {
                        [goalies addObject:aplayer];
                    }
                }
                
                return goalies.count;
            }
        }
    } else if ([visiblestats isEqualToString:@"Score"]) {
        scorings = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < currentSettings.roster.count; i++) {
            Athlete *player = [currentSettings.roster objectAtIndex:i];
            [scorings addObjectsFromArray:[[player findWaterPoloStat:game] scoring_stats]];
        }
        
        if (isVisitingTeam) {
            for (int i = 0; i < visitingteam.visitor_roster.count; i++) {
                VisitorRoster *player = [visitingteam.visitor_roster objectAtIndex:i];
                [scorings addObjectsFromArray:[[player findWaterPoloStat:game] scoring_stats]];
            }
        }
        
        if ([currentSettings isSiteOwner])
            return scorings.count + 1;
        else
            return scorings.count;
    } else {
        penalties = [[NSMutableArray alloc] init];
        
        if (isVisitingTeam) {
            for (int i = 0; i < visitingteam.visitor_roster.count; i++) {
                VisitorRoster *player = [visitingteam.visitor_roster objectAtIndex:i];
                [penalties addObjectsFromArray:[[player findWaterPoloStat:game] penalty_stats]];
            }
        } else {
            for (int i = 0; i < currentSettings.roster.count; i++) {
                Athlete *player = [currentSettings.roster objectAtIndex:i];
                [penalties addObjectsFromArray:[[player findWaterPoloStat:game] penalty_stats]];
            }
        }
        
        if ([currentSettings isSiteOwner])
            return penalties.count + 1;
        else
            return penalties.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([visiblestats isEqualToString:@"Stats"]) {
        SoccerPlayerStatsTableCell *cell = [[SoccerPlayerStatsTableCell alloc] init];
        static NSString *CellIdentifier = @"StatsTableCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        if (cell == nil) {
            cell = [[SoccerPlayerStatsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        if (indexPath.section == 0) {
            if (isVisitingTeam) {
                VisitorRoster *player = [visitingteam.visitor_roster objectAtIndex:indexPath.row];
                cell.label1.text = [player.number stringValue];
                cell.label2.text = player.position;
                cell.label3.text = player.logname;
                cell.label4.text = [[[player findWaterPoloStat:game] getTotalShots] stringValue];
                cell.label5.text = [[[player findWaterPoloStat:game] getTotalGoals] stringValue];
                cell.label6.text = [[[player findWaterPoloStat:game] getTotalAssists] stringValue];
            } else {
                Athlete *player = [currentSettings.roster objectAtIndex:indexPath.row];
                cell.label1.text = [player.number stringValue];
                cell.label2.text = player.position;
                cell.label3.text = player.logname;
                cell.label4.text = [[[player findWaterPoloStat:game] getTotalShots] stringValue];
                cell.label5.text = [[[player findWaterPoloStat:game] getTotalGoals] stringValue];
                cell.label6.text = [[[player findWaterPoloStat:game] getTotalAssists] stringValue];
            }
            
        } else {
            if (isVisitingTeam) {
                VisitorRoster *player = [goalies objectAtIndex:indexPath.row];
                cell.label1.text = [player.number stringValue];
                cell.label2.text = player.position;
                cell.label3.text = player.logname;
                cell.label4.text = [[[player findWaterPoloStat:game] getTotalSaves] stringValue];
                cell.label5.text = [[[player findWaterPoloStat:game] getTotalGoalsAllowed] stringValue];
                cell.label6.text = [[[player findWaterPoloStat:game] getTotalMinutes] stringValue];
            } else {
                Athlete *player = [goalies objectAtIndex:indexPath.row];
                cell.label1.text = [player.number stringValue];
                cell.label2.text = player.position;
                cell.label3.text = player.logname;
                cell.label4.text = [[[player findWaterPoloStat:game] getTotalSaves] stringValue];
                cell.label5.text = [[[player findWaterPoloStat:game] getTotalGoalsAllowed] stringValue];
                cell.label6.text = [[[player findWaterPoloStat:game] getTotalMinutes] stringValue];
            }
            
        }
        
        return cell;
    } else if ([visiblestats isEqualToString:@"Score"]) {
        SoccerPlayerStatsTableCell *cell = [[SoccerPlayerStatsTableCell alloc] init];
        static NSString *CellIdentifier = @"ScoreStatCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        if (cell == nil) {
            cell = [[SoccerPlayerStatsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        if (indexPath.row < scorings.count) {
            SoccerScoring *score = [scorings objectAtIndex:indexPath.row];
            
            if (score.athlete_id.length > 0) {
                Athlete *player = [currentSettings findAthlete:score.athlete_id];
                cell.label1.text = player.logname;
                cell.label2.text = @"H";
            } else {
                VisitorRoster *player = [visitingteam findAthlete:score.visitor_roster_id];
                cell.label1.text = player.logname;
                cell.label2.text = @"V";
            }
            
            cell.label3.text = score.gametime;
            
            if (score.assist.length > 0) {
                if (score.athlete_id.length > 0)
                    cell.label4.text = [[currentSettings findAthlete:score.assist] logname];
                else
                    cell.label4.text = [[visitingteam findAthlete:score.assist] logname];
            } else {
                cell.label4.text = @"";
            }
            
            cell.label5.text = @"";
            cell.label6.text = @"";
            
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
            if ((score.photos.count > 0) || (score.videos.count > 0)) {
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
        } else {
            cell.label1.text = @"Add Score";
            cell.label2.text = @"";
            cell.label3.text = @"";
            cell.label4.text = @"";
            cell.label5.text = @"";
            cell.label6.text = @"";
        }
        
        return cell;
    } else {
        SoccerPlayerStatsTableCell *cell = [[SoccerPlayerStatsTableCell alloc] init];
        static NSString *CellIdentifier = @"PenaltyStatCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        if (cell == nil) {
            cell = [[SoccerPlayerStatsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        if ([currentSettings isSiteOwner])
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        else
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row < penalties.count) {
            SoccerPenalty *penalty = [penalties objectAtIndex:indexPath.row];
            
            if (isVisitingTeam) {
                VisitorRoster *player = [visitingteam.visitor_roster objectAtIndex:indexPath.row];
                cell.label1.text = player.logname;
            } else {
                Athlete *player = [currentSettings.roster objectAtIndex:indexPath.row];
                cell.label1.text = player.logname;
            }
            
            cell.label2.text = penalty.card;
            cell.label3.text = penalty.gametime;
            cell.label4.text = penalty.infraction;
        } else {
            cell.label1.text = @"Add Card";
            cell.label2.text = @"";
            cell.label3.text = @"";
            cell.label4.text = @"";
            cell.label5.text = @"";
            cell.label6.text = @"";
        }
        
        return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
/*    if ([currentSettings isSiteOwner]) {
        if ([visiblestats isEqualToString:@"Stats"]) {
            if (indexPath.section == 0) {
                _playerStatsContainer.hidden = NO;
                playerstatsController.game = game;
                playerstatsController.player = [currentSettings.roster objectAtIndex:indexPath.row];
                
                if (isVisitingTeam)
                    playerstatsController.visitor = YES;
                else
                    playerstatsController.visitor = NO;
                
                [playerstatsController viewWillAppear:YES];
            } else {
                _goalieStatsContainer.hidden = NO;
                goaliestatsController.game = game;
                goaliestatsController.player = [currentSettings.roster objectAtIndex:indexPath.row];
                
                if (isVisitingTeam)
                    goaliestatsController.visitor = YES;
                else
                    goaliestatsController.visitor = NO;
                
                [goaliestatsController viewWillAppear:YES];
            }
        } else if ([visiblestats isEqualToString:@"Score"]) {
            _scoreStatsContainer.hidden = NO;
            scorestatsController.game = game;
            
            if (isVisitingTeam)
                scorestatsController.visitor = YES;
            else
                scorestatsController.visitor = NO;
            
            if (indexPath.row < scoreings.count) {
                scorestatsController.score = [scorings objectAtIndex:indexPath.row];
            } else {
                scorestatsController.score = nil;
            }
            
            [scorestatsController viewWillAppear:YES];
        } else {
            _penaltyStatsContainer.hidden = NO;
            penaltyController.game = game;
            
            if (isVisitingTeam)
                penaltyController.visitor = YES;
            else
                penaltyController.visitor = NO;
            
            if (indexPath.row < penalties.count) {
                penaltyController.penalty = [penalties objectAtIndex:indexPath.row];
            } else {
                penaltyController.penalty = nil;
            }
            
            [penaltyController viewWillAppear:YES];
        }
    } else {
        if ([visiblestats isEqualToString:@"Stats"])
            [self performSegueWithIdentifier:@"SoccerTotalsSegue" sender:self];
        else if ([visiblestats isEqualToString:@"Score"]) {
            SoccerScoring *score = [scoreings objectAtIndex:indexPath.row];
            
            if ((score.photos.count > 0) && (score.videos.count > 0)) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Score has Photo's and Video" delegate:self
                                                      cancelButtonTitle:@"Cancel" otherButtonTitles:@"Photo", @"Video", nil];
                [alert show];
            } else if (score.photos.count > 0) {
                [self performSegueWithIdentifier:@"GamePhotoSegue" sender:self];
            } else {
                [self performSegueWithIdentifier:@"GameVideoSegue" sender:self];
            }
        }
    }
 */
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SoccerPlayerStatsTableCell *headerView;
    
    if ([visiblestats isEqualToString:@"Stats"]) {
        if (section == 0) {
            static NSString *CellIdentifier = @"StatsTableHeaderCell";
            headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            headerView.backgroundColor = [UIColor cyanColor];
            headerView.label1.text = @"No.";
            headerView.label2.text = @"P";
            headerView.label3.text = @"Name";
            headerView.label4.text = @"SH";
            headerView.label5.text = @"G";
            headerView.label6.text = @"A";
        } else {
            static NSString *CellIdentifier = @"StatsTableHeaderCell";
            headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            headerView.backgroundColor = [UIColor cyanColor];
            headerView.label1.text = @"No.";
            headerView.label2.text = @"P";
            headerView.label3.text = @"Name";
            headerView.label4.text = @"SV";
            headerView.label5.text = @"G";
            headerView.label6.text = @"Min";
        }
    } else if ([visiblestats isEqualToString:@"Score"]) {
        static NSString *CellIdentifier = @"ScoreHeaderCell";
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        headerView.backgroundColor = [UIColor cyanColor];
        headerView.label1.text = @"Goal By";
        headerView.label2.text = @"Team";
        headerView.label3.text = @"Time";
        headerView.label4.text = @"Assist";
        headerView.label5.text = @"";
        headerView.label6.text = @"";
    } else {
        static NSString *CellIdentifier = @"PenaltyHeaderCell";
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        headerView.backgroundColor = [UIColor cyanColor];
        headerView.label1.text = @"Player";
        headerView.label2.text = @"Y/R";
        headerView.label3.text = @"Time";
        headerView.label4.text = @"Pen";
        headerView.label5.text = @"";
        headerView.label6.text = @"";
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Photo"]) {
        [self performSegueWithIdentifier:@"GamePhotoSegue" sender:self];
    } else if ([title isEqualToString:@"Video"]) {
        [self performSegueWithIdentifier:@"GameVideoSegue" sender:self];
    }
}

- (IBAction)scoreButtonClicked:(id)sender {
    visiblestats = @"Score";
    [_statsTableView reloadData];
}

- (IBAction)subsButtonClicked:(id)sender {
    visiblestats = @"Subs";
    [_statsTableView reloadData];
}

- (IBAction)cardButtonClicked:(id)sender {
    visiblestats = @"Card";
    [_statsTableView reloadData];
}

- (IBAction)statsButtonClicked:(id)sender {
    visiblestats = @"Stats";
    [_statsTableView reloadData];
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
