//
//  EazesportzHockeyStatsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 9/11/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzHockeyStatsViewController.h"

#import "EazesportzAppDelegate.h"

#import "SoccerPlayerStatsTableCell.h"
#import "EazesportzLacrosseMinutesStatTableViewCell.h"
#import "EazesportzPlayerStatTableViewCell.h"
#import "EazesportzHockeyPlayerStatsViewController.h"
#import "EazesportzHockeyScoreStatsViewController.h"
#import "EazesportzHockeyGoalStatsViewController.h"
#import "EazesportzHockeyPenaltyStatsViewController.h"
#import "EazesportzRetrievePlayers.h"
#import "EazesportzHockeyTotalsViewController.h"
#import "EazePhotosViewController.h"
#import "EazesVideosViewController.h"

@interface EazesportzHockeyStatsViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzHockeyStatsViewController {
    NSString *visiblestats;
    
    NSMutableArray *scorings, *goalies, *penalties;
    
    EazesportzHockeyPlayerStatsViewController *playerStatsController;
    EazesportzHockeyScoreStatsViewController *scoreStatsController;
    EazesportzHockeyGoalStatsViewController *goalieStatsController;
    EazesportzHockeyPenaltyStatsViewController *penaltyStatsController;
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
    visiblestats = @"Scoring";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _statsContainer.hidden = YES;
    _scoreContainer.hidden = YES;
    _goalieContainer.hidden = YES;
    _penaltyContainer.hidden = YES;
    
