//
//  EazeBballPlayerStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 1/22/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazeBballPlayerStatsViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzStatTableHeaderCell.h"
#import "EazeBasketballScoringTableCell.h"

@interface EazeBballPlayerStatsViewController ()

@end

@implementation EazeBballPlayerStatsViewController {
    NSString *visiblestats;
}

@synthesize player;

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
    self.title = player.name;
    visiblestats = @"Scoring";
    _statSelector.selectedSegmentIndex = 0;
        
    [_playerStatsTableView reloadData];
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
    return currentSettings.gameList.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BasketballStats *stat = [[BasketballStats alloc] init];
    
    if ([visiblestats isEqualToString:@"Scoring"]) {
        EazeBasketballScoringTableCell *cell = [[EazeBasketballScoringTableCell alloc] init];
        static NSString *CellIdentifier = @"ScoringTableCell";
        
    
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        if (cell == nil) {
            cell = [[EazeBasketballScoringTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
            
        float fgp = 0.0, threefgp = 0.0, ftp = 0.0;
       
        if (indexPath.row < currentSettings.gameList.count) {
            stat = [player findBasketballGameStatEntries:[[currentSettings.gameList objectAtIndex:indexPath.row] id]];
            cell.nameLabel.text = [[currentSettings.gameList objectAtIndex:indexPath.row] opponent_mascot];
        } else {
             cell.nameLabel.text = @"Totals";
            
            int points = 0;
            
            for (int i = 0; i < currentSettings.gameList.count; i++) {
                BasketballStats *astat = [player findBasketballGameStatEntries:[[currentSettings.gameList objectAtIndex:i] id]];
                stat.twomade = [NSNumber numberWithInt:[stat.twomade intValue] + [astat.twomade intValue]];
                stat.twoattempt = [NSNumber numberWithInt:[stat.twoattempt intValue] + [astat.twoattempt intValue]];
                
                stat.threeattempt = [NSNumber numberWithInt:[stat.threeattempt intValue] + [astat.threeattempt intValue]];
                stat.threemade = [NSNumber numberWithInt:[stat.threemade intValue] + [astat.threemade intValue]];
                
                stat.ftmade = [NSNumber numberWithInt:[stat.ftmade intValue] + [astat.ftmade intValue]];
                stat.ftattempt = [NSNumber numberWithInt:[stat.ftattempt intValue] + [astat.ftattempt intValue]];
                
                points += ([astat.threemade intValue] * 3) + ([astat.twomade intValue] * 2) + [astat.ftmade intValue];
            }
        }
        
        if ([stat.twomade intValue] > 0)
            fgp += [stat.twomade floatValue]/[stat.twoattempt floatValue];
        
        cell.fieldgoalLabel.text = [NSString stringWithFormat:@"%d%@%D%@%.02f%@", [stat.twomade intValue], @"/",
                                    [stat.twoattempt intValue], @"(", fgp, @")"];
        
        if ([stat.threemade intValue] > 0)
            threefgp += [stat.threemade floatValue]/[stat.threeattempt floatValue];
        
        cell.threefgLabel.text = [NSString stringWithFormat:@"%d%@%D%@%.02f%@", [stat.threemade intValue], @"/",
                                    [stat.threeattempt intValue], @"(", fgp, @")"];
        if ([stat.ftmade intValue] > 0)
            ftp += [stat.ftmade floatValue]/[stat.ftattempt floatValue];
        
        cell.freethrowLabel.text = [NSString stringWithFormat:@"%d%@%D%@%.02f%@", [stat.ftmade intValue], @"/",
                                  [stat.ftattempt intValue], @"(", fgp, @")"];
        cell.totalsLabel.text = [NSString stringWithFormat:@"%d", ([stat.threemade intValue] * 3) + ([stat.twomade intValue] * 2) +
                                 [stat.ftmade intValue]];
        return cell;
    } else {
        EazesportzStatTableHeaderCell *cell = [[EazesportzStatTableHeaderCell alloc] init];
        static NSString *CellIdentifier = @"StatTableCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        if (cell == nil) {
            cell = [[EazesportzStatTableHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (indexPath.row < currentSettings.gameList.count) {
            stat = [player findBasketballGameStatEntries:[[currentSettings.gameList objectAtIndex:indexPath.row] id]];
            cell.playerLabel.text = [[currentSettings.gameList objectAtIndex:indexPath.row] opponent_mascot];
        } else {
            cell.playerLabel.text = @"Totals";
            
            for (int i = 0; i < currentSettings.gameList.count; i++) {
                BasketballStats *astat = [player findBasketballGameStatEntries:[[currentSettings.gameList objectAtIndex:i] id]];
                stat.fouls = [NSNumber numberWithInt:[stat.fouls intValue] + [astat.fouls intValue]];
                stat.offrebound = [NSNumber numberWithInt:[stat.offrebound intValue] + [astat.offrebound intValue]];
                stat.defrebound = [NSNumber numberWithInt:[stat.defrebound intValue] + [astat.defrebound intValue]];
                stat.assists = [NSNumber numberWithInt:[stat.assists intValue] + [astat.assists intValue]];
                stat.steals = [NSNumber numberWithInt:[stat.steals intValue] + [astat.steals intValue]];
                stat.blocks = [NSNumber numberWithInt:[stat.blocks intValue] + [astat.blocks intValue]];
                stat.turnovers = [NSNumber numberWithInt:[stat.turnovers intValue] + [astat.turnovers intValue]];
            }
        }
        
        cell.label1.text = [stat.fouls stringValue];
        cell.label2.text = [NSString stringWithFormat:@"%d", [stat.offrebound intValue] + [stat.defrebound intValue]];
        cell.label3.text = [stat.assists stringValue];
        cell.label4.text = [stat.steals stringValue];
        cell.label5.text = [stat.blocks stringValue];
        cell.label6.text = [stat.turnovers stringValue];
        
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *headerView;
    
    
    if ([visiblestats isEqualToString:@"Scoring"]) {
        static NSString *CellIdentifier = @"ScoringHeaderTableCell";
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UILabel *label = (UILabel *)[headerView viewWithTag:9];
        label.text = @"Game";
     } else {
        static NSString *CellIdentifier = @"StatTableHeaderCell";
        headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UILabel *label = (UILabel *)[headerView viewWithTag:1];
        label.text = @"PF";
        label = (UILabel *)[headerView viewWithTag:2];
        label.text = @"REB";
        label = (UILabel *)[headerView viewWithTag:3];
        label.text = @"AST";
        label = (UILabel *)[headerView viewWithTag:4];
        label.text = @"STL";
        label = (UILabel *)[headerView viewWithTag:5];
        label.text = @"BLK";
        label = (UILabel *)[headerView viewWithTag:6];
        label.text = @"TOV";
        label = (UILabel *)[headerView viewWithTag:9];
        label.text = @"Game";
    }
    
    if (headerView == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (IBAction)statSelectorButtonClicked:(id)sender {
    if (_statSelector.selectedSegmentIndex == 0)
        visiblestats = @"Scoring";
    else
        visiblestats = @"Other";
    
    [_playerStatsTableView reloadData];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    _bannerView.hidden = NO;
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    _bannerView.hidden = YES;
}

@end
