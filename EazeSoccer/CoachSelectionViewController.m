//
//  CoachSelectionViewController.m
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/5/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "CoachSelectionViewController.h"
#import "Coach.h"
#import "CoachTableCell.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "EditCoachViewController.h"
#import "EazesportzRetrieveCoaches.h"

#import <QuartzCore/QuartzCore.h>

@interface CoachSelectionViewController ()

@end

@implementation CoachSelectionViewController

@synthesize coach;

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotCoaches:) name:@"CoachListChangedNotification" object:nil];
//    [[[EazesportzRetrieveCoaches alloc] init] retrieveCoaches:currentSettings.sport.id Team:currentSettings.team.teamid
//                                                        Token:currentSettings.user.authtoken];
}

- (void)viewDidDisappear:(BOOL)animated {
    // do not forget to unsubscribe the observer, or you may experience crashes towards a deallocated observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)gotCoaches:(NSNotificationCenter *)notification {
    if (currentSettings.coaches.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Coaches"
                                                        message:@"Program administrator has not entered any coaches"
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    } else {
        [_coachTableView reloadData];
    }
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
    return currentSettings.coaches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CoachTableCell";
    CoachTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[CoachTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Coach *acoach = [currentSettings.coaches objectAtIndex:indexPath.row];
    cell.coachImage.image = [acoach getImage:@"tiny"];
    cell.coachnameLabel.text = acoach.fullname;
    cell.responsibilityLabel.text = acoach.speciality;
    cell.yearsLabel.text = [acoach.years stringValue];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Coaches";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditCoachSegue"]) {
        NSIndexPath *indexPath = [_coachTableView indexPathForSelectedRow];
        coach = [currentSettings.coaches objectAtIndex:indexPath.row];
        EditCoachViewController *editDestViewController = segue.destinationViewController;
        editDestViewController.coach = coach;
    } else if ([segue.identifier isEqualToString:@"NewCoachSegue"]) {
        EditCoachViewController *destController = segue.destinationViewController;
        destController.coach = nil;
    } else {
        NSIndexPath *indexPath = [_coachTableView indexPathForSelectedRow];
        if ([indexPath length] > 0) {
            coach = [currentSettings.coaches objectAtIndex:indexPath.row];
        }
    }
}


@end
