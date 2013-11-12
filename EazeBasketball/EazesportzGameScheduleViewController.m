//
//  EazesportzGameScheduleViewController.m
//  EazeSportz
//
//  Created by Gil on 11/12/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzGameScheduleViewController.h"
#import "EazesportzAppDelegate.h"
#import "GameScheduleTableViewCell.h"

@interface EazesportzGameScheduleViewController ()

@end

@implementation EazesportzGameScheduleViewController

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
    static NSString *CellIdentifier = @"GameScheduleTableCell";
    GameScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[GameScheduleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    GameSchedule *game = [currentSettings.gameList objectAtIndex:indexPath.row];
    
    if ([game.homeaway isEqualToString:@"Home"]) {
        [cell.hometeamLabel setText:[currentSettings.team team_name]];
    } else {
        [cell.visitorteamLabel setText:game.opponent_name];
    }
    
    cell.homeImageView.image = [currentSettings.team getImage:@"tiny"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *gamedate = [dateFormat dateFromString:game.startdate];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    
    [cell.dateLabel setText:[dateFormat stringFromDate:gamedate]];
    [cell.timeLabel setText:game.starttime];
    
    int homeFinal = game.homeq1.intValue + game.homeq2.intValue+ game.homeq3.intValue + game.homeq4.intValue;
    int visitorFinal = game.opponentq1.intValue + game.opponentq2.intValue + game.opponentq3.intValue + game.opponentq4.intValue;
    NSString *WonLost;
    
    NSDate *now = [NSDate date];
    
    if (gamedate < now) {
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
    [cell.visitorImageView setImage:[game opponentImage]];
    
    return cell;
}

@end
