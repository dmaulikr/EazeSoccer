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

@interface EazeBasketballGameSummaryViewController ()

@end

@implementation EazeBasketballGameSummaryViewController {
    NSString *visiblestats;
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
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshButton, self.statsButton, nil];
    
    self.navigationController.toolbarHidden = YES;
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
    
    visiblestats = @"Team";
    
    _gameclockLabel.text = game.currentgametime;
    _hometeamLabelText.text = currentSettings.team.mascot;
    _visitorLabelText.text = game.opponent_mascot;
    _hometeamImage.image = [currentSettings.team getImage:@"tiny"];
    _visitorTeamImage.image = [game opponentImage];
    _homefoulsLabel.text = [NSString stringWithFormat:@"%d", [game homeBasketballFouls]];
    _visitorFoulsLabel.text = [game.visitorfouls stringValue];
    
    if (game.homebonus)
        _homeBonusImage.hidden = NO;
    else
        _homeBonusImage.hidden = YES;
    
    if (game.visitorbonus)
        _visitorBonusImage.hidden = NO;
    else
        _visitorBonusImage.hidden = YES;
    
    _periodLabel.text = [game.period stringValue];
    _homeScoreLabel.text = [game.homescore stringValue];
    _visitorScoreLabel.text = [game.opponentscore stringValue];
    
    if ([game.possession isEqualToString:@"Home"]) {
        _homePossesionArrow.hidden = NO;
        _visitorPossessionArrow.hidden = YES;
    } else {
        _homePossesionArrow.hidden = YES;
        _visitorPossessionArrow.hidden = NO;
    }
    
    [_statTableView reloadData];
}

- (IBAction)refreshButtonClicked:(id)sender {
    [currentSettings retrieveGame:game.id];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotRoster:) name:@"RosterChangedNotification" object:nil];
    
    [[[EazesportzRetrievePlayers alloc] init] retrievePlayers:currentSettings.sport.id Team:currentSettings.team.teamid
                                                        Token:currentSettings.user.authtoken];
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
        
        fgp = (float)ftm/(float)fta;
        threefgp = (float)threefgm/(float)threefga;
        ftp = (float)ftm/(float)fta;
        
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
        UILabel *label = (UILabel *)[headerView viewWithTag:1];
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
    }
    
    if (headerView == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (IBAction)teamstatsButtonClicked:(id)sender {
    visiblestats = @"Team";
    [_statTableView reloadData];
}

- (IBAction)playerstatsButtonClicked:(id)sender {
    if ([currentSettings.sport isPackageEnabled]) {
        visiblestats = @"Player";
        [_statTableView reloadData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade Required"
                                                        message:[NSString stringWithFormat:@"%@%@%@", @"Player stats support not available for ", currentSettings.team.team_name,
                                                                 @". Contact your administrator with questions."] delegate:self cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}
@end
