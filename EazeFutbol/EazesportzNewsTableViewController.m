//
//  EazesportzNewsTableViewController.m
//  EazeSportz
//
//  Created by Gil on 11/12/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazesportzNewsTableViewController.h"
#import "EazesportzAppDelegate.h"
#import "Newsfeed.h"
#import "NewsTableCell.h"
#import "EazeNewsFeedInfoViewController.h"

@interface EazesportzNewsTableViewController ()

@end

@implementation EazesportzNewsTableViewController

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
    static NSString *CellIdentifier = @"NewsTableCell";
    NewsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    Newsfeed *feeditem = [self.newsfeed objectAtIndex:indexPath.row];
    
    cell.newsTitleLabel.text = feeditem.title;
    cell.newsTextView.text = feeditem.news;
    cell.newsTextView.editable = NO;
    
    if (feeditem.team.length > 0)
        cell.teamLabel.text = [[currentSettings findTeam:feeditem.team] team_name];
    else
        cell.teamLabel.text = @"";
    
    if (feeditem.athlete.length > 0) {
        cell.playerdisplayLabel.hidden = NO;
        cell.athleteLabel.text = [[currentSettings findAthlete:feeditem.athlete] logname];
    } else {
        cell.playerdisplayLabel.hidden = YES;
        cell.athleteLabel.text = @"";
    }
    
    if (feeditem.coach.length > 0) {
        cell.coachdisplayLabel.hidden = NO;
        cell.coachLabel.text = [[currentSettings findCoach:feeditem.coach] lastname];
    } else {
        cell.coachdisplayLabel.hidden = YES;
        cell.coachLabel.text = @"";
    }
    
    if (feeditem.game.length > 0)
        cell.gameLabel.text = [NSString stringWithFormat:@"%@%@", @"vs ", [[currentSettings findGame:feeditem.game] opponent]];
    else
        cell.gameLabel.text = @"";
    
    // Add image
    
    if (feeditem.athlete.length > 0) {
        cell.imageView.image = [[currentSettings findAthlete:feeditem.athlete] getImage:@"tiny"];
    } else if (feeditem.coach.length > 0) {
        cell.imageView.image = [[currentSettings findCoach:feeditem.coach] getImage:@"tiny"];
    } else if (feeditem.team.length > 0) {
        cell.imageView.image = [currentSettings.team getImage:@"tiny"];
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"NewsInfoSegue"]) {
        EazeNewsFeedInfoViewController *destController = segue.destinationViewController;
        destController.newsitem = [self.newsfeed objectAtIndex:indexPath.row];
    }
}

@end
