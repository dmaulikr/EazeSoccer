//
//  EazNewsViewController.m
//  EazeSportz
//
//  Created by Gil on 1/17/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazeNewsViewController.h"
#import "EazesportzAppDelegate.h"
#import "Newsfeed.h"
#import "NewsTableCell.h"
#import "EazesportzRetrieveTeams.h"
#import "EazesportzRetrieveSport.h"
#import "EazesportzRetrieveGames.h"
#import "EazesportzRetrievePlayers.h"
#import "EazesportzRetrieveCoaches.h"
#import "EazesportzRetrieveSponsors.h"
#import "EazesportzRetrieveAlerts.h"
#import "EazeNewsFeedInfoViewController.h"
#import "sportzServerInit.h"

#import <QuartzCore/QuartzCore.h>

@interface EazeNewsViewController () <UIAlertViewDelegate>

@end

@implementation EazeNewsViewController {
    EazesportzRetrieveTeams *getTeams;
    
    NSArray *serverData;
    NSMutableData *theData;
    int responseStatusCode;
    
    UIRefreshControl *refreshControl;

    NSMutableArray *newsfeed;
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
    
    refreshControl = UIRefreshControl.alloc.init;
    [refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    _activityIndicator.hidesWhenStopped = YES;
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    //    [super viewWillAppear:animated];

    if (currentSettings.sitechanged) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains
        (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        //make a file name to write the data to using the documents directory:
        NSString *fileName = [NSString stringWithFormat:@"%@/currentsite.txt",
                              documentsDirectory];
        NSString *content = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
        
        newsfeed = [[NSMutableArray alloc] init];
        [_tableView reloadData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotSportData:) name:@"SportChangedNotification" object:nil];
        [[[EazesportzRetrieveSport alloc] init] retrieveSport:content Token:currentSettings.user.authtoken];
    } else if (currentSettings.sport.id.length == 0) {
        [self performSegueWithIdentifier:@"FindSiteSegue" sender:self];
    } else if ([currentSettings.sport isPackageEnabled]) {
        if (currentSettings.teams.count == 1) {
            if ([currentSettings.sport isPackageEnabled])
                self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.cameraButton, self.contactsButton, nil];
            else
                self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.contactsButton, nil];
            
            self.title = @"News";
        } else {
            if ([currentSettings.sport isPackageEnabled])
                self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.cameraButton, self.contactsButton, self.teamButton, nil];
            else
                self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.contactsButton, self.teamButton, nil];
        }
    }
    
    _teamPicker.hidden = YES;
    _teamButton.enabled = NO;
    
    if (currentSettings.teams.count > 0)
        _teamButton.enabled = YES;
    else if (currentSettings.teams.count == 1) {
        _teamButton.enabled = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startRefresh {
    [self getNews:nil];
}

- (void)gotSportData:(NSNotification *)notification {
    if ([[[notification userInfo] valueForKey:@"Result"] isEqualToString:@"Success"]) {
        currentSettings.sitechanged = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotTeamData:) name:@"TeamListChangedNotification" object:nil];
        getTeams = [[EazesportzRetrieveTeams alloc] init];
        [getTeams retrieveTeams:currentSettings.sport.id Token:currentSettings.user.authtoken];
    } else {
        if ([[[notification userInfo] valueForKey:@"Result"] isEqualToString:@"Not Found"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Found" message:@"Site not found. Maybe the admin deleted it?"
                                                           delegate:self cancelButtonTitle:@"Find Site" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failure retrieving sport data!"
                                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
}

- (void)gotTeamData:(NSNotification *)notification {
    
    if ([currentSettings.sport.teamcount intValue] > 1) {
        _teamPicker.hidden = NO;
        currentSettings.teams = getTeams.teams;
        [_teamPicker reloadAllComponents];
    } else {
        currentSettings.team = [getTeams.teams objectAtIndex:0];
        currentSettings.teams =getTeams.teams;
        [self teamSelected];
   }
}

- (void)gotAllData:(NSNotification *)notification {
    [self getNews:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return newsfeed.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsTableCell";
    NewsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    Newsfeed *feeditem = [newsfeed objectAtIndex:indexPath.row];
    
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
    } else {
        cell.imageView.image = [currentSettings.team getImage:@"tiny"];
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"NewsInfoSegue"]) {
        EazeNewsFeedInfoViewController *destController = segue.destinationViewController;
        destController.newsitem = [newsfeed objectAtIndex:indexPath.row];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ((newsfeed.count > 0) && (currentSettings.team.teamid.length > 0))
        return [NSString stringWithFormat:@"%@%@", @"News for ", currentSettings.team.team_name];
    else if (currentSettings.team.teamid.length > 0)
        return [NSString stringWithFormat:@"%@%@", @"No news for ", currentSettings.team.team_name];
    else
        return @"";
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
    [_activityIndicator startAnimating];
    currentSettings.team = [currentSettings.teams objectAtIndex:row];
    [self teamSelected];
}

- (void)teamSelected {
    _teamButton.enabled = YES;
    _teamPicker.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotAllData:) name:@"RosterChangedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotAllData:) name:@"GameListChangedNotification" object:nil];
    
    [[[EazesportzRetrievePlayers alloc] init] retrievePlayers:currentSettings.sport.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken];
    [[[EazesportzRetrieveGames alloc] init] retrieveGames:currentSettings.sport.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken];
    [[[EazesportzRetrieveCoaches alloc] init] retrieveCoaches:currentSettings.sport.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken];
    [[[EazesportzRetrieveSponsors alloc] init] retrieveSponsors:currentSettings.sport.id Token:currentSettings.user.authtoken];
    
    if (currentSettings.user.userid.length > 0) {
        [[[EazesportzRetrieveAlerts alloc] init] retrieveAlerts:currentSettings.sport.id Team:currentSettings.team.teamid
                                                            Token:currentSettings.user.authtoken];
    }
    newsfeed = [[NSMutableArray alloc] init];
    
    if (currentSettings.teams.count == 1) {
        if ([currentSettings.sport isPackageEnabled])
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.cameraButton, self.contactsButton, nil];
        else
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.contactsButton, nil];
        
        self.title = @"News";
    } else {
        if ([currentSettings.sport isPackageEnabled])
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.cameraButton, self.contactsButton, self.teamButton, nil];
        else
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.contactsButton, self.teamButton, nil];
    }
}

