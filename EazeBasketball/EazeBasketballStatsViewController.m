//
//  EazeBasketballStatsViewController.m
//  EazeSportz
//
//  Created by Gil on 11/17/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazeBasketballStatsViewController.h"
#import "EazesportzAppDelegate.h"
#import "BasketballStatTableCell.h"
#import "EazeBasketballPlayerStatsViewController.h"

@interface EazeBasketballStatsViewController ()

@end

@implementation EazeBasketballStatsViewController

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

- (void)viewDidAppear:(BOOL)animated {
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [currentSettings.gameList count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BasketballStatsTableCell";
    BasketballStatTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[BasketballStatTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    BasketballStats *stats;
    
    if (indexPath.row < currentSettings.gameList.count ) {
        GameSchedule *agame = [currentSettings.gameList objectAtIndex:indexPath.row];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@%@", @"vs. ", agame.opponent];
        stats = [self.athlete findBasketballGameStatEntries:agame.id];
        cell.playerImage.image = [self.game opponentImage];
    } else {
        stats = [[BasketballStats alloc] init];
        cell.nameLabel.text = @"Totals";
        cell.playerImage.image = [currentSettings.team getImage:@"tiny"];
    }
    
    if (indexPath.section == 0 ) {
        if (indexPath.row < currentSettings.gameList.count) {
            cell.fgmLabel.text = [stats.twomade stringValue];
            cell.fgaLabel.text = [stats.twoattempt stringValue];
            
            if ([stats.twomade intValue] > 0)
                cell.fgpLabel.text = [NSString stringWithFormat:@"%.02f", (float)[stats.twomade intValue] / (float)[stats.twoattempt intValue]];
            else
                cell.fgpLabel.text = @"0.00";

            cell.threepmLabel.text = [stats.threemade stringValue];
            cell.threepaLabel.text = [stats.threeattempt stringValue];
            
            if ([stats.threemade intValue] > 0)
                cell.threepctLabel.text = [NSString stringWithFormat:@"%.02f", (float)[stats.threemade intValue] / (float)[stats.threeattempt intValue]];
            else
                cell.threepctLabel.text = @"0.00";
            
            cell.ftmLabel.text = [stats.ftmade stringValue];
            cell.ftaLabel.text = [stats.ftattempt stringValue];
            
            if ([stats.ftmade intValue] > 0)
                cell.ftpctLabel.text = [NSString stringWithFormat:@"%.02f", (float)[stats.ftmade intValue] / (float)[stats.ftattempt intValue]];
            else
                cell.ftpctLabel.text = @"0.00";
            
            cell.pointsLabel.text = [NSString stringWithFormat:@"%d",
                                     (([stats.threemade intValue] * 3) + [stats.twomade intValue] * 2) + [stats.ftmade intValue]];
        } else {
            int fgm = 0, fga = 0, threefgm = 0, threefga = 0, ftm = 0, fta = 0, points = 0;
            float fgp = 0.0, threefgp = 0.0, ftp = 0.0;
            
            for (int i = 0; i < currentSettings.gameList.count; i++) {
                BasketballStats *astat = [self.athlete findBasketballGameStatEntries:[currentSettings.gameList objectAtIndex:i]];
                fgm += [astat.twomade intValue];
                fga += [astat.twoattempt intValue];
                
                if ([astat.twomade intValue] > 0)
                    fgp += [astat.twomade floatValue]/[astat.twoattempt floatValue];
                
                threefga += [astat.threeattempt intValue];
                threefgm += [astat.threemade intValue];
                
                if ([astat.threemade intValue] > 0)
                    threefgp += [astat.threemade floatValue]/[astat.threeattempt floatValue];
                
                ftm += [astat.ftmade intValue];
                fta += [astat.ftattempt intValue];
                
                if ([astat.ftmade intValue] > 0)
                    ftp += [astat.ftmade floatValue]/[astat.ftattempt floatValue];
                
                points += ([astat.threemade intValue] * 3) + ([astat.twomade intValue] * 2) + [astat.ftmade intValue];
            }
            
            cell.fgmLabel.text = [NSString stringWithFormat:@"%d", fgm];
            cell.fgaLabel.text = [NSString stringWithFormat:@"%d", fga];
            cell.fgpLabel.text = [NSString stringWithFormat:@"%.2f", fgp];
            cell.threepmLabel.text = [NSString stringWithFormat:@"%d", threefgm];
            cell.threepaLabel.text = [NSString stringWithFormat:@"%d", threefga];
            cell.threepctLabel.text = [NSString stringWithFormat:@"%.2f", threefgp];
            cell.ftmLabel.text = [NSString stringWithFormat:@"%d", ftm];
            cell.ftaLabel.text = [NSString stringWithFormat:@"%d", fta];
            cell.ftpctLabel.text = [NSString stringWithFormat:@"%.2f", ftp];
            cell.pointsLabel.text = [NSString stringWithFormat:@"%d", points];
        }
    } else {
        if (indexPath.row < currentSettings.gameList.count) {
            cell.fgmTitleLabel.text = @"Fouls:";
            cell.fgmLabel.text = [stats.fouls stringValue];
            cell.fgaTitleLabel.text = @"OReb:";
            cell.fgaLabel.text = [stats.offrebound stringValue];
            cell.fgpTitleLabel.text = @"DReb:";
            cell.fgpLabel.text = [stats.defrebound stringValue];
            cell.threefgmTitleLabel.text = @"Ast:";
            cell.threepmLabel.text = [stats.assists stringValue];
            cell.threefgaTitleLabel.text = @"Steal:";
            cell.threepaLabel.text = [stats.steals stringValue];
            cell.threefgpTitleLabel.text = @"Blk:";
            cell.threepctLabel.text = [stats.blocks stringValue];
            cell.ftmTitleLabel.text = @"TO";
            cell.ftmLabel.text = [stats.turnovers stringValue];
            cell.ftaTitleLabel.text = @"";
            cell.ftaLabel.text = @"";
            cell.ftpTitleLabel.text = @"";
            cell.ftpctLabel.text = @"";
            cell.pointsTitleLabel.text = @"";
            cell.pointsLabel.text = @"";
        } else {
            int fouls = 0, orb = 0, drb = 0, assist = 0, steals = 0, blocks = 0, turnovers = 0;
            
            for (int i = 0; i < currentSettings.gameList.count; i++) {
                BasketballStats *astat = [self.athlete findBasketballGameStatEntries:[currentSettings.gameList objectAtIndex:i]];
                fouls += [astat.fouls intValue];
                orb += [astat.offrebound intValue];
                drb += [astat.defrebound intValue];
                assist += [astat.assists intValue];
                steals += [astat.steals intValue];
                blocks += [astat.blocks intValue];
                turnovers += [astat.turnovers intValue];
            }
            
            cell.fgmTitleLabel.text = @"Fouls:";
            cell.fgmLabel.text = [NSString stringWithFormat:@"%d", fouls];
            cell.fgaTitleLabel.text = @"OReb:";
            cell.fgaLabel.text = [NSString stringWithFormat:@"%d", orb];
            cell.fgpTitleLabel.text = @"DReb:";
            cell.fgpLabel.text = [NSString stringWithFormat:@"%d", drb];
            cell.threefgmTitleLabel.text = @"Ast:";
            cell.threepmLabel.text = [NSString stringWithFormat:@"%d", assist];
            cell.threefgaTitleLabel.text = @"Steal:";
            cell.threepaLabel.text = [NSString stringWithFormat:@"%d", steals];
            cell.threefgpTitleLabel.text = @"Blk:";
            cell.ftmTitleLabel.text = @"TO";
            cell.threepctLabel.text = [NSString stringWithFormat:@"%d", blocks];
            cell.ftmTitleLabel.text = @"TO";
            cell.ftmLabel.text = [NSString stringWithFormat:@"%d", turnovers];
            cell.ftaTitleLabel.text = @"";
            cell.ftaLabel.text = @"";
            cell.ftpTitleLabel.text = @"";
            cell.ftpctLabel.text = @"";
            cell.pointsTitleLabel.text = @"";
            cell.pointsLabel.text = @"";
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Scoring";
    } else {
        return @"Other Stats";
    }
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 25.0)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 5.0, 60.0, 20.0)];
    label.backgroundColor= [UIColor clearColor];
    label.textColor = [UIColor redColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.font = [UIFont boldSystemFontOfSize:10.0];
    
    if (self.game)
        label.text = @"Player";
    else
        label.text = @"Game";
    
    [header addSubview:label];
    
    UILabel *FGALabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 5.0, 30.0, 20.0)];
    FGALabel.backgroundColor= [UIColor clearColor];
    FGALabel.textColor = [UIColor redColor];
    FGALabel.shadowColor = [UIColor whiteColor];
    FGALabel.shadowOffset = CGSizeMake(0, 1);
    FGALabel.font = [UIFont boldSystemFontOfSize:10.0];
    FGALabel.text = @"FGA";
    [header addSubview:FGALabel];
    
    UILabel *FGMLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 5.0, 30.0, 20.0)];
    FGMLabel.backgroundColor= [UIColor clearColor];
    FGMLabel.textColor = [UIColor redColor];
    FGMLabel.shadowColor = [UIColor whiteColor];
    FGMLabel.shadowOffset = CGSizeMake(0, 1);
    FGMLabel.font = [UIFont boldSystemFontOfSize:10.0];
    FGMLabel.text = @"FGM";
    [header addSubview:FGMLabel];
    /*
     UILabel *FGPLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 5.0, 30.0, 20.0)];
     FGPLabel.backgroundColor= [UIColor clearColor];
     FGPLabel.textColor = [UIColor redColor];
     FGPLabel.shadowColor = [UIColor whiteColor];
     FGPLabel.shadowOffset = CGSizeMake(0, 1);
     FGPLabel.font = [UIFont boldSystemFontOfSize:10.0];
     FGPLabel.text = @"FGP";
     [header addSubview:FGPLabel];
     */ /*
    UILabel *ThreeFGA = [[UILabel alloc] initWithFrame:CGRectMake(130.0, 5.0, 30.0, 20.0)];
    ThreeFGA.backgroundColor= [UIColor clearColor];
    ThreeFGA.textColor = [UIColor redColor];
    ThreeFGA.shadowColor = [UIColor whiteColor];
    ThreeFGA.shadowOffset = CGSizeMake(0, 1);
    ThreeFGA.font = [UIFont boldSystemFontOfSize:10.0];
    ThreeFGA.text = @"3FGA";
    [header addSubview:ThreeFGA];
    
    UILabel *ThreeFGM = [[UILabel alloc] initWithFrame:CGRectMake(165.0, 5.0, 30.0, 20.0)];
    ThreeFGM.backgroundColor= [UIColor clearColor];
    ThreeFGM.textColor = [UIColor redColor];
    ThreeFGM.shadowColor = [UIColor whiteColor];
    ThreeFGM.shadowOffset = CGSizeMake(0, 1);
    ThreeFGM.font = [UIFont boldSystemFontOfSize:10.0];
    ThreeFGM.text = @"3FGM";
    [header addSubview:ThreeFGM];
    /*
     UILabel *ThreeFGP = [[UILabel alloc] initWithFrame:CGRectMake(200.0, 5.0, 30.0, 20.0)];
     ThreeFGP.backgroundColor= [UIColor clearColor];
     ThreeFGP.textColor = [UIColor redColor];
     ThreeFGP.shadowColor = [UIColor whiteColor];
     ThreeFGP.shadowOffset = CGSizeMake(0, 1);
     ThreeFGP.font = [UIFont boldSystemFontOfSize:10.0];
     ThreeFGP.text = @"3FGP";
     [header addSubview:ThreeFGP];
     */ /*
    UILabel *FTALabel = [[UILabel alloc] initWithFrame:CGRectMake(200.0, 5.0, 30.0, 20.0)];
    FTALabel.backgroundColor= [UIColor clearColor];
    FTALabel.textColor = [UIColor redColor];
    FTALabel.shadowColor = [UIColor whiteColor];
    FTALabel.shadowOffset = CGSizeMake(0, 1);
    FTALabel.font = [UIFont boldSystemFontOfSize:10.0];
    FTALabel.text = @"FTA";
    [header addSubview:FTALabel];
    
    UILabel *FTMLabel = [[UILabel alloc] initWithFrame:CGRectMake(230.0, 5.0, 30.0, 20.0)];
    FTMLabel.backgroundColor= [UIColor clearColor];
    FTMLabel.textColor = [UIColor redColor];
    FTMLabel.shadowColor = [UIColor whiteColor];
    FTMLabel.shadowOffset = CGSizeMake(0, 1);
    FTMLabel.font = [UIFont boldSystemFontOfSize:10.0];
    FTMLabel.text = @"FTM";
    [header addSubview:FTMLabel];
    
    UILabel *Totals = [[UILabel alloc] initWithFrame:CGRectMake(260.0, 5.0, 40.0, 20.0)];
    Totals.backgroundColor= [UIColor clearColor];
    Totals.textColor = [UIColor redColor];
    Totals.shadowColor = [UIColor whiteColor];
    Totals.shadowOffset = CGSizeMake(0, 1);
    Totals.font = [UIFont boldSystemFontOfSize:10.0];
    Totals.text = @"Total";
    [header addSubview:Totals];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}
*/
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (IBAction)refreshBurronClicked:(id)sender {
    [currentSettings retrievePlayers];
    
    if (self.athlete)
        self.athlete = [currentSettings findAthlete:self.athlete.athleteid];
    else
        self.game = [currentSettings findGame:self.game.id];
    
    [self.basketballTableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.basketballTableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"PlayerStatsSegue"]) {
        EazeBasketballPlayerStatsViewController *destController = segue.destinationViewController;
        
        if (self.game) {
            destController.player = [currentSettings.roster objectAtIndex:indexPath.row];            
            destController.game = self.game;
        } else {
            destController.game = [currentSettings.gameList objectAtIndex:indexPath.row];
            destController.player = self.athlete;
        }
    }
}

@end
