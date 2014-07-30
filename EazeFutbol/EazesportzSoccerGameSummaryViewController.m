//
//  EazesportzSoccerGameSummaryViewController.m
//  EazeSportz
//
//  Created by Gil on 11/12/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzSoccerGameSummaryViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazeSoccerStatsViewController.h"
#import "EazesportzRetrievePlayers.h"
#import "EazesportzFootballStatsTableViewCell.h"
#import "EazesportzFootballStatTotalsTableCell.h"
#import "EazesportzStatTableHeaderCell.h"
#import "EazesportzRetrieveAlerts.h"
#import "UpdateSoccerTotalsViewController.h"
#import "EazesportzSoccerScoreSheetViewController.h"

@interface EazesportzSoccerGameSummaryViewController ()

@end

@implementation EazesportzSoccerGameSummaryViewController {
    BOOL visitors;
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
    
    _minutesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _secondsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorScoreTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorCKTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorShotsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorSavesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _periodsTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self textFieldConfiguration:_secondsTextField];
    [self textFieldConfiguration:_minutesTextField];
    [self textFieldConfiguration:_visitorScoreTextField];
    [self textFieldConfiguration:_visitorCKTextField];
    [self textFieldConfiguration:_visitorShotsTextField];
    [self textFieldConfiguration:_visitorSavesTextField];
    [self textFieldConfiguration:_periodsTextField];
    [self textFieldConfiguration:_homeScoreTextField];
    
    [_homeButton setTitle:currentSettings.team.mascot forState:UIControlStateNormal];
    [_visitorButton setTitle:game.opponent_mascot forState:UIControlStateNormal];
    
    if (game.soccer_game.visiting_team_id.length > 0) {
        _visitorButton.enabled = YES;
        _visitorSavesTextField.enabled = NO;
        _visitorCKTextField.enabled = NO;
        _visitorShotsTextField.enabled = NO;
        _visitorScoreTextField.enabled = NO;
    } else {
//        _visitorButton.enabled = NO;
        _visitorSavesTextField.enabled = YES;
        _visitorCKTextField.enabled = YES;
        _visitorShotsTextField.enabled = YES;
        _visitorScoreTextField.enabled = YES;
    }
    
    _visitorSavesTextField.text = [game.soccer_game.soccergame_visitorsaves stringValue];
    _visitorCKTextField.text = [game.soccer_game.soccergame_visitorcornerkicks stringValue];
    _visitorShotsTextField.text = [game.soccer_game.soccer_visitor_shots stringValue];
    _visitorScoreTextField.text = [game.soccer_game.soccergame_visitor_score stringValue];
    
    _hometeamLabel.text = currentSettings.team.mascot;
    _homeimage.image = [currentSettings.team getImage:@"tiny"];
    _visitorteamLabel.text = game.opponent_mascot;
    _vsitorimage.image = [currentSettings getOpponentImage:game];
    
    NSArray *gametime = [game.currentgametime componentsSeparatedByString:@":"];
    _minutesTextField.text = [gametime objectAtIndex:0];
    _secondsTextField.text = [gametime objectAtIndex:1];
    _periodsTextField.text = [game.period stringValue];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    _gameSummaryDateLabel.text = [dateFormat stringFromDate:game.gamedatetime];
    _gameSmmaryHomeTeamLabel.text = currentSettings.team.mascot;
    _gameSummaryVisitorTeamLabel.text = game.opponent_mascot;
    
    _gameSummaryHomePeriodOneLabel.text = [game.soccer_game.soccergame_home_score_period1 stringValue];
    _gameSummaryHomePeriodTwoLabel.text = [game.soccer_game.soccergame_home_score_period2 stringValue];
    _gameSummaryHomeOT1Label.text = [game.soccer_game.soccergame_home_score_periodOT1 stringValue];
    _gameSummaryHomeOT2Label.text = [game.soccer_game.soccergame_home_score_periodOT2 stringValue];
    _gameSummaryHomeFinalLabel.text = [game.soccer_game.soccergame_home_score stringValue];
    
    
