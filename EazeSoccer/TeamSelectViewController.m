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
#import "sportzConstants.h"
#import "KeychainWrapper.h"
#import "EazesportzRetrievePlayers.h"
#import "EazesportzRetrieveAlerts.h"

@interface TeamSelectViewController () <UIAlertViewDelegate>

@end

@implementation TeamSelectViewController {
    NSMutableArray *teamList;
    
    NSIndexPath *editTeamIndexPath;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotApplicationData:) name:@"RosterChangedNotification" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (sport) {
        teamList = [currentSettings retrieveSportTeams:sport.id];
    } else {
        [currentSettings retrieveTeams];
        teamList = currentSettings.teams;
    }
    
    [_teamTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!currentSettings.sport.approved) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Beta Approval Needed"
                                                        message:[NSString stringWithFormat:@"Email us at info@eazesportz.com"]
                                                       delegate:self cancelButtonTitle:@"Logout" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        _editSportButton.enabled = NO;
        _addTeamButton.enabled = NO;
    } else if (currentSettings.team.teamid.length == 0) {
        self.tabBarController.tabBar.hidden = YES;
        self.navigationItem.hidesBackButton = YES;
        
        if (teamList.count == 1) {
            currentSettings.team = [teamList objectAtIndex:0];
            [[[EazesportzRetrieveAlerts alloc] init] retrieveAlerts:currentSettings.sport.id Team:currentSettings.team.teamid
                                                              Token:currentSettings.user.authtoken];
            [[[EazesportzRetrievePlayers alloc] init] retrievePlayers:currentSettings.sport.id Team:currentSettings.team.teamid
                                                                Token:currentSettings.user.authtoken];
        }

    } else if ((teamList.count == 0) && (sport)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No teams"
                                                        message:[NSString stringWithFormat:@"Program admin has not entered team data yet!"]
                                                       delegate:self cancelButtonTitle:@"Logout" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)gotApplicationData:(NSNotification *)notification {
    self.navigationItem.hidesBackButton = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Logout"]) {
        
        NSURL *url = [NSURL URLWithString:[sportzServerInit logout:currentSettings.user.authtoken]];
        NSURLResponse* response;
        NSError *error = nil;
        NSMutableDictionary *jsonDict =  [[NSMutableDictionary alloc] init];
        NSError *jsonSerializationError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&jsonSerializationError];
        
        if (!jsonSerializationError) {
            NSString *serJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"Serialized JSON: %@", serJson);
        } else {
            NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
        }
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:jsonData];
        [request setHTTPMethod:@"DELETE"];
        NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *serverData = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        
        currentSettings.user.email = @"";
        currentSettings.user.authtoken = @"";
        currentSettings.user.username = @"";
        currentSettings.user.userid = @"";
        currentSettings.team.teamid = @"";
        currentSettings.team.team_name = @"";
        currentSettings.team.team_logo = @"";
        [KeychainWrapper deleteItemFromKeychainWithIdentifier:PIN_SAVED];
        [KeychainWrapper deleteItemFromKeychainWithIdentifier:GOMOBIEMAIL];
        
        if ([httpResponse statusCode] == 200) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Logging Out"
                                                            message:[NSString stringWithFormat:@"%d", [httpResponse statusCode]]
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
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
    if (!sport) {
        currentSettings.team = [teamList objectAtIndex:indexPath.row];
        [[[EazesportzRetrieveAlerts alloc] init] retrieveAlerts:currentSettings.sport.id Team:currentSettings.team.teamid
                                                          Token:currentSettings.user.authtoken];        
        [[[EazesportzRetrievePlayers alloc] init] retrievePlayers:currentSettings.sport.id Team:currentSettings.team.teamid
                                                            Token:currentSettings.user.authtoken];
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
        editTeamIndexPath = indexPath;
        [self performSegueWithIdentifier:@"EditTeamSegue" sender:self];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Edit Team";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditTeamSegue"]) {
        EditTeamViewController *destController = segue.destinationViewController;
        destController.team = [teamList objectAtIndex:editTeamIndexPath.row];
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
