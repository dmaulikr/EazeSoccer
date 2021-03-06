//
//  EazeBasketballGameSummaryViewController.m
//  EazeSportz
//
//  Created by Gil on 11/16/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazeBasketballGameSummaryViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazeBasketballStatsViewController.h"
#import "EazesportzRetrievePlayers.h"
#import "EazesportzFootballStatTotalsTableCell.h"
#import "EazesportzStatTableHeaderCell.h"
#import "EazeBballPlayerStatsViewController.h"
#import "EazesportzRetrieveAlerts.h"
#import "EazeBasketballScoringStatsViewController.h"
#import "EazesportzBasketballScoreSheetViewController.h"


@interface EazeBasketballGameSummaryViewController () <UIAlertViewDelegate>

@end

@implementation EazeBasketballGameSummaryViewController {
    NSString *visiblestats;
    int responseStatusCode;
    NSDictionary *serverData;
    NSMutableData *theData;
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
    self.view.backgroundColor = [UIColor clearColor];
    _minutesTextField.keyboardType = UIKeyboardTypeNumberPad;
    _secondsTextfield.keyboardType = UIKeyboardTypeNumberPad;
    _periodTextField.keyboardType = UIKeyboardTypeNumberPad;
    _homeFoulsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorFoulsTextField.keyboardType = UIKeyboardTypeNumberPad;
    _visitorScoreTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    [self textFieldConfiguration:_minutesTextField];
    [self textFieldConfiguration:_secondsTextfield];
    [self textFieldConfiguration:_periodTextField];
    [self textFieldConfiguration:_homeFoulsTextField];
    [self textFieldConfiguration:_visitorFoulsTextField];
    [self textFieldConfiguration:_visitorScoreTextField];
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
    
    if ([currentSettings isSiteOwner])
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshButton, self.saveBarButton, self.messageBarButton, self.scoreBarButton, nil];
    else
        self.navigationItem.rightBarButtonItem = self.refreshButton;
    
    self.navigationController.toolbarHidden = YES;
    
    [self textFieldConfiguration:_secondsTextfield];
    [self textFieldConfiguration:_minutesTextField];
    [self textFieldConfiguration:_visitorScoreTextField];
    [self textFieldConfiguration:_homeScoreTextField];
    [self textFieldConfiguration:_visitorFoulsTextField];
    [self textFieldConfiguration:_homeFoulsTextField];
    [self textFieldConfiguration:_periodTextField];

    if (![currentSettings isSiteOwner]) {
        _homePossessionArrowButton.enabled = NO;
        _visitorPossessionArrowButton.enabled = NO;
        _homeBonusButton.enabled = NO;
        [_homeBonusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _visitorBonusButton.enabled = NO;
        [_visitorBonusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        _homePossessionArrowButton.enabled = YES;
        _visitorPossessionArrowButton.enabled = YES;
        _homeBonusButton.enabled = YES;
        [_homeBonusButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _visitorBonusButton.enabled = YES;
        [_visitorBonusButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    
    visiblestats = @"Team";
    
    NSArray *gametime = [game.currentgametime componentsSeparatedByString:@":"];
    _minutesTextField.text = [gametime objectAtIndex:0];
    _secondsTextfield.text = [gametime objectAtIndex:1];
    _homeFoulsTextField.text = [NSString stringWithFormat:@"%d", [game homeBasketballFouls]];
    _visitorFoulsTextField.text = [game.visitorfouls stringValue];
    _periodTextField.text = [game.period stringValue];
    _visitorScoreTextField.text = [game.opponentscore stringValue];
    
    _hometeamLabelText.text = currentSettings.team.mascot;
    _visitorLabelText.text = game.opponent_mascot;
    
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) {
        _hometeamImage.image = [currentSettings.team getImage:@"tiny"];
        _visitorTeamImage.image = [currentSettings getOpponentImage:game];
    } else {
        _hometeamImage.image = [currentSettings.team getImage:@"thumb"];
        _visitorTeamImage.image = [currentSettings getOpponentImage:game];
    }
    
    
    if ([game.possession isEqualToString:@"Home"]) {
        _homePossessionArrowButton.hidden = NO;
        _visitorPossessionArrowButton.hidden = YES;
    } else {
        _homePossessionArrowButton.hidden = YES;
        _visitorPossessionArrowButton.hidden = NO;
    }
    
    if (game.homebonus) {
        _homeBonusImage.hidden = NO;
        _visitorBonusImage.hidden = YES;
    } else if (game.visitorbonus) {
        _homeBonusImage.hidden = YES;
        _visitorBonusImage.hidden = NO;
    }
    
    if (game.editHomeScore)
        _homeScoreTextField.text = [game.homescore stringValue];
    else
        _homeScoreTextField.text = [NSString stringWithFormat:@"%d", [currentSettings teamTotalPoints:game.id]];
    
    [_statTableView reloadData];
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

- (IBAction)refreshButtonClicked:(id)sender {
    [currentSettings retrieveGame:game.id];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotRoster:) name:@"RosterChangedNotification" object:nil];
    
    [[[EazesportzRetrievePlayers alloc] init] retrievePlayers:currentSettings.sport.id Team:currentSettings.team.teamid
                                                        Token:currentSettings.user.authtoken];
    
    if (currentSettings.user.userid.length > 0) {
        [[[EazesportzRetrieveAlerts alloc] init] retrieveAlerts:currentSettings.sport.id Team:currentSettings.team.teamid
                                                          Token:currentSettings.user.authtoken];
    }
}

- (void)gotRoster:(NSNotification *)notification {
    [self viewWillAppear:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GameStatsSegue"]) {
        EazeBasketballStatsViewController *destController = segue.destinationViewController;
        destController.game = game;
    } else if ([segue.identifier isEqualToString:@"PlayerStatsSegue"]) {
        NSIndexPath *indexPath = [_statTableView indexPathForSelectedRow];
        
        if (indexPath.row < currentSettings.roster.count) {
            EazeBballPlayerStatsViewController *destController = segue.destinationViewController;
            destController.player = [currentSettings.roster objectAtIndex:indexPath.row];
        }
    } else if ([segue.identifier isEqualToString:@"EditPointsBasketballStatsSegue"]) {
        NSIndexPath *indexPath = [_statTableView indexPathForSelectedRow];
        if (indexPath.row < currentSettings.roster.count) {
            EazeBasketballScoringStatsViewController *destController = segue.destinationViewController;
            destController.game = game;
            destController.player = [currentSettings.roster objectAtIndex:indexPath.row];
        }
    } else if ([segue.identifier isEqualToString:@"ScoreSheetSegue"]) {
        EazesportzBasketballScoreSheetViewController *destController = segue.destinationViewController;
        destController.game = game;
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
    if ([visiblestats isEqualToString:@"Team"]) {
        return 9;
    } else {
        return currentSettings.roster.count;
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
        
        BasketballStats *astat;
        int fgm = 0, fga = 0, threefgm = 0, threefga = 0, ftm = 0, fta = 0, points = 0, assist = 0, steals = 0, turnovers = 0, blocks = 0, fouls = 0;
        float fgp = 0.0, threefgp = 0.0, ftp = 0.0;
        
        for (int i = 0; i < currentSettings.roster.count; i++) {
             astat = [[currentSettings.roster objectAtIndex:i] findBasketballGameStatEntries:game.id];
            
            fgm += [astat.twomade intValue];
            fga += [astat.twoattempt intValue];
            
            threefga += [astat.threeattempt intValue];
            threefgm += [astat.threemade intValue];
            
            ftm += [astat.ftmade intValue];
            fta += [astat.ftattempt intValue];
            
            if ([astat.ftmade intValue] > 0)
            
            points += ([astat.threemade intValue] * 3) + ([astat.twomade intValue] * 2) + [astat.ftmade intValue];
            assist += [astat.assists intValue];
            blocks += [astat.blocks intValue];
            turnovers += [astat.turnovers intValue];
            fouls += [astat.fouls intValue];
        }
        
        if (fga > 0)
            fgp = (float)fgm/(float)fga;
        else
            fgp = 0;
        
        
        if (threefga > 0)
            threefgp = (float)threefgm/(float)threefga;
        else
            threefgp = 0;
        
        if (ftp > 0)
            ftp = (float)ftm/(float)fta;
        else
            ftp = 0;
        
        switch (indexPath.row) {
            case 0:
                cell.statTitleLabel.text = @"FG Made/Attempted";
                cell.statLabel.text = [NSString stringWithFormat:@"%d%@%d%@%.02f%@", fgm, @"/", fga, @"(", fgp, @")"];
                break;
            case 1:
                cell.statTitleLabel.text = @"3PT Made/Atempted";
                cell.statLabel.text = [NSString stringWithFormat:@"%d%@%d%@%.02f%@", threefgm, @"/", threefga, @"(", threefgp, @")"];
                break;
            case 2:
                cell.statTitleLabel.text = @"FT Made/Attempted";
                cell.statLabel.text = [NSString stringWithFormat:@"%d%@%d%@%.02f%@", ftm, @"/", fta, @"(", ftp, @")"];
                break;
            case 3:
                cell.statTitleLabel.text = @"Rebounds(Off/Def)";
                cell.statLabel.text = [NSString stringWithFormat:@"%d%@%d%@%.02f%@", ftm, @"/", fta, @"(", ftp, @")"];
                break;
            case 4:
                cell.statTitleLabel.text = @"Assists";
                cell.statLabel.text = [NSString stringWithFormat:@"%d", assist];
                break;
            case 5:
                cell.statTitleLabel.text = @"Steals";
                cell.statLabel.text = [NSString stringWithFormat:@"%d", steals];
                break;
            case 6:
                cell.statTitleLabel.text = @"Blocks";
                cell.statLabel.text = [NSString stringWithFormat:@"%d", blocks];
                break;
            case 7:
                cell.statTitleLabel.text = @"Turnovers";
                cell.statLabel.text = [NSString stringWithFormat:@"%d", turnovers];
                break;
                
            default:
                cell.statTitleLabel.text = @"Fouls";
                cell.statLabel.text = [NSString stringWithFormat:@"%d", fouls];
                break;
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
        
        BasketballStats *stats;
        Athlete *player = [currentSettings.roster objectAtIndex:indexPath.row];
        cell.playerLabel.text = player.logname;
        stats = [player findBasketballGameStatEntries:game.id];
        
        int totalfgm = [stats.twomade intValue] + [stats.threemade intValue] + [stats.ftmade intValue];
        int totalfga = [stats.twoattempt intValue] + [stats.threeattempt intValue] + [stats.ftattempt intValue];
        
        cell.label1.text = [NSString stringWithFormat:@"%d%@%d", totalfgm, @"/", totalfga];
        cell.label2.text = [NSString stringWithFormat:@"%@%@%@", [stats.ftmade stringValue], @"/", [stats.ftattempt stringValue]];
        int totalreb = [stats.offrebound intValue] + [stats.defrebound intValue];
        cell.label3.text = [NSString stringWithFormat:@"%d", totalreb];
        cell.label4.text = [stats.assists stringValue];
        cell.label5.text = [stats.fouls stringValue];
        cell.label6.text = [NSString stringWithFormat:@"%d",
                                 (([stats.threemade intValue] * 3) + [stats.twomade intValue] * 2) + [stats.ftmade intValue]];
        
        return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([visiblestats isEqualToString:@"Player"]) {
        if (indexPath.row < currentSettings.roster.count) {
            [self performSegueWithIdentifier:@"PlayerStatsSegue" sender:self];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *headerView;
    
    if ([visiblestats isEqualToString:@"Player"]) {
        static NSString *CellIdentifier = @"StatTableHeaderCell";
        
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        headerView.backgroundColor = [UIColor cyanColor];
        UILabel *label = [[UILabel alloc] init];
        
        label.text = @"Player";
        label = (UILabel *)[headerView viewWithTag:1];
        label.text = @"FG";
        label = (UILabel *)[headerView viewWithTag:2];
        label.text = @"FT";
        label = (UILabel *)[headerView viewWithTag:3];
        label.text = @"REB";
        label = (UILabel *)[headerView viewWithTag:4];
        label.text = @"AST";
        label = (UILabel *)[headerView viewWithTag:5];
        label.text = @"PF";
        label = (UILabel *)[headerView viewWithTag:6];
        label.text = @"PTS";
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

- (IBAction)teamstatsButtonClicked:(id)sender {
    visiblestats = @"Team";
    [_statTableView reloadData];
}

- (IBAction)playerstatsButtonClicked:(id)sender {
    visiblestats = @"Player";
    [_statTableView reloadData];
}

- (IBAction)visitorPossessionArrowButtonClicked:(id)sender {
    game.possession = @"Home";
    _visitorPossessionArrowButton.hidden = YES;
    _visitorPossessionArrowButton.enabled = NO;
    _homePossessionArrowButton.hidden = NO;
    _homePossessionArrowButton.enabled = YES;
}

- (IBAction)homePossessionArrowButtonClicked:(id)sender {
    game.possession = @"Away";
    _homePossessionArrowButton.hidden = YES;
    _homePossessionArrowButton.enabled = NO;
    _visitorPossessionArrowButton.hidden = NO;
    _visitorPossessionArrowButton.enabled = YES;
}

- (IBAction)homeBonusButtonClicked:(id)sender {
    if (game.homebonus) {
        game.homebonus = NO;
        _homeBonusImage.hidden = YES;
    } else {
        game.homebonus = YES;
        _homeBonusImage.hidden = NO;
    }
}

- (IBAction)visitorBonusButtonClicked:(id)sender {
    if (game.visitorbonus) {
        game.visitorbonus = NO;
        _visitorBonusImage.hidden = YES;
    } else {
        game.visitorbonus = YES;
        _visitorBonusImage.hidden = NO;
    }
}

- (IBAction)saveBarButtonClicked:(id)sender {
    game.homefouls = [NSNumber numberWithInt:[_homeFoulsTextField.text intValue]];
    game.visitorfouls = [NSNumber numberWithInt:[_visitorFoulsTextField.text intValue]];
    game.opponentscore = [NSNumber numberWithInt:[_visitorScoreTextField.text intValue]];
    game.currentgametime = [NSString stringWithFormat:@"%@:%@", _minutesTextField.text, _secondsTextfield.text];
    game.period = [NSNumber numberWithInt:[_periodTextField.text intValue]];
    [game saveGameschedule];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = @"";
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ((textField == _visitorScoreTextField) || (textField == _minutesTextField) || (_homeFoulsTextField) ||
        (_visitorFoulsTextField) || (_periodTextField)) {
        NSString *validRegEx =@"^[0-9.]*$"; //change this regular expression as your requirement
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        if (myStringMatchesRegEx) {
            if ((textField == _minutesTextField) || (textField == _secondsTextfield) || (textField == _homeFoulsTextField) ||
                (textField == _visitorFoulsTextField)) {
                return (newLength > 2) ? NO : YES;
            } else if ((textField == _periodTextField) || (textField == _homeFoulsTextField) || (textField == _visitorFoulsTextField)) {
                return (newLength > 1) ? NO : YES;
            } else if (textField == _visitorScoreTextField) {
                return (newLength > 3 ? NO : YES);
            } else
                return NO;
        } else
            return NO;
    } else
        return YES;
}

- (IBAction)teamstatsBarButtonClicked:(id)sender {
    [self teamstatsButtonClicked:sender];
}

- (IBAction)playerstatsBarButtonClicked:(id)sender {
    [self playerstatsButtonClicked:sender];
}

- (IBAction)messageBarButtonClicked:(id)sender {
    NSString *scoreMessage = [NSString stringWithFormat:@"%@ - %d, %@ - %@", currentSettings.team.mascot,
                              [currentSettings teamTotalPoints:game.id], game.opponent_mascot, [game.opponentscore stringValue]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Send Score Message" message:scoreMessage delegate:self cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Send", nil] ;
    alertView.tag = 2;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].text = scoreMessage;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Send"]) {
        UITextField * alertTextField = [alertView textFieldAtIndex:0];
        NSLog(@"alerttextfiled - %@",alertTextField.text);
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/sports/%@/teams/%@/gameschedules/%@/alertupdate.json?auth_token=%@",
                                           [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"], currentSettings.sport.id,
                                           currentSettings.team.teamid, game.id, currentSettings.user.authtoken]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSDictionary *messageDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:alertTextField.text, @"message", nil];
        NSError *jsonSerializationError;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:messageDictionary options:0 error:&jsonSerializationError];
        
        if (jsonSerializationError) {
            NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
        }
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        
        [request setHTTPMethod:@"PUT"];
        
        [request setHTTPBody:jsonData];
        
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    responseStatusCode = [httpResponse statusCode];
    theData = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [theData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error posting notification!" delegate:nil cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    
    if (responseStatusCode == 200) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Notification Sent!" delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error posting notification!" delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
