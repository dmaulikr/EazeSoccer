//
//  EazesportzSoccerScoreSheetViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/8/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzSoccerScoreSheetViewController.h"
#import "EazesportzAppDelegate.h"
#import "SoccerPlayerStatsTableCell.h"
#import "SoccerSubs.h"
#import "EazesportzSoccerPlayerStatsViewController.h"
#import "EazesportzSoccerGoalieStatsViewController.h"
#import "EazesportzSoccerScoreStatsViewController.h"
#import "EazesportzSoccerPenaltyStatsViewController.h"
#import "EazeSoccerStatsViewController.h"
#import "EazesportzSoccerSubStatsViewController.h"
#import "EazePhotosViewController.h"
#import "EazesVideosViewController.h"

@interface EazesportzSoccerScoreSheetViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzSoccerScoreSheetViewController {
    NSString *visiblestats;
    
    NSMutableArray *goalies, *scoreings, *penalties;
    VisitingTeam *visitingteam;
    
    EazesportzSoccerPlayerStatsViewController *playerstatsController;
    EazesportzSoccerGoalieStatsViewController *goaliestatsController;
    EazesportzSoccerScoreStatsViewController *scorestatsController;
    EazesportzSoccerPenaltyStatsViewController *penaltyController;
    EazesportzSoccerSubStatsViewController *subsController;
}

