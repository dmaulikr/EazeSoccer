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

@interface EazesportzSoccerGameSummaryViewController ()

@end

@implementation EazesportzSoccerGameSummaryViewController {
    NSString *visiblestats;
    
    NSMutableArray *goalies;
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
    
    NSArray *gametime = [game.currentgametime componentsSeparatedByString:@":"];
    _minutesTextField.text = [gametime objectAtIndex:0];
    _secondsTextField.text = [gametime objectAtIndex:1];
    _periodsTextField.text = [game.period stringValue];
    _visitorSavesTextField.text = [game.socceroppsaves stringValue];
    _visitorCKTextField.text = [game.socceroppck stringValue];
    _visitorShotsTextField.text = [game.socceroppsog stringValue];
    _visitorScoreTextField.text = [game.opponentscore stringValue];
    
    visiblestats = @"Team";
    _hometeamLabel.text = currentSettings.team.mascot;
    _homeimage.image = [currentSettings.team getImage:@"tiny"];
    _visitorteamLabel.text = game.opponent_mascot;
    _vsitorimage.image = [currentSettings getOpponentImage:game];
    
    if (game.editHomeScore)
        _homeScoreTextField.text = [game.homescore stringValue];
    else
        _homeScoreTextField.text = [NSString stringWithFormat:@"%d", [currentSettings teamTotalPoints:game.id]];
    
    _homeCkLabel.text = [NSString stringWithFormat:@"%d", [game soccerHomeCK]];
    _homeshotsLabel.text = [NSString stringWithFormat:@"%d", [game soccerHomeShots]];
    _homesavesLabel.text = [NSString stringWithFormat:@"%d", [game soccerHomeSaves]];
    
    if ([currentSettings isSiteOwner])
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshBarButton, self.saveBarButton, nil];
    else
        self.navigationItem.rightBarButtonItem = self.refreshBarButton;
    
    self.navigationController.toolbarHidden = YES;
    
    [_statTableView reloadData];
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
    } else if ([segue.identifier isEqualToString:@"PlayerStatsSegue"]) {
        EazeSoccerStatsViewController *destController = segue.destinationViewController;
        
        if (indexPath.section == 0)
            destController.athlete = [currentSettings.roster objectAtIndex:indexPath.row];
        else
            destController.athlete = [goalies objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"EditPlayerStatsSegue"]) {
        UpdateSoccerTotalsViewController *destController = segue.destinationViewController;
        destController.game = game;
        destController.player = [currentSettings.roster objectAtIndex:indexPath.row];
    }
}

- (IBAction)teamstatsButtonClicked:(id)sender {
    visiblestats = @"Team";
    [_statTableView reloadData];
}

