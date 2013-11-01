//
//  FullViewPlayerSelectionViewController.m
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/2/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "FullViewPlayerSelectionViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "sportzServerInit.h"
#import "RosterTableCell.h"
#import "EditPlayerViewController.h"
#import "FindPlayerViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface FullViewPlayerSelectionViewController () <UIAlertViewDelegate>

@end

@implementation FullViewPlayerSelectionViewController {
    FindPlayerViewController *findPlayerController;
    NSIndexPath *deleteIndexPath;
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
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.searchButton, self.refreshButton, self.addButton, nil];
    
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.findPlayerContainer.hidden = YES;
    [currentSettings retrievePlayers];
    self.rosterdata = currentSettings.roster;
    [self.playerTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RosterTableCell";
    RosterTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[RosterTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Athlete *aplayer = [self.rosterdata objectAtIndex:indexPath.row];
    cell.playernameLabel.text = aplayer.name;
    cell.playerNumberLabel.text = [aplayer.number stringValue];
    cell.playerPositionLabel.text = aplayer.position;
    cell.rosterImage.image = [aplayer getImage:@"thumb"];
    
    if ([currentSettings hasAlerts:aplayer.athleteid] == NO)
        cell.alertLabel.textColor = [UIColor clearColor];
    else
        cell.alertLabel.textColor = [UIColor redColor];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        deleteIndexPath = [self.playerTableView indexPathForSelectedRow];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"All Athlete data will be lost. Click Confirm to Proceed"
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"]) {
        if ([currentSettings deletePlayer:[self.rosterdata objectAtIndex:deleteIndexPath.row]]) {
            [self viewWillAppear:YES];
        }
    }
}

- (IBAction)refreshButtonClicked:(id)sender {
    [self viewWillAppear:YES];
}

- (IBAction)searchPlayerButtonClicked:(id)sender {
    self.findPlayerContainer.hidden = NO;
}

- (IBAction)findFullPlayerSelected:(UIStoryboardSegue *)segue {
    self.findPlayerContainer.hidden = YES;
    
    if ((findPlayerController.numberTextField.text.length > 0) || (findPlayerController.positionTextField.text.length > 0)) {
        self.position = findPlayerController.positionTextField.text;
        self.jersey = findPlayerController.numberTextField.text;
        [super searchPlayer];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FindPlayerSegue"]) {
        findPlayerController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"EditPlayerSegue"]) {
        NSIndexPath *indexPath = [self.playerTableView indexPathForSelectedRow];
        EditPlayerViewController *editDestViewController = segue.destinationViewController;
        editDestViewController.player = [self.rosterdata objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"NewPlayerSegue"]) {
        EditPlayerViewController *destController = segue.destinationViewController;
        destController.player = nil;
    }

}

@end