//    if (game.editHomeScore)
        _homeScoreTextField.text = [game.soccer_game.soccergame_home_score stringValue];
//    else
//        _homeScoreTextField.text = [NSString stringWithFormat:@"%d", [currentSettings teamTotalPoints:game.id]];
    
    _gameSummaryVisitorPeriodOneLabel.text = [game.soccer_game.soccergame_visitor_score_period1 stringValue];
    _gameSummaryVisitorPeriodTwoLabel.text = [game.soccer_game.soccergame_visitor_score_period2 stringValue];
    _gameSummaryVisitorOT1Label.text = [game.soccer_game.soccergame_visitor_score_periodOT1 stringValue];
    _gameSummaryVisitorOT2Label.text = [game.soccer_game.soccergame_visitor_score_periodOT2 stringValue];
    _gameSummaryVisitorFinalLabel.text = [game.soccer_game.soccergame_visitor_score stringValue];
    
    _homeCkLabel.text = [NSString stringWithFormat:@"%d", [game soccerHomeCK]];
    _homeshotsLabel.text = [NSString stringWithFormat:@"%d", [game soccerHomeShots]];
    _homesavesLabel.text = [NSString stringWithFormat:@"%d", [game soccerHomeSaves]];
    
    if ([currentSettings isSiteOwner])
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshBarButton, self.saveBarButton, self.statsBarButton, nil];
    else
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshBarButton, self.statsBarButton, nil];
    
    self.navigationController.toolbarHidden = YES;
    
    [_statTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)refreshButtonClicked:(id)sender {
    [[[EazesportzRetrievePlayers alloc] init] retrievePlayers:currentSettings.sport.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken];
    game = [currentSettings retrieveGame:game.id];
    
    if (currentSettings.user.userid.length > 0) {
        [[[EazesportzRetrieveAlerts alloc] init] retrieveAlerts:currentSettings.sport.id Team:currentSettings.team.teamid
                                                          Token:currentSettings.user.authtoken];
    }
    
    [self viewWillAppear:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [_statTableView indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"GameStatsSegue"]) {
        EazeSoccerStatsViewController *destController = segue.destinationViewController;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"EditPlayerStatsSegue"]) {
        UpdateSoccerTotalsViewController *destController = segue.destinationViewController;
        destController.game = game;
        destController.player = [currentSettings.roster objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"SoccerScoreSheetSegue"]) {
        EazesportzSoccerScoreSheetViewController *destController = segue.destinationViewController;
        destController.game = game;
        destController.isVisitingTeam = visitors;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
// Return the number of rows in the section.
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EazesportzFootballStatTotalsTableCell *cell = [[EazesportzFootballStatTotalsTableCell alloc] init];
    static NSString *CellIdentifier = @"TotalsStatsTableCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[EazesportzFootballStatTotalsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor darkGrayColor];
    
    int goals = 0, shots = 0, assists = 0, steals = 0, cornerkicks = 0, goalssaved = 0, goalsagainst = 0;
    
    for (int i = 0; i < currentSettings.roster.count; i++) {
        SoccerStat *soccerstat = [[currentSettings.roster objectAtIndex:i] getSoccerGameStat:game.soccer_game.soccer_game_id];
        goals += soccerstat.scoring_stats.count;
        shots += [[soccerstat getTotalShots] intValue];
        assists += [[soccerstat getTotalAssists] intValue];
        steals += [[soccerstat getTotalSteals] intValue];
        cornerkicks += [[soccerstat getTotalCornerKicks] intValue];
        goalsagainst += [[soccerstat getTotalGoalsAllowed] intValue];
        goalssaved += [[soccerstat getTotalSaves] intValue];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.statTitleLabel.text = @"Goals";
            cell.statLabel.text = [NSString stringWithFormat:@"%d", goals];
            break;
        case 1:
            cell.statTitleLabel.text = @"Shots";
            cell.statLabel.text = [NSString stringWithFormat:@"%d", shots];
            break;
        case 2:
            cell.statTitleLabel.text = @"Assists";
            cell.statLabel.text = [NSString stringWithFormat:@"%d", assists];
            break;
        case 3:
            cell.statTitleLabel.text = @"Steals";
            cell.statLabel.text = [NSString stringWithFormat:@"%d", steals];
            break;
        case 4:
            cell.statTitleLabel.text = @"Corner Kicks";
            cell.statLabel.text = [NSString stringWithFormat:@"%d", cornerkicks];
            break;
        case 5:
            cell.statTitleLabel.text = @"Goals Against";
            cell.statLabel.text = [NSString stringWithFormat:@"%d", goalsagainst];
            break;
        default:
            cell.statTitleLabel.text = @"Goals Saved";
            cell.statLabel.text = [NSString stringWithFormat:@"%d", goalssaved];
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *headerView;
    
    static NSString *CellIdentifier = @"TotalsHeaderCell";
    
    headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    headerView.backgroundColor = [UIColor cyanColor];
    
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

- (void)textFieldConfiguration:(UITextField *)textField {
    if (currentSettings.isSiteOwner) {
        if (textField == _homeScoreTextField) {
            if (game.editHomeScore) {
                textField.enabled = YES;
                textField.backgroundColor = [UIColor whiteColor];
                textField.textColor = [UIColor blackColor];
            } else {
                textField.enabled = NO;
                textField.backgroundColor = [UIColor blackColor];
                textField.textColor = [UIColor yellowColor];
            }
        } else {
            textField.enabled = YES;
            textField.backgroundColor = [UIColor whiteColor];
            textField.textColor = [UIColor blackColor];
        }
    } else {
        textField.enabled = NO;
        textField.backgroundColor = [UIColor blackColor];
        textField.textColor = [UIColor yellowColor];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
    NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
    
    if (myStringMatchesRegEx) {
        return YES;
    } else
        return NO;
}

- (void)textFieldWillBeginEditing:(UITextField *)textFied {
    textFied.text = @"";
}

- (IBAction)saveBarButtonClicked:(id)sender {
    if (game.soccer_game.soccer_game_id.length > 0) {
        game.soccer_game.socceroppsaves = [NSNumber numberWithInt:[_visitorSavesTextField.text intValue]];
        game.soccer_game.socceroppsog = [NSNumber numberWithInt:[_visitorShotsTextField.text intValue]];
        game.soccer_game.socceroppck = [NSNumber numberWithInt:[_visitorCKTextField.text intValue]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(soccerGameSaved:) name:@"SoccerGameStatNotification" object:nil];
        [game.soccer_game saveSoccerGame];
    } else {
        game.socceroppsog = [NSNumber numberWithInt:[_visitorShotsTextField.text intValue]];
        game.socceroppsaves = [NSNumber numberWithInt:[_visitorSavesTextField.text intValue]];
        game.socceroppck = [NSNumber numberWithInt:[_visitorCKTextField.text intValue]];
        [self saveGameData];
    }
}

- (void)soccerGameSaved:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        [self saveGameData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error saving game data!" delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SoccerGameStatNotification" object:nil];
}

- (void)saveGameData {
    game.currentgametime = [NSString stringWithFormat:@"%@:%@", _minutesTextField.text, _secondsTextField.text];
    game.period = [NSNumber numberWithInt:[_periodsTextField.text intValue]];
    game.opponentscore = [NSNumber numberWithInt:[_visitorScoreTextField.text intValue]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameSaved:) name:@"GameSavedNotification" object:nil];
    [game saveGameschedule];
}

- (void)gameSaved:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Game Saved!" delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error saving game data!" delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GameSavedNotification" object:nil];
}

- (IBAction)homeButtonClicked:(id)sender {
    visitors = NO;
}
            
- (IBAction)visitorButtonClicked:(id)sender {
//    visitors = YES;
}
            
@end
