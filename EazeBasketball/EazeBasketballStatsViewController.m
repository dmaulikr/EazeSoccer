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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.game)
        return @"Player       fgm     fga     3fgm    3fga    ftm     fta      Pts";
    else
        return @"Game        fgm     fga     3fgm    3fga    ftm     fta      Pts";
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
