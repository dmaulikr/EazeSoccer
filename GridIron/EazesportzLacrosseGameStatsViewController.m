//
//  EazesportzLacrosseGameStatsViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/25/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzLacrosseGameStatsViewController.h"
#import "EazesportzLacrosseMinutesStatTableViewCell.h"
#import "LacrossScoring.h"
#import "LacrossPenalty.h"
#import "EazesportzLacrosseScoresheetViewController.h"
#import "EazesportzLacrossePenaltyViewController.h"
#import "EazesportzNumberFieldViewController.h"
#import "EazesportzLacrosseStatsViewController.h"
#import "EazesportzRetrievePlayers.h"
#import "EazePhotosViewController.h"
#import "EazesVideosViewController.h"

@interface EazesportzLacrosseGameStatsViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzLacrosseGameStatsViewController {
    NSIndexPath *deleteIndexPath;
    BOOL extraMan, scoreLog, penalty, clears, home;
    int extramanIndex;
    
    NSArray *gamescoreings, *gamepenalties;
    NSMutableArray *scoreextraman;
    VisitingTeam *visitors;
    
    EazesportzLacrossePenaltyViewController *penatlyController;
    EazesportzNumberFieldViewController *extramanController, *clearsController;
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
    scoreLog = YES;
    home = YES;
    
    scoreextraman = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0],
                     [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ScoreSheetSegue"]) {
        EazesportzLacrosseScoresheetViewController *destController = segue.destinationViewController;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"PenaltySegue"]) {
        penatlyController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"ExtraManSegue"]) {
        extramanController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"ClearSegue"]) {
        clearsController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"PlayerStatsSegue"]) {
        EazesportzLacrosseStatsViewController *destController = segue.destinationViewController;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"PhotosSegue"]) {
        NSIndexPath *indexPath = [_scoreLogTableView indexPathForSelectedRow];
        LacrossScoring *scorestat = [gamescoreings objectAtIndex:indexPath.row];
        
        EazePhotosViewController *destController = segue.destinationViewController;
        destController.lacross_scoring_id = scorestat.lacross_scoring_id;
    } else if ([segue.identifier isEqualToString:@"VideosSegue"]) {
        NSIndexPath *indexPath = [_scoreLogTableView indexPathForSelectedRow];
        LacrossScoring *scorestat = [gamescoreings objectAtIndex:indexPath.row];
        
        EazesVideosViewController *destController = segue.destinationViewController;
        destController.lacross_scoring_id = scorestat.lacross_scoring_id;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _penaltyContainer.hidden = YES;
    _extramanContainer.hidden = YES;
    _clearContainer.hidden = YES;
        
    [_homeBarButton setTitle:currentSettings.team.mascot];
    [_visitorBarButton setTitle:game.opponent_mascot];
    [self createScorePenaltyArray];
    [self createExtraManScoreArray];
    
    [_scoreLogTableView reloadData];
    
    if (currentSettings.isSiteOwner)
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshButton, self.statsButton, self.sheetButton, nil];
    else
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshButton, self.statsButton, nil];
    
}

- (void)createScorePenaltyArray {
    gamescoreings = [[NSMutableArray alloc] init];
    gamepenalties = [[NSMutableArray alloc] init];
    
    if (home) {
        gamescoreings = [game.lacross_game getLacrosseScores:YES];
        gamepenalties = [game.lacross_game getLacrossePenalties:YES];
        
    } else if ((!home) && (game.lacross_game.visiting_team_id.length > 0)) {
        gamescoreings = [game.lacross_game getLacrosseScores:NO];
        gamepenalties = [game.lacross_game getLacrossePenalties:NO];
    }
}

