//
//  EazeSoccerStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 11/12/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazeSoccerStatsViewController.h"
#import "SoccerPlayerStatsTableCell.h"
#import "EazesportzAppDelegate.h"
#import "EazeSoccerPlayerStatsViewController.h"
#import "EazesportzRetrievePlayers.h"
#import "EazesportzDisplayAdBannerViewController.h"
#import "EazesportzStatTableHeaderCell.h"

@interface EazeSoccerStatsViewController ()

@end

@implementation EazeSoccerStatsViewController {
    EazesportzDisplayAdBannerViewController *adBannerController;
}

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = self.athlete.full_name;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SoccerStatsTableCell";
    SoccerPlayerStatsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[SoccerPlayerStatsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor darkGrayColor];
    
    Soccer *stats;
    
    if (indexPath.section == 0) {
        
        if (self.game) {
            if (indexPath.row < currentSettings.roster.count) {
                Athlete *player = [currentSettings.roster objectAtIndex:indexPath.row];
                cell.playerName.text = player.numberLogname;
                stats = [player findSoccerGameStats:self.game.id];
//                cell.imageView.image = [player getImage:@"tiny"];
            } else {
//                cell.playerImage.image = [currentSettings.team getImage:@"tiny"];
                cell.playerName.text = @"Totals";
                stats = [[Soccer alloc] init];
                
                int goals = 0, shots = 0, assists = 0, steals = 0, cornerkicks = 0;
                
                for (int i = 0; i < currentSettings.roster.count; i++) {
                    Soccer *astat = [[currentSettings.roster objectAtIndex:i] findSoccerGameStats:self.game.id];
                    goals += [astat.goals intValue];
                    shots += [astat.shotstaken intValue];
                    assists += [astat.assists intValue];
                    steals += [astat.steals intValue];
                    cornerkicks += [astat.cornerkicks intValue];
                }
            }
        } else if (self.athlete) {
            if (indexPath.row < currentSettings.gameList.count) {
                GameSchedule *agame = [currentSettings.gameList objectAtIndex:indexPath.row];
                cell.playerName.text = agame.opponent;
                stats = [self.athlete findSoccerGameStats:agame.id];
//                cell.imageView.image = [agame opponentImage];
            } else {
//                cell.playerImage.image = [currentSettings.team getImage:@"tiny"];
                cell.playerName.text = @"Totals";
                stats = [[Soccer alloc] init];
                
                int goals = 0, shots = 0, assists = 0, steals = 0, cornerkicks = 0;
                
                for (int i = 0; i < currentSettings.gameList.count; i++) {
                    Soccer *astat = [self.athlete findSoccerGameStats:[[currentSettings.gameList objectAtIndex:i] id]];
                    goals += [astat.goals intValue];
                    shots += [astat.shotstaken intValue];
                    assists += [astat.assists intValue];
                    steals += [astat.steals intValue];
                    cornerkicks += [astat.cornerkicks intValue];
                }
                
                stats.goals = [NSNumber numberWithInt:goals];
                stats.shotstaken = [NSNumber numberWithInt:shots];
                stats.assists = [NSNumber numberWithInt:assists];
                stats.steals = [NSNumber numberWithInt:steals];
                stats.cornerkicks = [NSNumber numberWithInt:cornerkicks];
            }
        
            cell.label1.text = [stats.goals stringValue];
            cell.label2.text = [stats.shotstaken stringValue];
            cell.label3.text = [stats.assists stringValue];
            cell.label4.text = [stats.steals stringValue];
            cell.label5.text = [stats.cornerkicks stringValue];
            cell.label6.text = [NSString stringWithFormat:@"%d", ([stats.goals intValue] * 2) + [stats.assists intValue]];
        }
    } else {
        if (self.game) {
            if (indexPath.row < currentSettings.roster.count) {
                Athlete *player = [currentSettings.roster objectAtIndex:indexPath.row];
                cell.playerName.text = player.numberLogname;
                stats = [player findSoccerGameStats:self.game.id];
//                cell.imageView.image = [player getImage:@"tiny"];
            } else {
//                cell.playerImage.image = [currentSettings.team getImage:@"tiny"];
                cell.playerName.text = @"Totals";
                stats = [[Soccer alloc] init];
                
                int goalssaved = 0, goalsagainst = 0, minutesplayed = 0;
                
                for (int i = 0; i < currentSettings.roster.count; i++) {
                    Soccer *astat = [[currentSettings.roster objectAtIndex:i] findSoccerGameStats:self.game.id];
                    goalsagainst += [astat.goalsagainst intValue];
                    goalssaved += [astat.goalssaved intValue];
                    minutesplayed += [astat.minutesplayed intValue];
                }
            }
        } else {
            if (indexPath.row < currentSettings.gameList.count) {
                GameSchedule *agame = [currentSettings.gameList objectAtIndex:indexPath.row];
                cell.playerName.text = agame.opponent;
                stats = [self.athlete findSoccerGameStats:agame.id];
//                cell.imageView.image = [agame opponentImage];
            } else {
//                cell.playerImage.image = [currentSettings.team getImage:@"tiny"];
                cell.playerName.text = @"Totals";
                stats = [[Soccer alloc] init];
                
                int goalssaved = 0, goalsagainst = 0, minutesplayed = 0;
                
                for (int i = 0; i < currentSettings.gameList.count; i++) {
                    Soccer *astat = [self.athlete findSoccerGameStats:[[currentSettings.gameList objectAtIndex:i] id]];
                    goalsagainst += [astat.goalsagainst intValue];
                    goalssaved += [astat.goalssaved intValue];
                    minutesplayed += [astat.minutesplayed intValue];
                }
                
                stats.goalsagainst = [NSNumber numberWithInt:goalsagainst];
                stats.goalssaved = [NSNumber numberWithInt:goalssaved];
                stats.minutesplayed = [NSNumber numberWithInt:minutesplayed];
            }
        }
        
        cell.titleLabel1.text = @"Saves";
        cell.label1.text = [stats.goalssaved stringValue];
        cell.titleLabel2.text = @"GA";
        cell.label2.text = [stats.goalsagainst stringValue];
        cell.titleLabel3.text = @"Minutes";
        cell.label3.text = @"";
        cell.titleLabel4.text = @"";
        cell.label4.text = @"";
        cell.titleLabel5.text = @"";
        cell.label5.text = [stats.minutesplayed stringValue];
        cell.titleLabel6.text = @"";
        cell.label6.text = @"";
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    EazesportzStatTableHeaderCell *headerView;
    
    static NSString *CellIdentifier = @"StatTableHeaderCell";
    
    if (section == 0) {
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (IBAction)refreshBurronClicked:(id)sender {
    [[[EazesportzRetrievePlayers alloc] init] retrievePlayers:currentSettings.sport.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken];
    
    if (self.athlete)
        self.athlete = [currentSettings findAthlete:self.athlete.athleteid];
    else
        self.game = [currentSettings findGame:self.game.id];
    
    [self.soccerPlayerStatsTableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.soccerPlayerStatsTableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"PlayerStatsSegue"]) {
        EazeSoccerPlayerStatsViewController *destController = segue.destinationViewController;
        
        if (self.game) {
            if (indexPath.section == 0)
                destController.player = [currentSettings.roster objectAtIndex:indexPath.row];
            else
                destController.player = [self.goalies objectAtIndex:indexPath.row];
            
            destController.game = self.game;
        } else {
            destController.game = [currentSettings.gameList objectAtIndex:indexPath.row];            
            destController.player = self.athlete;
        }
    } else if ([segue.identifier isEqualToString:@"AdDisplaySegue"]) {
        adBannerController = segue.destinationViewController;
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (currentSettings.sport.hideAds) {
        _bannerView.hidden = YES;
        _adBannerContainer.hidden = NO;
        [adBannerController displayAd];
    } else {
        _adBannerContainer.hidden = YES;
        _bannerView.hidden = NO;
    }
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    _bannerView.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textFied {
    textFied.text = @"";
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