- (IBAction)playerstatsButtonClicked:(id)sender {
    visiblestats = @"Player";
    [_statTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([visiblestats isEqualToString:@"Team"]) {
        if (section == 0)
            return 5;
        else
            return 3;
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([visiblestats isEqualToString:@"Team"]) {
        EazesportzFootballStatTotalsTableCell *cell = [[EazesportzFootballStatTotalsTableCell alloc] init];
        static NSString *CellIdentifier = @"TotalsStatsTableCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        if (cell == nil) {
            cell = [[EazesportzFootballStatTotalsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        if (indexPath.section == 0) {
            int goals = 0, shots = 0, assists = 0, steals = 0, cornerkicks = 0;
            
            for (int i = 0; i < currentSettings.roster.count; i++) {
                Soccer *astat = [[currentSettings.roster objectAtIndex:i] findSoccerGameStats:game.id];
                goals += [astat.goals intValue];
                shots += [astat.shotstaken intValue];
                assists += [astat.assists intValue];
                steals += [astat.steals intValue];
                cornerkicks += [astat.cornerkicks intValue];
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
                default:
                    cell.statTitleLabel.text = @"Corner Kicks";
                    cell.statLabel.text = [NSString stringWithFormat:@"%d", cornerkicks];
                    break;
            }
        } else {
            int goalssaved = 0, goalsagainst = 0, minutesplayed = 0;
            
            for (int i = 0; i < goalies.count; i++) {
                Soccer *astat = [[goalies objectAtIndex:i] findSoccerGameStats:game.id];
                goalsagainst += [astat.goalsagainst intValue];
                goalssaved += [astat.goalssaved intValue];
                minutesplayed += [astat.minutesplayed intValue];
            }
            
            switch (indexPath.row) {
                case 0:
                    cell.statTitleLabel.text = @"Goals Against";
                    cell.statLabel.text = [NSString stringWithFormat:@"%d", goalsagainst];
                    break;
                case 1:
                    cell.statTitleLabel.text = @"Goals Saved";
                    cell.statLabel.text = [NSString stringWithFormat:@"%d", goalssaved];
                    break;
                 default:
                    cell.statTitleLabel.text = @"Minutes Played";
                    cell.statLabel.text = [NSString stringWithFormat:@"%d", minutesplayed];
                    break;
            }
        }
        return cell;
    } else {
        EazesportzStatTableHeaderCell *cell = [[EazesportzStatTableHeaderCell alloc] init];
        static NSString *CellIdentifier = @"StatTableCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        if (cell == nil) {
            cell = [[EazesportzStatTableHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        Soccer *stats;
        
        if (indexPath.section == 0) {
            Athlete *player = [currentSettings.roster objectAtIndex:indexPath.row];
            cell.playerLabel.text = player.logname;
            stats = [player findSoccerGameStats:game.id];
            cell.label1.text = [stats.goals stringValue];
            cell.label2.text = [stats.shotstaken stringValue];
            cell.label3.text = [stats.assists stringValue];
            cell.label4.text = [stats.steals stringValue];
            cell.label5.text = [stats.cornerkicks stringValue];
            cell.label6.text = [NSString stringWithFormat:@"%d", ([stats.goals intValue] * 2) + [stats.assists intValue]];
        } else {
            Athlete *player = [goalies objectAtIndex:indexPath.row];
            cell.playerLabel.text = player.logname;
            stats = [player findSoccerGameStats:game.id];
            cell.label1.text = @"";
            cell.label2.text = @"";
            cell.label3.text = @"";
            cell.label4.text = [stats.goalsagainst stringValue];
            cell.label5.text = [stats.goalssaved stringValue];
            cell.label6.text = [stats.minutesplayed stringValue];
        }
        return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([visiblestats isEqualToString:@"Player"]) {
        if (indexPath.row < currentSettings.roster.count) {
            if ([currentSettings isSiteOwner])
                 [self performSegueWithIdentifier:@"EditPlayerStatsSegue" sender:self];
           else
                [self performSegueWithIdentifier:@"PlayerStatsSegue" sender:self];
        } else if (indexPath.row < goalies.count) {
            if ([currentSettings isSiteOwner])
                [self performSegueWithIdentifier:@"EditPlayerStatsSegue" sender:self];
            else
                [self performSegueWithIdentifier:@"PlayerStatsSegue" sender:self];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *headerView;
    
    if ([visiblestats isEqualToString:@"Player"]) {
        static NSString *CellIdentifier = @"StatTableHeaderCell";
        
        if (section == 0) {
            headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            headerView.backgroundColor = [UIColor cyanColor];
            UILabel *label = (UILabel *)[headerView viewWithTag:1];
            label.text = @"G";
            label = (UILabel *)[headerView viewWithTag:2];
            label.text = @"AST";
            label = (UILabel *)[headerView viewWithTag:3];
            label.text = @"SHT";
            label = (UILabel *)[headerView viewWithTag:4];
            label.text = @"STL";
            label = (UILabel *)[headerView viewWithTag:5];
            label.text = @"C/K";
            label = (UILabel *)[headerView viewWithTag:6];
            label.text = @"PTS";
        } else {
            headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            headerView.backgroundColor = [UIColor cyanColor];
            UILabel *label = (UILabel *)[headerView viewWithTag:1];
            label.text = @"";
            label = (UILabel *)[headerView viewWithTag:2];
            label.text = @"";
            label = (UILabel *)[headerView viewWithTag:3];
            label.text = @"";
            label = (UILabel *)[headerView viewWithTag:4];
            label.text = @"GA";
            label = (UILabel *)[headerView viewWithTag:5];
            label.text = @"GS";
            label = (UILabel *)[headerView viewWithTag:6];
            label.text = @"MIN";
            label = (UILabel *)[headerView viewWithTag:9];
            label.text = @"Goalie";
        }
        
    } else {
        static NSString *CellIdentifier = @"TotalsHeaderCell";
        
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        headerView.backgroundColor = [UIColor cyanColor];
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
    game.socceroppsog = [NSNumber numberWithInt:[_visitorShotsTextField.text intValue]];
    game.socceroppsaves = [NSNumber numberWithInt:[_visitorSavesTextField.text intValue]];
    game.socceroppck = [NSNumber numberWithInt:[_visitorCKTextField.text intValue]];
    game.currentgametime = [NSString stringWithFormat:@"%@:%@", _minutesTextField.text, _secondsTextField.text];
    game.period = [NSNumber numberWithInt:[_periodsTextField.text intValue]];
    game.opponentscore = [NSNumber numberWithInt:[_visitorScoreTextField.text intValue]];
    [game saveGameschedule];
}

- (IBAction)teamstatsBarButtonClicked:(id)sender {
    [self teamstatsButtonClicked:sender];
}

- (IBAction)playerstatsBarButtonClicked:(id)sender {
    [self playerstatsButtonClicked:sender];
}

@end
