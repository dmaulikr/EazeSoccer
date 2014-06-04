//
//  EazesportzVisitingTeamViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/24/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzVisitingTeamViewController.h"
#import "EazesportzRetrieveVisitingTeams.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzVisitingTeamRosterViewController.h"

@interface EazesportzVisitingTeamViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzVisitingTeamViewController {
    EazesportzRetrieveVisitingTeams *visitingTeamList;
    VisitingTeam *team;
    
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
    visitingTeamList = [[EazesportzRetrieveVisitingTeams alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotVisitingTeams:) name:@"VisitingTeamListChangedNotification" object:nil];
    
    [visitingTeamList retrieveVisitingTeams:currentSettings.sport User:currentSettings.user];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)gotVisitingTeams:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        [_visitingTeamTableView reloadData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[[notification userInfo] objectForKey:@"Result"] delegate:nil
                                              cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"VisitorRosterSegue"]) {
        EazesportzVisitingTeamRosterViewController *destController = segue.destinationViewController;
        destController.visitingTeam = team;
    }
}

- (IBAction)saveButtonClicked:(id)sender {
    if ((![team.teamtitile isEqualToString:_teamnameTextField.text]) && (![team.mascot isEqualToString:_mascotTextField.text])) {
        team = [[VisitingTeam alloc] init];
        team.teamtitile = _teamnameTextField.text;
        team.mascot = _mascotTextField.text;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teamNotification:) name:@"VisitingTeamSavedNotification" object:nil];
    [team save:currentSettings.sport User:currentSettings.user];
}

- (void)teamNotification:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Update Successful!" delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error updating visiting team!" delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"VisitingTeamSavedNotification" object:nil];
    [visitingTeamList retrieveVisitingTeams:currentSettings.sport User:currentSettings.user];
}

- (IBAction)deleteButtonClicked:(id)sender {
    if (team.visiting_team_id.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                             message:@"Delete Visiting Team? All players on vsiting team roster will also be deleted." delegate:self
                                              cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
        [alert show];
    }
}

- (IBAction)rosterButtonClicked:(id)sender {
    if (team.teamtitile.length > 0)
        [self performSegueWithIdentifier:@"VisitorRosterSegue" sender:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return visitingTeamList.visitingTeams.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VisitingTeamTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    VisitingTeam *ateam = [visitingTeamList.visitingTeams objectAtIndex:indexPath.row];
    cell.textLabel.text = ateam.teamtitile;
    cell.detailTextLabel.text = ateam.mascot;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Visiting Teams";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([currentSettings isSiteOwner])
        return  YES;
    else
        return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    team = [visitingTeamList.visitingTeams objectAtIndex:indexPath.row];
    _teamnameTextField.text = team.teamtitile;
    _mascotTextField.text = team.mascot;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        deleteIndexPath = indexPath;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Delete Visiting Team?"
                                                       delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:@"Cancel", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Confirm"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teamDeleted:) name:@"VisitingTeamDeletedNotification" object:nil];
        [team deleteTeam:currentSettings.sport User:currentSettings.user];
    }
}

- (void)teamDeleted:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        _teamnameTextField.text = @"";
        _mascotTextField.text = @"";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Delete Successful!" delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error deleting visiting team!" delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"VisitingTeamDeletedNotification" object:nil];
    [visitingTeamList retrieveVisitingTeams:currentSettings.sport User:currentSettings.user];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
