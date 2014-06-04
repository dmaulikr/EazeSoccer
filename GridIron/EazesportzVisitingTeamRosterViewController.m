//
//  EazesportzVisitingTeamRosterViewController.m
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 5/24/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazesportzVisitingTeamRosterViewController.h"
#import "EazesportzAppDelegate.h"

@interface EazesportzVisitingTeamRosterViewController () <UIAlertViewDelegate>

@end

@implementation EazesportzVisitingTeamRosterViewController {
    VisitorRoster *player;
    NSIndexPath *deleteIndexPath;
}


@synthesize visitingTeam;

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
    _numberTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveButtonClicked:(id)sender {
    if ((![[player.number stringValue] isEqualToString:_numberTextField.text]) || (![player.lastname isEqualToString:_lastnameTextField.text])) {
        player = [[VisitorRoster alloc] init];
        player.number = [ NSNumber numberWithInt:[_numberTextField.text intValue]];
        player.lastname = _lastnameTextField.text;
        player.firstname = _firstnameTextField.text;
        player.position = _positionTextField.text;
        player.visiting_team_id = visitingTeam.visiting_team_id;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rosterUpdated:) name:@"VisitorRosterSavedNotification" object:nil];
    [player save:currentSettings.sport User:currentSettings.user];
}

- (void)rosterUpdated:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Update Successful!" delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        [visitingTeam.visitor_roster addObject:player];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error updating player!" delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"VisitorRosterSavedNotification" object:nil];
    [visitingTeam refreshRoster];
    [_rosterTableView reloadData];
}

- (IBAction)deleteButtonClicked:(id)sender {
    if (player.visitor_roster_id.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Delete Player from Roster?" delegate:self cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Confirm", nil];
        [alert show];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return visitingTeam.visitor_roster.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VisitorRosterTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    VisitorRoster *aplayer = [visitingTeam.visitor_roster objectAtIndex:indexPath.row];
    cell.textLabel.text = aplayer.numberlogname;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Position: %@", aplayer.position];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%@ Players", visitingTeam.mascot];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([currentSettings isSiteOwner])
        return  YES;
    else
        return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    player = [visitingTeam.visitor_roster objectAtIndex:indexPath.row];
    _numberTextField.text = [player.number stringValue];
    _lastnameTextField.text = player.lastname;
    _firstnameTextField.text = player.firstname;
    _positionTextField.text = player.position;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        deleteIndexPath = indexPath;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Delete Visiting Player?"
                                                       delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:@"Cancel", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Confirm"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rosterDeleted:) name:@"VisitorRosterDeletedNotification" object:nil];
        [player deleteVisitorRoster:currentSettings.sport User:currentSettings.user];
    }
}

- (void)rosterDeleted:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        _numberTextField.text = @"";
        _lastnameTextField.text = @"";
        _firstnameTextField.text = @"";
        _positionTextField.text = @"";
        [visitingTeam.visitor_roster removeObject:player];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Delete Successful!" delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error deleting player!" delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"VisitorRosterDeletedNotification" object:nil];
    [visitingTeam refreshRoster];
    [_rosterTableView reloadData];
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