- (void)getNews:(BOOL)allnews {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url;
    
    if (currentSettings.user.authtoken)
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                    @"/sports/", currentSettings.sport.id, @"/newsfeeds.json?team_id=", currentSettings.team.teamid,
                                    @"&auth_token=", currentSettings.user.authtoken]];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                    @"/sports/", currentSettings.sport.id, @"/newsfeeds.json?team_id=", currentSettings.team.teamid]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    responseStatusCode = [httpResponse statusCode];
    theData = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [theData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The download cound not complete - please make sure you're connected to either 3G or WI-FI" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [errorView show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [_activityIndicator stopAnimating];
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    newsfeed = [[NSMutableArray alloc] init];
    
    if (responseStatusCode == 200) {
        
        for (int i = 0; i < [serverData count]; i++) {
            [newsfeed addObject:[[Newsfeed alloc] initWithDirectory:[serverData objectAtIndex:i]]];
        }
        
        [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2.5];
        [self.tableView reloadData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Newsfeed"
                                                        message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)stopRefresh {
    [refreshControl endRefreshing];
}

- (IBAction)teamButtonClicked:(id)sender {
    _teamPicker.hidden = NO;
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    _bannerView.hidden = NO;
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    _bannerView.hidden = YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Find Site"]) {
        [self performSegueWithIdentifier:@"FindSiteSegue" sender:self];
    }
}

@end