#pragma mark - Navigation

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headertext;
    
    if (scoreLog) {
        headertext = @"Score Log";
    } else if (penalty) {
        headertext = @"Penalties";
    } else if (extraMan) {
        headertext = @"Extra Man";
    } else if (clears) {
        headertext = @"Clears";
    }
    
    if ([currentSettings isSiteOwner])
        return [NSString stringWithFormat:@"%@ - Swipe to Delete", headertext];
    else
        return headertext;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (scoreLog) {
        
        if ([currentSettings isSiteOwner])
            return gamescoreings.count + 1;
        else
            return gamescoreings.count;
        
    } else if (penalty) {
        
        if ([currentSettings isSiteOwner])
            return gamepenalties.count + 1;
        else
            return gamepenalties.count;
        
    } else if (extraMan) {
        return 6;
    } else
        return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    
    if (scoreLog) {
        if (indexPath.row < gamescoreings.count) {
            EazesportzLacrosseMinutesStatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreTableCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor darkGrayColor];
            
            LacrossScoring *thestat = [gamescoreings objectAtIndex:indexPath.row];
            cell.positionLabel.text = [thestat.period stringValue];
            cell.numberLabel.text = thestat.gametime;
            cell.penaltyLabel.text = thestat.scorecode;
            
            if (home) {
                cell.playerLabel.text = [[currentSettings findAthlete:thestat.athlete_id] logname];
                cell.faceoffLabel.text = [[currentSettings findAthlete:thestat.assist] logname];
            } else {
                cell.playerLabel.text = [[visitors findAthlete:thestat.visitor_roster_id] logname];
                cell.faceoffLabel.text = [[visitors findAthlete:thestat.assist] logname];
            }
            
            if ((thestat.photos.count > 0) || (thestat.videos.count > 0)) {
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else
                cell.selectionStyle = UITableViewCellEditingStyleNone;
            
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreTableCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor darkGrayColor];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:12.0];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.text = @"Add Score";
            return cell;
        }
    } else if (penalty) {
        if (indexPath.row < gamepenalties.count) {
            EazesportzLacrosseMinutesStatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PenaltyTableCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor darkGrayColor];
            
            if ([currentSettings isSiteOwner])
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            else
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            LacrossPenalty *thestat = [gamepenalties objectAtIndex:indexPath.row];
            cell.positionLabel.text = thestat.type;
            
            if (home)
                cell.numberLabel.text = [[[currentSettings findAthlete:thestat.athlete_id] number] stringValue];
            else
                cell.numberLabel.text = [[[visitors findAthlete:thestat.athlete_id] number] stringValue];
            
            cell.penaltyLabel.text = thestat.gametime;
            cell.playerLabel.text = thestat.infraction;
            cell.faceoffLabel.text = [thestat.period stringValue];
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PenaltyTableCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor darkGrayColor];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:12.0];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.text = @"Add Penalty";
            return cell;
        }
        
    } else if (extraMan ) {
        EazesportzLacrosseMinutesStatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClearTableCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        if ([currentSettings isSiteOwner])
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        else
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        if (indexPath.row < 5) {
            cell.positionLabel.text = indexPath.row < 4 ? [NSString stringWithFormat:@"%d", indexPath.row + 1] : @"OT";
            cell.numberLabel.text = [NSString stringWithFormat:@"%@", [[scoreextraman objectAtIndex:indexPath.row] stringValue]];
            
            if (home) {
                cell.playerLabel.text = [[game.lacross_game.extraman_fail objectAtIndex:indexPath.row] stringValue];
                cell.faceoffLabel.text = [NSString stringWithFormat:@"%d", [[game.lacross_game.extraman_fail objectAtIndex:indexPath.row] intValue] +
                                          [[scoreextraman objectAtIndex:indexPath.row] intValue]];
            } else {
                cell.playerLabel.text = [[game.lacross_game.visitor_extraman_fail objectAtIndex:indexPath.row] stringValue];
                cell.faceoffLabel.text = [NSString stringWithFormat:@"%d", [[game.lacross_game.visitor_extraman_fail objectAtIndex:indexPath.row] intValue] +
                                          [[scoreextraman objectAtIndex:indexPath.row] intValue]];
            }
        } else {
            cell.positionLabel .text = @"T";
            cell.numberLabel.text = [[scoreextraman valueForKeyPath:@"@sum.self"] stringValue];
            
            int sum = 0;
            
            if (home) {
                for (NSNumber * n in game.lacross_game.extraman_fail) {
                    sum += [n intValue];
                }
            } else {
                for (NSNumber * n in game.lacross_game.visitor_extraman_fail) {
                    sum += [n intValue];
                }
            }
            
            cell.playerLabel.text = [NSString stringWithFormat:@"%d", sum];
            cell.faceoffLabel.text = [NSString stringWithFormat:@"%d", [[scoreextraman valueForKeyPath:@"@sum.self"] intValue] + sum];
        }
        
        return cell;
    } else {
        EazesportzLacrosseMinutesStatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClearTableCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        if ([currentSettings isSiteOwner])
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        else
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        if (indexPath.row < 5) {
            cell.positionLabel.text = indexPath.row < 4 ? [NSString stringWithFormat:@"%d", indexPath.row + 1] : @"OT";
            
            if (home) {
                cell.numberLabel.text = [[game.lacross_game.clears objectAtIndex:indexPath.row] stringValue];
                cell.playerLabel.text = [[game.lacross_game.failedclears objectAtIndex:indexPath.row] stringValue];
                cell.faceoffLabel.text = [NSString stringWithFormat:@"%d", [[game.lacross_game.clears objectAtIndex:indexPath.row] intValue] +
                                          [[game.lacross_game.failedclears objectAtIndex:indexPath.row] intValue]];
            } else {
                cell.numberLabel.text = [[game.lacross_game.visitor_clears objectAtIndex:indexPath.row] stringValue];
                cell.playerLabel.text = [[game.lacross_game.visitor_badclears objectAtIndex:indexPath.row] stringValue];
                cell.faceoffLabel.text = [NSString stringWithFormat:@"%d", [[game.lacross_game.visitor_clears objectAtIndex:indexPath.row] intValue] +
                                          [[game.lacross_game.visitor_badclears objectAtIndex:indexPath.row] intValue]];
            }
        } else {
            cell.positionLabel .text = @"T";
            
            if (home) {
                cell.numberLabel.text = [[game.lacross_game.clears valueForKeyPath:@"@sum.self"] stringValue];
                
                int sum = 0;
                for (NSNumber * n in game.lacross_game.failedclears) {
                    sum += [n intValue];
                }
                
                cell.playerLabel.text = [NSString stringWithFormat:@"%d", sum];
                cell.faceoffLabel.text = [NSString stringWithFormat:@"%d", [[game.lacross_game.clears valueForKeyPath:@"@sum.self"] intValue] + sum];
            } else {
                cell.numberLabel.text = [[game.lacross_game.visitor_clears valueForKeyPath:@"@sum.self"] stringValue];
                
                int sum = 0;
                for (NSNumber * n in game.lacross_game.visitor_badclears) {
                    sum += [n intValue];
                }
                
                cell.playerLabel.text = [NSString stringWithFormat:@"%d", sum];
                cell.faceoffLabel.text = [NSString stringWithFormat:@"%d", [[game.lacross_game.visitor_clears valueForKeyPath:@"@sum.self"] intValue] + sum];
            }
        }
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (scoreLog) {
        LacrossScoring *scorestat = [gamescoreings objectAtIndex:indexPath.row];
        
        if ((scorestat.photos.count > 0) && (scorestat.videos.count > 0)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Media" message:@"Photos and Video" delegate:self
                                                  cancelButtonTitle:@"Cancel" otherButtonTitles:@"Photo", @"Video", nil];
            [alert show];
        } else if (scorestat.photos.count > 0) {
            currentSettings.photodeleted = YES;
            [self performSegueWithIdentifier:@"PhotosSegue" sender:self];
        } else if (scorestat.videos.count > 0) {
            [self performSegueWithIdentifier:@"VideosSegue" sender:self];
        }
    } else if ([currentSettings isSiteOwner]) {
        if(extraMan) {
            if (indexPath.row < 5) {
                _extramanContainer.hidden = NO;
                extramanIndex = indexPath.row;
                extramanController.labelValueTextField.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
                
                if (home)
                    extramanController.numberTextField.text = [[game.lacross_game.extraman_fail objectAtIndex:indexPath.row] stringValue];
                else
                    extramanController.numberTextField.text = [[game.lacross_game.visitor_extraman_fail objectAtIndex:indexPath.row] stringValue];
            }
        } else if (clears) {
            if (indexPath.row < 5) {
                _clearContainer.hidden = NO;
                extramanIndex = indexPath.row;
                clearsController.labelValueTextField.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
                
                if (home) {
                    clearsController.numberTextField.text = [[game.lacross_game.clears objectAtIndex:indexPath.row] stringValue];
                    clearsController.number2TextField.text = [[game.lacross_game.failedclears objectAtIndex:indexPath.row] stringValue];
                } else {
                    clearsController.numberTextField.text = [[game.lacross_game.visitor_clears objectAtIndex:indexPath.row] stringValue];
                    clearsController.number2TextField.text = [[game.lacross_game.visitor_badclears objectAtIndex:indexPath.row] stringValue];
                }
            }
        } else if (penalty) {
            _penaltyContainer.hidden = NO;
            
            if (indexPath.row < gamepenalties.count) {
                penatlyController.penatlyStat = [gamepenalties objectAtIndex:indexPath.row];
            } else {
                penatlyController.penatlyStat = nil;
            }
            
            if (home) {
                penatlyController.visitingTeam = NO;
            } else {
                penatlyController.visitingTeam = YES;
            }
            
            [penatlyController viewWillAppear:YES];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    EazesportzLacrosseMinutesStatTableViewCell *headerView;
    
    if (scoreLog) {
        static NSString *CellIdentifier = @"ScoreStatTableHeaderCell";
        
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UILabel *label = (UILabel *)[headerView viewWithTag:1];
        label.text = @"Per";
        label = (UILabel *)[headerView viewWithTag:2];
        label.text = @"Time";
        label = (UILabel *)[headerView viewWithTag:3];
        label.text = @"Type";
        label = (UILabel *)[headerView viewWithTag:4];
        label.text = @"Scorer";
        label = (UILabel *)[headerView viewWithTag:5];
        label.text = @"Assist";
        
    } else if (penalty) {
        static NSString *CellIdentifier = @"PenaltyStatTableHeaderCell";
        
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UILabel *label = (UILabel *)[headerView viewWithTag:1];
        label.text = @"PT";
        label = (UILabel *)[headerView viewWithTag:2];
        label.text = @"No.";
        label = (UILabel *)[headerView viewWithTag:3];
        label.text = @"Infraction";
        label = (UILabel *)[headerView viewWithTag:4];
        label.text = @"Per";
        label = (UILabel *)[headerView viewWithTag:5];
        label.text = @"Time";
        
    } else if (extraMan) {
        static NSString *CellIdentifier = @"ClearStatTableHeaderCell";
        
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UILabel *label = (UILabel *)[headerView viewWithTag:1];
        label.text = @"Period";
        label = (UILabel *)[headerView viewWithTag:2];
        label.text = @"Score";
        label = (UILabel *)[headerView viewWithTag:3];
        label.text = @"Fail";
        label = (UILabel *)[headerView viewWithTag:4];
        label.text = @"Total";
        
    } else if (clears) {
        static NSString *CellIdentifier = @"ClearStatTableHeaderCell";
        
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UILabel *label = (UILabel *)[headerView viewWithTag:1];
        label.text = @"Period";
        label = (UILabel *)[headerView viewWithTag:2];
        label.text = @"Clear";
        label = (UILabel *)[headerView viewWithTag:3];
        label.text = @"Fail";
        label = (UILabel *)[headerView viewWithTag:4];
        label.text = @"Total";
        
    } else {
        static NSString *CellIdentifier = @"TotalsHeaderCell";
        
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)refreshButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotRoster:) name:@"RosterChangedNotification" object:nil];
    [[EazesportzRetrievePlayers alloc] retrievePlayers:currentSettings.sport.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken];
}

