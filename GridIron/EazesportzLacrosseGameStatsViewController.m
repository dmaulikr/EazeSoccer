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

@interface EazesportzLacrosseGameStatsViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzLacrosseGameStatsViewController {
    NSIndexPath *deleteIndexPath;
    BOOL extraMan, scoreLog, penalty, clears, home;
    int extramanIndex;
    
    NSMutableArray *gamescoreings, *gamepenalties, *scoreextraman;
    VisitingTeam *visitors;
    
    EazesportzLacrossePenaltyViewController *penatlyController;
    EazesportzNumberFieldViewController *numberTextFieldController;
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
        numberTextFieldController = segue.destinationViewController;
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
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshButton, self.statsButton, self.sheetButton, self.saveButton, nil];
    else
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshButton, self.statsButton, nil];
    
}

- (void)createScorePenaltyArray {
    gamescoreings = [[NSMutableArray alloc] init];
    gamepenalties = [[NSMutableArray alloc] init];
    
    if (home) {
        for (int i = 0; i < currentSettings.roster.count; i++) {
            Lacrosstat *astat = [[currentSettings.roster objectAtIndex:i] findLacrosstat:game];
            
            if (astat.scoring_stats.count > 0) {
                for (int cnt = 0; cnt < astat.scoring_stats.count; cnt++) {
                    [gamescoreings addObject:[astat.scoring_stats objectAtIndex:cnt]];
                }
            }
            
            if (astat.penalty_stats.count > 0) {
                for (int cnt = 0; cnt < astat.penalty_stats.count; cnt++)
                    [gamepenalties addObject:[astat.penalty_stats objectAtIndex:cnt]];
            }
        }
    } else if ((!home) && (game.lacross_game.visiting_team_id.length > 0)) {
        visitors = [currentSettings findVisitingTeam:game.lacross_game.visiting_team_id];
        
        for (int i = 0; i < visitors.visitor_roster.count; i++) {
            Lacrosstat *astat = [[visitors.visitor_roster objectAtIndex:i] findLacrossStat:game];
            
            if (astat) {
                if (astat.scoring_stats.count > 0) {
                    for (int cnt = 0; cnt < astat.scoring_stats.count; cnt++) {
                        [gamescoreings addObject:[astat.scoring_stats objectAtIndex:cnt]];
                    }
                }
                
                if (astat.penalty_stats.count > 0) {
                    for (int cnt = 0; cnt < astat.penalty_stats.count; cnt++)
                        [gamepenalties addObject:[astat.penalty_stats objectAtIndex:cnt]];
                }
            }
        }
    }
    
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"period" ascending:YES];
    NSSortDescriptor *secondDescriptor = [[NSSortDescriptor alloc] initWithKey:@"gametime" ascending:NO
                                                                      selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *descriptors = [NSArray arrayWithObjects:firstDescriptor, secondDescriptor, nil];
    [gamescoreings sortUsingDescriptors:descriptors];
    
    firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"period" ascending:YES];
    secondDescriptor = [[NSSortDescriptor alloc] initWithKey:@"gametime" ascending:NO
                                                    selector:@selector(localizedCaseInsensitiveCompare:)];
    descriptors = [NSArray arrayWithObjects:firstDescriptor, secondDescriptor, nil];
    [gamepenalties sortedArrayUsingDescriptors:descriptors];
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
        return gamescoreings.count;
    } else if (penalty) {
        if ((gamepenalties.count == 0) && ([currentSettings isSiteOwner])) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"No Penaltes. Click Add Penalty to add." delegate:self
                                                  cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Penalty", nil];
            [alert show];
        }
        
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
        EazesportzLacrosseMinutesStatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreTableCell" forIndexPath:indexPath];
        
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
        
        return cell;
    } else if (penalty) {
        EazesportzLacrosseMinutesStatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PenaltyTableCell" forIndexPath:indexPath];
        
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
    } else if (extraMan ) {
        EazesportzLacrosseMinutesStatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClearTableCell" forIndexPath:indexPath];
        
        if (indexPath.row < 5) {
            cell.positionLabel.text = indexPath.row < 4 ? [NSString stringWithFormat:@"%ld", indexPath.row + 1] : @"OT";
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
        LacrossScoring *thestat = [gamescoreings objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"ScoreSheetSegue" sender:self];
    } else if (extraMan) {
        if (indexPath.row < 5) {
            _extramanContainer.hidden = NO;
            extramanIndex = indexPath.row;
            numberTextFieldController.labelValueTextField.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
            
            if (home)
                numberTextFieldController.numberTextField.text = [[game.lacross_game.extraman_fail objectAtIndex:indexPath.row] stringValue];
            else
                numberTextFieldController.numberTextField.text = [[game.lacross_game.visitor_extraman_fail objectAtIndex:indexPath.row] stringValue];
            
        }
    } else if (clears) {
        
    } else if (penalty) {
        _penaltyContainer.hidden = NO;
        penatlyController.penatlyStat = [gamepenalties objectAtIndex:indexPath.row];
        
        if (home) {
            penatlyController.visitingTeam = NO;
        } else {
            penatlyController.visitingTeam = YES;
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
}

- (IBAction)saveButtonClicked:(id)sender {
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
    
    if (penatlyController.player) {
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

- (IBAction)saveLacrosseExtraManFail:(UIStoryboardSegue *)segue {
    _extramanContainer.hidden = YES;
    
    if (home) {
        [game.lacross_game.extraman_fail replaceObjectAtIndex:extramanIndex
                                                   withObject:[NSNumber numberWithInt:[numberTextFieldController.numberTextField.text intValue]]];
        [game.lacross_game saveExtraManFails:@"Home"];
    } else {
        [game.lacross_game.visitor_extraman_fail replaceObjectAtIndex:extramanIndex
                                                    withObject:[NSNumber numberWithInt:[numberTextFieldController.numberTextField.text intValue]]];
        [game.lacross_game saveExtraManFails:@"Visitor"];
    }
    
    [_scoreLogTableView reloadData];
}

- (void)saveLacrosseClears:(UIStoryboardSegue *)segue {
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Add Penalty"]) {
        _penaltyContainer.hidden = NO;
        penatlyController.penatlyStat = nil;
        [penatlyController viewWillAppear:YES];
    } else if ([title isEqualToString:@"Add Clear"]) {
        
    }
}

@end
