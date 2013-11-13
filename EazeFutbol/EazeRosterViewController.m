//
//  EazeRosterViewViewController.m
//  EazeSportz
//
//  Created by Gil on 11/12/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "EazeRosterViewController.h"
#import "PlayerInfoViewController.h"
#import "EazesportzAppDelegate.h"
#import "RosterTableCell.h"

@interface EazeRosterViewController ()

@end

@implementation EazeRosterViewController

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.rosterTableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"PlayerInfoSegue"]) {
        PlayerInfoViewController *destController = segue.destinationViewController;
        destController.player = [currentSettings.roster objectAtIndex:indexPath.row];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RosterTableCell";
    RosterTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[RosterTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Athlete *aplayer = [currentSettings.roster objectAtIndex:indexPath.row];
    cell.playernameLabel.text = aplayer.name;
    cell.playerNumberLabel.text = [aplayer.number stringValue];
    cell.playerPositionLabel.text = aplayer.position;
    cell.rosterImage.image = [aplayer getImage:@"tiny"];
    
    if ([currentSettings hasAlerts:aplayer.athleteid] == NO)
        cell.alertImage.image = nil;
    
    return cell;
}

@end
