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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BasketballStatsTableCell";
    BasketballStatTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[BasketballStatTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    BasketballStats *stats;
    
    if (self.game) {
        Athlete *player = [currentSettings.roster objectAtIndex:indexPath.row];
        cell.nameLabel.text = player.logname;
        stats = [player findBasketballGameStatEntries:self.game.id];
    } else if (self.athlete) {
        GameSchedule *agame = [currentSettings.gameList objectAtIndex:indexPath.row];
        cell.nameLabel.text = agame.opponent;
        stats = [self.athlete findBasketballGameStatEntries:agame.id];
    } else {
        Athlete *player = [currentSettings.roster objectAtIndex:indexPath.row];
        cell.nameLabel.text = player.logname;
        stats = [[BasketballStats alloc] init];
    }
    
    cell.fgmLabel.text = [stats.twomade stringValue];
    cell.fgaLabel.text = [stats.twoattempt stringValue];
    cell.threepmLabel.text = [stats.threemade stringValue];
    cell.threepaLabel.text = [stats.threeattempt stringValue];
    cell.ftmLabel.text = [stats.ftmade stringValue];
    cell.ftaLabel.text = [stats.ftattempt stringValue];
    cell.pointsLabel.text = [NSString stringWithFormat:@"%d", (([stats.threemade intValue] * 3) + [stats.twomade intValue] * 2) + [stats.ftmade intValue]];
    
    return cell;
}

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
     */
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
     */
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