    if ([currentSettings isSiteOwner]) {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshBarButton, self.statsBarButton, nil];
    } else{
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.statsBarButton, nil];
    }
    
    self.navigationController.toolbarHidden = YES;
    
    [_statsTableView reloadData];
    
    if (currentSettings.roster.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Stats" message:@"No players have been added for this team" delegate:nil
                                              cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        _goalieButton.enabled = NO;
        _statsButton.enabled = NO;
    }
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PlayerStatsSegue"]) {
        playerStatsController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"ScoreStatsSegue"]) {
        scoreStatsController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"GoalieStatsSegue"]) {
        goalieStatsController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"PenaltyStatsSegue"]) {
        penaltyStatsController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"HockeyTotalsSegue"]) {
        EazesportzHockeyTotalsViewController *destController = segue.destinationViewController;
        NSIndexPath *indexPath = [_statsTableView indexPathForSelectedRow];
        destController.game = game;
        
        if ([visiblestats isEqualToString:@"Stats"])
            destController.player = [currentSettings.roster objectAtIndex:indexPath.row];
        else
            destController.player = [currentSettings findAthlete:[[goalies objectAtIndex:indexPath.row] athlete_id]];
    } else if ([segue.identifier isEqualToString:@"PhotosSegue"]) {
        EazePhotosViewController *destController = segue.destinationViewController;
        currentSettings.photodeleted = YES;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"VideosSegue"]) {
        EazesVideosViewController *destController = segue.destinationViewController;
        destController.game = game;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ([visiblestats isEqualToString:@"Stats"])
        return 5;
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([visiblestats isEqualToString:@"Goalie"]) {
        goalies = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < currentSettings.roster.count; i++) {
            Athlete *aplayer = [currentSettings.roster objectAtIndex:i];
            if ([aplayer isHockeyGoalie]) {
                [goalies addObject:aplayer];
            }
        }
        
        return goalies.count;
    } else if ([visiblestats isEqualToString:@"Scoring"]){
        scorings = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < currentSettings.roster.count; i++) {
            Athlete *player = [currentSettings.roster objectAtIndex:i];
            [scorings addObjectsFromArray:[[player findHockeyStat:game] scoring_stats]];
        }
        
        if ([currentSettings isSiteOwner])
            return scorings.count + 1;
        else
            return scorings.count;
    } else if ([visiblestats isEqualToString:@"Penalties"]) {
        penalties = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < currentSettings.roster.count; i++) {
            Athlete *player = [currentSettings.roster objectAtIndex:i];
            [penalties addObjectsFromArray:[[player findHockeyStat:game] penalty_stats]];
        }
        
        if ([currentSettings isSiteOwner])
            return penalties.count + 1;
        else
            return penalties.count;
    } else {
        return currentSettings.roster.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([visiblestats isEqualToString:@"Goalie"]) {
        SoccerPlayerStatsTableCell *cell = [[SoccerPlayerStatsTableCell alloc] init];
        static NSString *CellIdentifier = @"StatsTableCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        if (cell == nil) {
            cell = [[SoccerPlayerStatsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        Athlete *player = [goalies objectAtIndex:indexPath.row];
        cell.label1.text = [player.number stringValue];
        cell.label2.text = player.position;
        cell.label3.text = player.logname;
        cell.label4.text = [[[player findHockeyStat:game] getTotalSaves] stringValue];
        cell.label5.text = [[[player findHockeyStat:game] getTotalGoalsAllowed] stringValue];
        cell.label6.text = [[[player findHockeyStat:game] getTotalMinutes] stringValue];
        
        return cell;
    } else if ([visiblestats isEqualToString:@"Scoring"]) {
        EazesportzLacrosseMinutesStatTableViewCell *cell = [[EazesportzLacrosseMinutesStatTableViewCell alloc] init];
        static NSString *CellIdentifier = @"ScoreTableCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        if (cell == nil) {
            cell = [[EazesportzLacrosseMinutesStatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        if (indexPath.row < scorings.count) {
            HockeyScoring *score = [scorings objectAtIndex:indexPath.row];
            
            if (score.athlete_id.length > 0) {
                Athlete *player = [currentSettings findAthlete:score.athlete_id];
                cell.playerLabel.text = player.logname;
                cell.penaltyLabel.text = @"H";
            }
            
            cell.numberLabel.text = score.gametime;
            
            if (score.assist.length > 0) {
                if (score.athlete_id.length > 0)
                    cell.faceoffLabel.text = [[currentSettings findAthlete:score.assist] logname];
            } else {
                cell.faceoffLabel.text = @"";
            }
            
            cell.positionLabel.text = [score.period stringValue];
            
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
            if ((score.photos.count > 0) || (score.videos.count > 0)) {
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
        } else {
            cell.playerLabel.text = @"Add Score";
            cell.positionLabel.text = @"";
            cell.numberLabel.text = @"";
            cell.faceoffLabel.text = @"";
            cell.penaltyLabel.text = @"";
        }
        
        return cell;
    } else if ([visiblestats isEqualToString:@"Penalties"]) {
        EazesportzLacrosseMinutesStatTableViewCell *cell = [[EazesportzLacrosseMinutesStatTableViewCell alloc] init];
        static NSString *CellIdentifier = @"PenaltyStatsTableCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        if (cell == nil) {
            cell = [[EazesportzLacrosseMinutesStatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        if (indexPath.row < penalties.count) {
            HockeyPenalty *penaltystat = [penalties objectAtIndex:indexPath.row];
            
            if (penaltystat.athlete_id.length > 0) {
                Athlete *player = [currentSettings findAthlete:penaltystat.athlete_id];
                cell.numberLabel.text = [penaltystat.period stringValue];
                cell.playerLabel.text = player.numberLogname;
            }
            
            cell.positionLabel.text = penaltystat.gametime;
            cell.faceoffLabel.text = penaltystat.penaltytime;
            cell.penaltyLabel.text = penaltystat.infraction;
        } else {
            cell.playerLabel.text = @"Add Penalty";
            cell.positionLabel.text = @"";
            cell.numberLabel.text = @"";
            cell.faceoffLabel.text = @"";
            cell.penaltyLabel.text = @"";
        }

        return cell;
    } else {
        EazesportzPlayerStatTableViewCell *cell = [[EazesportzPlayerStatTableViewCell alloc] init];
        static NSString *CellIdentifier = @"PlayerStatTableCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        if (cell == nil) {
            cell = [[EazesportzPlayerStatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        Athlete *player = [currentSettings.roster objectAtIndex:indexPath.row];
        HockeyStat *stats = [player findHockeyStat:game];
        cell.numberLabel.text = [player.number stringValue];
        cell.nameLabel.text = player.logname;
        
        if (indexPath.section == 0) {
            cell.stat1Label.text = [[stats getTotalGoals] stringValue];
            cell.stat2Label.text = [[stats getTotalAssists] stringValue];
            cell.stat3Label.text = [[stats getTotalPoints] stringValue];
            cell.stat4Label.text = @"";
        } else if (indexPath.section == 1) {
            cell.stat1Label.text = [[stats getTotalShots] stringValue];
            cell.stat2Label.text = [[stats getTotalPowerPlayGoals] stringValue];
            cell.stat3Label.text = [[stats getTotalPowerPlayAssists] stringValue];
            cell.stat4Label.text = @"";
        } else if (indexPath.section == 2) {
            cell.stat1Label.text = [[stats getTotalShortHandedGoals] stringValue];
            cell.stat2Label.text = [[stats getTotalShortHandedAssists] stringValue];
            cell.stat3Label.text = [[stats getTotalPenaltyMinutes] stringValue];
            cell.stat4Label.text = [[stats gameWinningGoal] stringValue];
        } else if (indexPath.section == 3) {
            cell.stat1Label.text = [[stats gettotalFaceOffsWon] stringValue];
            cell.stat2Label.text = [[stats getTotalFaceOffsLost] stringValue];
            cell.stat3Label.text = [[stats getTotalTimeOnIce] stringValue];
            cell.stat4Label.text = @"";
        } else {
            cell.stat1Label.text = [[stats getTotalHits] stringValue];
            cell.stat2Label.text = [[stats getTotalBlockedShots] stringValue];
            cell.stat3Label.text = [[stats getTotalPlusMinues] stringValue];
            cell.stat4Label.text = @"";
        }
        
        return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([currentSettings isSiteOwner]) {
        if ([visiblestats isEqualToString:@"Scoring"]) {
            _scoreContainer.hidden = NO;
            scoreStatsController.game = game;
            
            if (indexPath.row < scorings.count)
                scoreStatsController.score = [scorings objectAtIndex:indexPath.row];
            else
                scoreStatsController.score = nil;
            
            [scoreStatsController viewWillAppear:YES];
        } else if ([visiblestats isEqualToString:@"Goalie"]) {
            _goalieContainer.hidden = NO;
            goalieStatsController.game = game;
            goalieStatsController.player = [goalies objectAtIndex:indexPath.row];
        } else if ([visiblestats isEqualToString:@"Penalties"]) {
             _penaltyContainer.hidden = NO;
             penaltyStatsController.game = game;
             
             if (indexPath.row < penalties.count) {
                 penaltyStatsController.penaltystat = [penalties objectAtIndex:indexPath.row];
             } else {
                 penaltyStatsController.penaltystat = nil;
             }
             
             [penaltyStatsController viewWillAppear:YES];
        } else if ([visiblestats isEqualToString:@"Stats"]) {
            _statsContainer.hidden = NO;
            playerStatsController.game = game;
            playerStatsController.player = [currentSettings.roster objectAtIndex:indexPath.row];
            [playerStatsController viewWillAppear:YES];
        }
    } else {
        if (([visiblestats isEqualToString:@"Goalie"]) || ([visiblestats isEqualToString:@"Stats"]))
            [self performSegueWithIdentifier:@"HockeyTotalsSegue" sender:self];
        else if ([visiblestats isEqualToString:@"Scoring"]) {
            HockeyScoring *score = [scorings objectAtIndex:indexPath.row];
            
            if ((score.photos.count > 0) && (score.videos.count > 0)) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Score has Photo's and Video" delegate:self
                                                      cancelButtonTitle:@"Cancel" otherButtonTitles:@"Photo", @"Video", nil];
                [alert show];
            } else if (score.photos.count > 0) {
                [self performSegueWithIdentifier:@"PhotoSegue" sender:self];
            } else {
                [self performSegueWithIdentifier:@"VideoSegue" sender:self];
            }
        } else if ([visiblestats isEqualToString:@"Penalties"]) {
            HockeyPenalty *penaltystat = [penalties objectAtIndex:indexPath.row];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Penalty"
                                                            message:[NSString stringWithFormat:@"%@ - %@ at %@ for %@",
                                                                     [[currentSettings findAthlete:penaltystat.athlete_id] numberLogname],
                                                                                      penaltystat.penaltytime, penaltystat.gametime,
                                                                     [game.hockey_game.hockey_penalties objectForKey:penaltystat.infraction]]
                                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if ([visiblestats isEqualToString:@"Goalie"]) {
        SoccerPlayerStatsTableCell *headerView;
        
        static NSString *CellIdentifier = @"StatsTableHeaderCell";
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        headerView.backgroundColor = [UIColor cyanColor];
        headerView.label1.text = @"No.";
        headerView.label2.text = @"P";
        headerView.label3.text = @"Name";
        headerView.label4.text = @"SV";
        headerView.label5.text = @"G";
        headerView.label6.text = @"Min";
        
        return headerView;
    } else if ([visiblestats isEqualToString:@"Scoring"]) {
        EazesportzLacrosseMinutesStatTableViewCell *headerView;
        static NSString *CellIdentifier = @"ScoreStatTableHeaderCell";
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        headerView.backgroundColor = [UIColor cyanColor];
        headerView.penaltyLabel.text = @"H/V";
        return headerView;
    } else if ([visiblestats isEqualToString:@"Penalties"]) {
        EazesportzLacrosseMinutesStatTableViewCell *headerView;
        static NSString *CellIndentifier = @"PenaltyStatsHeaderCell";
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        headerView.numberLabel.text = @"Per";
        return headerView;
    } else {
        EazesportzPlayerStatTableViewCell *headerView;
        static NSString *CellIdentifier = @"PlayerStatHeaderCell";
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        headerView.backgroundColor = [UIColor cyanColor];
        
        if (section == 0) {
            headerView.stat1Label.text = @"G";
            headerView.stat2Label.text = @"A";
            headerView.stat3Label.text = @"PTS";
            headerView.stat4Label.text = @"";
        } else if (section == 1) {
            headerView.stat1Label.text = @"SOG";
            headerView.stat2Label.text = @"PPG";
            headerView.stat3Label.text = @"PPA";
            headerView.stat4Label.text = @"";
        } else if (section == 2) {
            headerView.stat1Label.text = @"SH";
            headerView.stat2Label.text = @"SHA";
            headerView.stat3Label.text = @"PIM";
            headerView.stat4Label.text = @"GW";
        } else if (section == 3) {
            headerView.stat1Label.text = @"FOW";
            headerView.stat2Label.text = @"FOL";
            headerView.stat3Label.text = @"TOI";
            headerView.stat4Label.text = @"";
        } else {
            headerView.stat1Label.text = @"HIT";
            headerView.stat2Label.text = @"BS";
            headerView.stat3Label.text = @"+/-";
            headerView.stat4Label.text = @"";
        }
        
        return headerView;
    }
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
    if (currentSettings.roster.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"No roster entered. No players to assign stats!\n Either enter a roster or turn off stats for game scheduling by editing the game information.\n Once you turn off stats you can enter the home score above." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    } else {
        visiblestats = @"Scoring";
        [_statsTableView reloadData];
    }
}

- (IBAction)goalieButtonClicked:(id)sender {
    if (currentSettings.roster.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"No roster entered. No players to assign stats!\n Either enter a roster or turn off stats for game scheduling by editing the game information.\n Once you turn off stats you can enter the home score above." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    } else {
        visiblestats = @"Goalie";
        [_statsTableView reloadData];
    }
}

- (IBAction)statsButtonClicked:(id)sender {
    if (currentSettings.roster.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"No roster entered. No players to assign stats!\n Either enter a roster or turn off stats for game scheduling by editing the game information.\n Once you turn off stats you can enter the home score above." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    } else {
        visiblestats = @"Stats";
        [_statsTableView reloadData];
    }
}

- (IBAction)hockeyPlayerstatsDone:(UIStoryboardSegue *)segue {
    _statsContainer.hidden = YES;
    [_statsTableView reloadData];
}

- (IBAction)hockeyScorestatsDone:(UIStoryboardSegue *)segue {
    _scoreContainer.hidden = YES;
    [_statsTableView reloadData];
}

- (IBAction)hockeyGoaliestatsDone:(UIStoryboardSegue *)segue {
    _goalieContainer.hidden = YES;
    [_statsTableView reloadData];
}

- (IBAction)hockeyPenaltystatsDone:(UIStoryboardSegue *)segue {
    _penaltyContainer.hidden = YES;
    [_statsTableView reloadData];
}

- (IBAction)statsInfoBarButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Stats" message:@"G = Goals\n A - Assits\n PTS - Points\n SOG - Shots on Goal\n PPG - Power Play Goals\n PPA - Power Play Assists\n SH - Short Handed Goals\n SHA - Short Handed Assists\n PIM - Penalty Time Minutes\n GW - Game Winning Goals\n FOW - Face Offs Won\n FOL - Face Offs Lost\n TOI - Time on Ice\n HIT - Hits\n BS - Blocked Shots\n +/- - Plus/Minus" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)penaltiesButtonClicked:(id)sender {
    visiblestats = @"Penalties";
    [_statsTableView reloadData];
}

- (IBAction)refreshBarButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statsRetrieved:) name:@"RosterChangedNotification" object:nil];
    [[[EazesportzRetrievePlayers alloc] init] retrievePlayers:currentSettings.sport.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken];
}

- (void)statsRetrieved:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        [_statsTableView reloadData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error updating stats" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

@end
