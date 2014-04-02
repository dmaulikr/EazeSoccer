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
#import "EazesportzRetrieveTeams.h"
#import "EazesportzRetrieveSport.h"
#import "EazesportzRetrieveGames.h"
#import "EazesportzRetrievePlayers.h"
#import "EazesportzRetrieveCoaches.h"
#import "EazesportzRetrieveSponsors.h"
#import "EazesportzRetrieveAlerts.h"

@interface EazesportzNewsTableViewController ()

@end

@implementation EazesportzNewsTableViewController {
    EazesportzRetrieveTeams *getTeams;
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
    
    getTeams = [[EazesportzRetrieveTeams alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/currentsite.txt",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    
    if ((content) && (![currentSettings.sport.id isEqualToString:content])) {
        NSLog(@"%@", content);
        
        [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];
        [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:TRUE];
        [[[[self.tabBarController tabBar]items]objectAtIndex:3]setEnabled:TRUE];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotSportData:) name:@"SportChangedNotification" object:nil];
        [[[EazesportzRetrieveSport alloc] init] retrieveSport:content Token:currentSettings.user.authtoken];
    } else if (currentSettings.sport.id.length == 0) {
        [self performSegueWithIdentifier:@"FindSiteSegue" sender:self];
    }
    
    if ([currentSettings.sport isPackageEnabled]) {
        
    }
    
    _teamPicker.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)gotSportData:(NSNotification *)notification {
    if ([[[notification userInfo] valueForKey:@"Result"] isEqualToString:@"Success"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotTeamData:) name:@"TeamListChangedNotification" object:nil];
        [getTeams retrieveTeams:currentSettings.sport.id Token:currentSettings.user.authtoken];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failure retrieving sport data!"
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)gotTeamData:(NSNotification *)notification {
    
    if ([currentSettings.sport.teamcount intValue] > 1) {
        _teamPicker.hidden = NO;
        currentSettings.teams = getTeams.teams;
        [_teamPicker reloadAllComponents];
    } else {
        currentSettings.team = [currentSettings.teams objectAtIndex:0];
    }
}

- (void)gotAllData:(NSNotification *)notification {
    if ((currentSettings.roster.count > 0) && (currentSettings.gameList.count > 0))
        [self getNews:nil AllNews:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsTableCell";
    NewsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    Newsfeed *feeditem = [self.newsfeed objectAtIndex:indexPath.row];
    
    cell.newsTitleLabel.text = feeditem.title;
    cell.newsTextView.text = feeditem.news;
    
    if (feeditem.team.length > 0)
        cell.teamLabel.text = [[currentSettings findTeam:feeditem.team] team_name];
    else
        cell.teamLabel.text = @"";
    
    if (feeditem.athlete.length > 0) {
        cell.athleteLabel.text = [[currentSettings findAthlete:feeditem.athlete] logname];
    } else {
        cell.athleteLabel.text = @"";
    }
    
    if (feeditem.coach.length > 0) {
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
        cell.imageView.image = [currentSettings getRosterTinyImage:[currentSettings findAthlete:feeditem.athlete]];
    } else if (feeditem.coach.length > 0) {
        cell.imageView.image = [[currentSettings findCoach:feeditem.coach] getImage:@"tiny"];
    } else {
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// Method to define the numberOfRows in a component using the array.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component {
    return currentSettings.teams.count;
}

// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[currentSettings.teams objectAtIndex:row] team_name];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    currentSettings.team = [currentSettings.teams objectAtIndex:row];
    _teamPicker.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotAllData:) name:@"RosterChangedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotAllData:) name:@"GameListChangedNotification" object:nil];

    [[[EazesportzRetrievePlayers alloc] init] retrievePlayers:currentSettings.sport.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken];
    [[[EazesportzRetrieveGames alloc] init] retrieveGames:currentSettings.sport.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken];
    [[[EazesportzRetrieveCoaches alloc] init] retrieveCoaches:currentSettings.sport.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken];
    [[[EazesportzRetrieveSponsors alloc] init] retrieveSponsors:currentSettings.sport.id Token:currentSettings.user.authtoken];
//    [[[EazesportzRetrieveAlerts alloc] init] retrieveAlerts:currentSettings.sport.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken];
}

@end