@synthesize isVisitingTeam;
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
    visiblestats = @"Stats";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _playerStatsContainer.hidden = YES;
    _goalieStatsContainer.hidden = YES;
    _scoreStatsContainer.hidden = YES;
    _penaltyStatsContainer.hidden = YES;
    _subsStatsContainer.hidden = YES;
    
    if (isVisitingTeam)
        visitingteam = [currentSettings findVisitingTeam:game.soccer_game.visiting_team_id];
    else
        visitingteam = nil;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayerStatsSegue"]) {
        playerstatsController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"GoalieStatsSegue"]) {
        goaliestatsController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"ScoreStatsSegue"]) {
        scorestatsController = segue.destinationViewController;
    }  else if ([segue.identifier isEqualToString:@"PenaltyStatsSegue"]) {
        penaltyController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"SoccerTotalsSegue"]) {
        EazeSoccerStatsViewController *destController = segue.destinationViewController;
        destController.athlete = [currentSettings.roster objectAtIndex:[_scoreSheetTableView indexPathForSelectedRow].row];
    } else if ([segue.identifier isEqualToString:@"SubsStatsSegue"]) {
        subsController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"GamePhotoSegue"]) {
        EazePhotosViewController *destController = segue.destinationViewController;
        currentSettings.photodeleted = YES;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"GameVideoSegue"]) {
        EazesVideosViewController *destController = segue.destinationViewController;
        destController.game = game;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ([visiblestats isEqualToString:@"Stats"])
        return 2;
    else
        return 1;
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
                    if ([aplayer isSoccerGoalie]) {
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
                    if ([aplayer isSoccerGoalie]) {
                        [goalies addObject:aplayer];
                    }
                }
                
                return goalies.count;
            }
        }
    } else if ([visiblestats isEqualToString:@"Score"]) {
        scoreings = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < currentSettings.roster.count; i++) {
            Athlete *player = [currentSettings.roster objectAtIndex:i];
            [scoreings addObjectsFromArray:[[player getSoccerGameStat:game.soccer_game.soccer_game_id] scoring_stats]];
        }
        
        if (isVisitingTeam) {
            for (int i = 0; i < visitingteam.visitor_roster.count; i++) {
                VisitorRoster *player = [visitingteam.visitor_roster objectAtIndex:i];
                [scoreings addObjectsFromArray:[[player getSoccerGameStat:game.soccer_game.soccer_game_id] scoring_stats]];
            }
        }
        
        if ([currentSettings isSiteOwner])
            return scoreings.count + 1;
        else
            return scoreings.count;
    } else if ([visiblestats isEqualToString:@"Card"]) {
        penalties = [[NSMutableArray alloc] init];
        
        if (isVisitingTeam) {
            for (int i = 0; i < visitingteam.visitor_roster.count; i++) {
                VisitorRoster *player = [visitingteam.visitor_roster objectAtIndex:i];
                [penalties addObjectsFromArray:[[player getSoccerGameStat:game.soccer_game.soccer_game_id] penalty_stats]];
            }
        } else {
            for (int i = 0; i < currentSettings.roster.count; i++) {
                Athlete *player = [currentSettings.roster objectAtIndex:i];
                [penalties addObjectsFromArray:[[player getSoccerGameStat:game.soccer_game.soccer_game_id] penalty_stats]];
            }
        }
        
        if ([currentSettings isSiteOwner])
            return penalties.count + 1;
        else
            return penalties.count;
    } else {
        if ([currentSettings isSiteOwner])
            return game.soccer_game.soccersubs.count + 1;
        else
            return game.soccer_game.soccersubs.count;
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
                cell.label4.text = [[[player getSoccerGameStat:game.soccer_game.soccer_game_id] getTotalShots] stringValue];
                cell.label5.text = [[[player getSoccerGameStat:game.soccer_game.soccer_game_id] getTotalGoals] stringValue];
                cell.label6.text = [[[player getSoccerGameStat:game.soccer_game.soccer_game_id] getTotalAssists] stringValue];
            } else {
                Athlete *player = [currentSettings.roster objectAtIndex:indexPath.row];
                cell.label1.text = [player.number stringValue];
                cell.label2.text = player.position;
                cell.label3.text = player.logname;
                cell.label4.text = [[[player getSoccerGameStat:game.soccer_game.soccer_game_id] getTotalShots] stringValue];
                cell.label5.text = [[[player getSoccerGameStat:game.soccer_game.soccer_game_id] getTotalGoals] stringValue];
                cell.label6.text = [[[player getSoccerGameStat:game.soccer_game.soccer_game_id] getTotalAssists] stringValue];
            }
        
        } else {
            if (isVisitingTeam) {
                VisitorRoster *player = [goalies objectAtIndex:indexPath.row];
                cell.label1.text = [player.number stringValue];
                cell.label2.text = player.position;
                cell.label3.text = player.logname;
                cell.label4.text = [[[player getSoccerGameStat:game.soccer_game.soccer_game_id] getTotalSaves] stringValue];
                cell.label5.text = [[[player getSoccerGameStat:game.soccer_game.soccer_game_id] getTotalGoalsAllowed] stringValue];
                cell.label6.text = [[[player getSoccerGameStat:game.soccer_game.soccer_game_id] getTotalMinutes] stringValue];
            } else {
                Athlete *player = [goalies objectAtIndex:indexPath.row];
                cell.label1.text = [player.number stringValue];
                cell.label2.text = player.position;
                cell.label3.text = player.logname;
                cell.label4.text = [[[player getSoccerGameStat:game.soccer_game.soccer_game_id] getTotalSaves] stringValue];
                cell.label5.text = [[[player getSoccerGameStat:game.soccer_game.soccer_game_id] getTotalGoalsAllowed] stringValue];
                cell.label6.text = [[[player getSoccerGameStat:game.soccer_game.soccer_game_id] getTotalMinutes] stringValue];
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
        
        if (indexPath.row < scoreings.count) {
            SoccerScoring *score = [scoreings objectAtIndex:indexPath.row];
            
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
    } else if ([visiblestats isEqualToString:@"Card"]) {
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
    } else {
        SoccerPlayerStatsTableCell *cell = [[SoccerPlayerStatsTableCell alloc] init];
        static NSString *CellIdentifier = @"StatsTableCell";
        
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
        
        if (indexPath.row < game.soccer_game.soccersubs.count) {
            SoccerSubs *soccersub = [game.soccer_game.soccersubs objectAtIndex:indexPath.row];
            
            if (soccersub.home) {
                cell.label1.text = [[currentSettings findAthlete:soccersub.inplayer].number stringValue];
                cell.label2.text = [[currentSettings findAthlete:soccersub.outplayer].number stringValue];
                cell.label3.text = soccersub.gametime;
            } else {
                cell.label1.text = [[visitingteam findAthlete:soccersub.inplayer].number stringValue];
                cell.label2.text = [[visitingteam findAthlete:soccersub.outplayer].number stringValue];
                cell.label3.text = soccersub.gametime;
            }
            
            cell.label4.text = @"";
            cell.label5.text = @"";
            cell.label6.text = @"";
        } else {
            cell.label1.text = @"Add";
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
    if ([currentSettings isSiteOwner]) {
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
                scorestatsController.score = [scoreings objectAtIndex:indexPath.row];
            } else {
                scorestatsController.score = nil;
            }
            
            [scorestatsController viewWillAppear:YES];
        } else if ([visiblestats isEqualToString:@"Card"]) {
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
        } else {
            _subsStatsContainer.hidden = NO;
            subsController.game = game;
            
            if (isVisitingTeam)
                subsController.visitor = YES;
            else
                subsController.visitor = NO;
            
            if (indexPath.row < game.soccer_game.soccersubs.count) {
                subsController.subentry = [game.soccer_game.soccersubs objectAtIndex:indexPath.row];
            } else {
                subsController.subentry = nil;
            }
            
            [subsController viewWillAppear:YES];
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
    } else if ([visiblestats isEqualToString:@"Card"]) {
        static NSString *CellIdentifier = @"PenaltyHeaderCell";
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        headerView.backgroundColor = [UIColor cyanColor];
        headerView.label1.text = @"Player";
        headerView.label2.text = @"Y/R";
        headerView.label3.text = @"Time";
        headerView.label4.text = @"Pen";
        headerView.label5.text = @"";
        headerView.label6.text = @"";
    } else {
        static NSString *CellIdentifier = @"StatsTableHeaderCell";
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        headerView.backgroundColor = [UIColor cyanColor];
        headerView.label1.text = @"In";
        headerView.label2.text = @"Out";
        headerView.label3.text = @"Time";
        headerView.label4.text = @"";
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
    [_scoreSheetTableView reloadData];
}

- (IBAction)subsButtonClicked:(id)sender {
    visiblestats = @"Subs";
    [_scoreSheetTableView reloadData];
}

- (IBAction)cardButtonClicked:(id)sender {
    visiblestats = @"Card";
    [_scoreSheetTableView reloadData];
}

- (IBAction)statsButtonClicked:(id)sender {
    visiblestats = @"Stats";
    [_scoreSheetTableView reloadData];
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)soccerPlayerstatsDone:(UIStoryboardSegue *)segue {
    _playerStatsContainer.hidden = YES;
    [_scoreSheetTableView reloadData];
}

- (IBAction)soccerGoaliestatsDone:(UIStoryboardSegue *)segue {
    _goalieStatsContainer.hidden = YES;
    [_scoreSheetTableView reloadData];
}

- (IBAction)soccerScorestatsDone:(UIStoryboardSegue *)segue {
    _scoreStatsContainer.hidden = YES;
    [_scoreSheetTableView reloadData];
}

- (IBAction)soccerPenaltystatsDone:(UIStoryboardSegue *)segue {
    _penaltyStatsContainer.hidden = YES;
    [_scoreSheetTableView reloadData];
}

- (IBAction)soccerSubstatsDone:(UIStoryboardSegue *)segue {
    _subsStatsContainer.hidden = YES;
    [_scoreSheetTableView reloadData];
}

@end
