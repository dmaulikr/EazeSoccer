//
//  TeamSelectViewController.m
//  Basketball Console
//
//  Created by Gil on 10/23/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "TeamSelectViewController.h"
#import "eazesportzAppDelegate.h"
#import "sportzServerInit.h"
#import "sportzCurrentSettings.h"
#import "EditTeamViewController.h"

@interface TeamSelectViewController ()

@end

@implementation TeamSelectViewController {
    NSMutableArray *teamList;
}

@synthesize sport;
@synthesize team;

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
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.addTeamButton, self.editSportButton, nil];
    
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    Sport *thesport;
    
    if (sport)
        thesport = sport;
    else
        thesport = currentSettings.sport;
    
    NSURL *url = [NSURL URLWithString:[sportzServerInit getTeams:thesport.id Token:currentSettings.user.authtoken]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSError *error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSArray *teamData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
    
    if ([httpResponse statusCode] == 200) {
        teamList = [[NSMutableArray alloc] init];
        for (int i = 0; i < teamData.count; i++) {
            [teamList addObject:[[Team alloc] initWithDictionary:[teamData objectAtIndex:i]]];
        }
        [_teamTableView reloadData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem Retrieving Teams"
                                                        message:[NSString stringWithFormat:@"%d", [httpResponse statusCode]]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
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
    return teamList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TeamSelectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Team *ateam = [teamList objectAtIndex:indexPath.row];
    cell.textLabel.text = ateam.team_name;
    cell.imageView.image = [ateam getImage:@"thumb"];
    cell.detailTextLabel.text = ateam.mascot;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (sport) {
        team = [teamList objectAtIndex:indexPath.row];
    } else {
        currentSettings.team = [teamList objectAtIndex:indexPath.row];
        [currentSettings retrieveCoaches];
        [currentSettings retrievePlayers];
        self.navigationItem.hidesBackButton = NO;
        self.tabBarController.tabBar.hidden = NO;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Teams";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self performSegueWithIdentifier:@"EditTeamSegue" sender:self];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Edit Team";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditTeamSegue"]) {
        NSIndexPath *indexPath = [_teamTableView indexPathForSelectedRow];
        EditTeamViewController *destController = segue.destinationViewController;
        destController.team = [teamList objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"NewTeamSegue"]) {
        EditTeamViewController *destController = segue.destinationViewController;
        destController.team = nil;
    } else {
        NSIndexPath *indexPath = [_teamTableView indexPathForSelectedRow];
        
        if (indexPath.length > 0) {
            team = [teamList objectAtIndex:indexPath.row];
        }
    }
}

@end