- (void)gotRoster:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        [_scoreLogTableView reloadData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error refreshing stats" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RosterChangedNotification" object:nil];
}

- (IBAction)scoreButtonClicked:(id)sender {
    scoreLog = YES;
    penalty = NO;
    extraMan = NO;
    clears = NO;
    [_scoreLogTableView reloadData];
}

- (IBAction)penaltyButtonClicked:(id)sender {
    penalty = YES;
    scoreLog = NO;
    extraMan = NO;
    clears = NO;
    [_scoreLogTableView reloadData];
}

- (IBAction)extramanButtonClicked:(id)sender {
    extraMan = YES;
    scoreLog = NO;
    penalty = NO;
    clears = NO;
    [_scoreLogTableView reloadData];
}

- (IBAction)clearsButtonClicked:(id)sender {
    clears = YES;
    scoreLog = NO;
    extraMan = NO;
    penalty = NO;
    [_scoreLogTableView reloadData];
}

- (IBAction)homeBarButtonClicked:(id)sender {
    home = YES;
    [self viewWillAppear:YES];
}

- (IBAction)visitorBarButtonClicked:(id)sender {
    if (game.lacross_game.visiting_team_id.length > 0) {
        home = NO;
        [self viewWillAppear:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"No Visiting Team Stats Available" delegate:nil
                                              cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)createExtraManScoreArray {
    for (int period = 0; period < 5; period++) {
        int extramangoals = 0;
        
        if (home) {
            for (int i = 0; i < currentSettings.roster.count; i++) {
                Lacrosstat *astat = [[currentSettings.roster objectAtIndex:i] findLacrosstat:game];
                
                if (astat.scoring_stats.count > 0) {
                    extramangoals += [self numberOfExtraManScores:(period + 1) Scores:astat.scoring_stats];
                }
            }
        } else {
            for (int i = 0; i < visitors.visitor_roster.count; i++) {
                Lacrosstat *astat = [[visitors.visitor_roster objectAtIndex:i] findLacrossStat:game];
                
                if (astat.scoring_stats.count > 0) {
                    extramangoals += [self numberOfExtraManScores:(period + 1) Scores:astat.scoring_stats];
                }
            }
        }
        
        [scoreextraman replaceObjectAtIndex:period withObject:[NSNumber numberWithInt:extramangoals]];
    }
}

- (int)numberOfExtraManScores:(int)period Scores:(NSMutableArray *)scores {
    int numscores = 0;
    
    for (int i = 0; i < scores.count; i++) {
        if (([[scores objectAtIndex:i] isExtraManScore]) && ([[[scores objectAtIndex:i] period] intValue] == period)) {
            numscores++;
        }
    }
    
    return numscores;
}

- (IBAction)saveLacrossePenalty:(UIStoryboardSegue *)segue {
    _penaltyContainer.hidden = YES;
    
    if ((penatlyController.player) && (penatlyController.minutesTextField.text.length > 0) && (penatlyController.secondsTextField.text.length > 0) &&
        (penatlyController.periodTextField.text.length > 0)) {
        penatlyController.penatlyStat.gametime = [NSString stringWithFormat:@"%@:%@", penatlyController.minutesTextField.text,
                                                 penatlyController.secondsTextField.text];
        [penatlyController.penatlyStat save:currentSettings.sport Team:currentSettings.team Gameschedule:game User:currentSettings.user];
    }
    
    Lacrosstat *lacrosstat;

    if (penatlyController.visitingTeam) {
        lacrosstat = [penatlyController.visitor findLacrossStat:game];
        [lacrosstat addPenaltyStat:penatlyController.penatlyStat];
    } else {
        lacrosstat = [penatlyController.player findLacrosstat:game];
        [lacrosstat addPenaltyStat:penatlyController.penatlyStat];
    }
    
    [self createScorePenaltyArray];
    [_scoreLogTableView reloadData];
}

- (IBAction)deleteLacrossePenalty:(UIStoryboardSegue *)segue {
    _penaltyContainer.hidden = YES;
    
    Lacrosstat *thestat;
    
    if (penatlyController.visitingTeam) {
        thestat = [penatlyController.visitor findLacrossStat:game];
    } else {
        thestat = [penatlyController.player findLacrosstat:game];
    }
    
    if (![thestat deleteStat:thestat.lacrosse_penalty Game:game.id Stat:penatlyController.penatlyStat.lacross_penalty_id]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error deleting penalty stat." delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [self createScorePenaltyArray];
    [_scoreLogTableView reloadData];
}

- (IBAction)cancelLacrossePenalty:(UIStoryboardSegue *)segue {
    _penaltyContainer.hidden = YES;
}

- (IBAction)saveLacrosseExtraManFail:(UIStoryboardSegue *)segue {
    _extramanContainer.hidden = YES;
    
    if (home) {
        [game.lacross_game.extraman_fail replaceObjectAtIndex:extramanIndex
                                                   withObject:[NSNumber numberWithInt:[extramanController.numberTextField.text intValue]]];
        [game.lacross_game saveExtraManFails:@"Home"];
    } else {
        [game.lacross_game.visitor_extraman_fail replaceObjectAtIndex:extramanIndex
                                                    withObject:[NSNumber numberWithInt:[extramanController.numberTextField.text intValue]]];
        [game.lacross_game saveExtraManFails:@"Visitor"];
    }
    
    [_scoreLogTableView reloadData];
}

- (void)saveLacrosseClears:(UIStoryboardSegue *)segue {
    _clearContainer.hidden = YES;
    
    if (home) {
        [game.lacross_game.clears replaceObjectAtIndex:extramanIndex
                                                   withObject:[NSNumber numberWithInt:[clearsController.numberTextField.text intValue]]];
        [game.lacross_game.failedclears replaceObjectAtIndex:extramanIndex
                                            withObject:[NSNumber numberWithInt:[clearsController.number2TextField.text intValue]]];
        [game.lacross_game saveClears:@"Home"];
    } else {
        [game.lacross_game.visitor_clears replaceObjectAtIndex:extramanIndex
                                                           withObject:[NSNumber numberWithInt:[clearsController.numberTextField.text intValue]]];
        [game.lacross_game.visitor_badclears replaceObjectAtIndex:extramanIndex
                                                    withObject:[NSNumber numberWithInt:[clearsController.number2TextField.text intValue]]];
        [game.lacross_game saveClears:@"Visitor"];
    }
    
    [_scoreLogTableView reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Add Penalty"]) {
        _penaltyContainer.hidden = NO;
        penatlyController.penatlyStat = nil;
        [penatlyController viewWillAppear:YES];
    } else if ([title isEqualToString:@"Photo"]) {
        currentSettings.photodeleted = YES;
        [self performSegueWithIdentifier:@"PhotosSegue" sender:self];
    } else if ([title isEqualToString:@"Video"]) {
        [self performSegueWithIdentifier:@"VideosSegue" sender:self];
    }
}

@end
