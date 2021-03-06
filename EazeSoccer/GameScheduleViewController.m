//
//  GameScheduleViewController.m
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/7/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "GameScheduleViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "sportzServerInit.h"
#import "GameScheduleTableViewCell.h"
#import "EazesportzRetrieveGames.h"

#import <QuartzCore/QuartzCore.h>

@interface GameScheduleViewController () <UIAlertViewDelegate>

@end

@implementation GameScheduleViewController {
    NSMutableArray *games;
    NSIndexPath *deleteIndexPath;
}

@synthesize thegame;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableData:) name:@"GameListChangedNotification" object:nil];
    
    [_gamesTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadTableData:(NSNotification *)notification {
    [_gamesTableView reloadData];
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
    return currentSettings.gameList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GameScheduleTableCell";
    GameScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[GameScheduleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.tag = indexPath.row;
    
    GameSchedule *game = [currentSettings.gameList objectAtIndex:indexPath.row];
    [cell.hometeamLabel setText:[currentSettings.team team_name]];
    [cell.visitorteamLabel setText:game.opponent_name];
    [cell.locationLabel setText:game.location];
    [cell.homeawayLabel setText:game.homeaway];
    cell.homeImageView.image = [currentSettings.team getImage:@"tiny"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *gamedate = [dateFormat dateFromString:game.startdate];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    
    [cell.dateLabel setText:[dateFormat stringFromDate:gamedate]];
    [cell.timeLabel setText:game.starttime];
    
    int homeFinal = [currentSettings teamTotalPoints:game.id];
    int visitorFinal = [game.opponentscore intValue];
    
    
    NSString *WonLost;
    
    NSDate *now = [NSDate date];
    
    if ([gamedate earlierDate:now]) {
        
        if (homeFinal > visitorFinal)
            WonLost = [NSString stringWithFormat:@"W "];
        else if (homeFinal == visitorFinal)
            WonLost = @"T ";
        else
            WonLost = [NSString stringWithFormat:@"L "];
        
        WonLost = [WonLost stringByAppendingString:[NSString stringWithFormat:@"%@", [NSNumber numberWithInt:homeFinal]]];
        WonLost = [WonLost stringByAppendingString:@"-"];
        WonLost = [WonLost stringByAppendingString:[NSString stringWithFormat:@"%@", [NSNumber numberWithInt:visitorFinal]]];
    } else {
        WonLost = @"  0-0";
    }
    
    [cell.wonlostLabel setText:WonLost];
    
    if ([currentSettings getOpponentImage:game] == nil) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:game.opponentpic]];
            
            //this will set the image when loading is finished
            dispatch_async(dispatch_get_main_queue(), ^{
                if (cell.tag == indexPath.row) {
                    cell.visitorImageView.image = [UIImage imageWithData:image];
                    [cell setNeedsLayout];
                }
            });
        });
    } else {
        cell.visitorImageView.image = [currentSettings getOpponentImage:game];
//        [cell.visitorImageView setImage:[game vsimage]];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Games";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        deleteIndexPath = [_gamesTableView indexPathForSelectedRow];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You are about delete the game. All data will be lost!"
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [_gamesTableView indexPathForSelectedRow];
    
    if (indexPath.length > 0) {
        thegame = [currentSettings.gameList objectAtIndex:indexPath.row];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"]) {
    }
}

@end
