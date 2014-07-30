//
//  EazesportzWaterPoloPlayerGamesViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 7/24/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzWaterPoloPlayerGamesViewController.h"
#import "EazesportzAppDelegate.h"
#import "VisitingTeam.h"
#import "SoccerPlayerStatsTableCell.h"

@interface EazesportzWaterPoloPlayerGamesViewController ()

@end

@implementation EazesportzWaterPoloPlayerGamesViewController {
    VisitingTeam *visitingteam;
    NSMutableArray *goalies;
}

@synthesize player;
@synthesize visitingplayer;

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
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ((visitingplayer) && ([visitingplayer isWaterPoloGoalie]))
        return 3;
    else if (visitingplayer)
        return 2;
    else if ((player) && ([player isWaterPoloGoalie]))
        return 3;
    else
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return currentSettings.gameList.count;
    else if (section == 1)
        return 1;
    else
        return currentSettings.gameList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SoccerPlayerStatsTableCell *cell = [[SoccerPlayerStatsTableCell alloc] init];
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"GameStatsTableCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        if (cell == nil) {
            cell = [[SoccerPlayerStatsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        GameSchedule *game = [currentSettings.gameList objectAtIndex:indexPath.row];
        WaterPoloStat *stat;

        if (visitingplayer) {
            stat = [visitingplayer findWaterPoloStat:game];
        } else {
            stat = [player findWaterPoloStat:game];
        }
        
        cell.label1.text = game.opponent_mascot;
        cell.label2.text = [[stat getTotalShots] stringValue];
        cell.label3.text = [NSString stringWithFormat:@"%d", (int)stat.scoring_stats.count];
        cell.label4.text = [[stat getTotalAssists] stringValue];
        cell.label5.text = [NSString stringWithFormat:@"%d", (int)(stat.scoring_stats.count + [[stat getTotalAssists] intValue])];
        cell.label6.text = [[stat getTotalSteals] stringValue];
    } else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"GameAveragesTableCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        if (cell == nil) {
            cell = [[SoccerPlayerStatsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        WaterPoloStat *stat = [player findWaterPoloStat:[currentSettings.gameList objectAtIndex:indexPath.row]];
        cell.label1.text = [NSString stringWithFormat:@"%0.2f", (float)(stat.scoring_stats.count / currentSettings.gameList.count)];
        cell.label2.text = [NSString stringWithFormat:@"%.02f", (float)([stat.getTotalAssists intValue] / currentSettings.gameList.count)];
        cell.label3.text = [NSString stringWithFormat:@"%.02f", (float)([stat.getTotalShots intValue] / currentSettings.gameList.count)];
        cell.label4.text = [NSString stringWithFormat:@"%.02f",
                            (float)(([stat.getTotalAssists intValue] + stat.scoring_stats.count) / currentSettings.gameList.count)];
    } else {
        static NSString *CellIdentifier = @"GameStatsTableCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        if (cell == nil) {
            cell = [[SoccerPlayerStatsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.backgroundColor = [UIColor darkGrayColor];
        
        if (indexPath.row < currentSettings.gameList.count) {
            GameSchedule *game = [currentSettings.gameList objectAtIndex:indexPath.row];
            WaterPoloStat *stat;
            
            if (visitingplayer) {
                stat = [visitingplayer findWaterPoloStat:game];
            } else {
                stat = [player findWaterPoloStat:game];
            }
            
            cell.label1.text = game.opponent_mascot;
            cell.label2.text = [stat.getTotalMinutes stringValue];
            cell.label3.text = [stat.getTotalGoalsAllowed stringValue];
            cell.label4.text = [stat.getTotalSaves stringValue];
            cell.label5.text = [NSString stringWithFormat:@"%.02f", (float)([stat.getTotalGoalsAllowed intValue] / currentSettings.gameList.count)];
            cell.label6.text = @"";
        }
        
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SoccerPlayerStatsTableCell *headerView;
    
    if (section == 0) {
        static NSString *CellIdentifier = @"GameStatsHeaderCell";
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        headerView.backgroundColor = [UIColor blueColor];
    } else if (section == 1) {
        static NSString *CellIdentifier = @"GameAveragesHeaderCell";
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        headerView.backgroundColor = [UIColor blueColor];
    } else {
        static NSString *CellIdentifier = @"GameAveragesHeaderCell";
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        headerView.backgroundColor = [UIColor blueColor];
        headerView.label2.text = @"Min";
        headerView.label3.text = @"GA";
        headerView.label4.text = @"SV";
        headerView.label5.text = @"PCT";
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

@end
