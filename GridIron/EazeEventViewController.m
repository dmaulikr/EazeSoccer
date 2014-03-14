//
//  EazeEventViewController.m
//  EazeSportz
//
//  Created by Gil on 3/13/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazeEventViewController.h"
#import "EazesportzRetrieveEvents.h"
#import "Event.h"
#import "EazeEventGameTableCell.h"
#import "EazeEventTableCell.h"
#import "EazeStartEndDateViewController.h"
#import "EazeGameSelectionViewController.h"

@interface EazeEventViewController ()

@end

@implementation EazeEventViewController {
    EazesportzRetrieveEvents *getEvents;
    NSDate *searchDate;
    NSString *searchName;
    EazeStartEndDateViewController *dateController;
    NSDate *beginsearchDate, *endsearchDate;
    EazeGameSelectionViewController *gameController;
    NSString *searchname;
    BOOL initialload;
}

@synthesize sport;
@synthesize team;
@synthesize user;

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
    initialload = YES;
    getEvents = [[EazesportzRetrieveEvents alloc] init];
    beginsearchDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:4];
    endsearchDate = [gregorian dateByAddingComponents:components toDate:beginsearchDate options:0];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.refreshButton, self.searchButton, nil];
    
    self.navigationController.toolbarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _dateContainer.hidden = YES;
    
    if (gameController) {
        if (gameController.thegame) {
            [self retrieveEvents];
        }
    } else if (searchname.length > 0) {
        [self retrieveEvents];
    } else {
        [self retrieveEvents];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search" message:@"Search for an Event"
                                          delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Name", @"Date", @"Game", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)refreshButtonClicked:(id)sender {
    [self retrieveEvents];
}

- (void)retrieveEvents {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotEvents:) name:@"EventListChangedNotification" object:nil];
    
    if (searchName) {
        getEvents.searchName = searchName;
        getEvents.game = nil;
    } else if (gameController.thegame) {
        getEvents.searchName = nil;
        getEvents.game = gameController.thegame;
    } else {
        getEvents.startdate = beginsearchDate;
        getEvents.enddate = endsearchDate;
        getEvents.searchName = nil;
        getEvents.game = nil;
    }
    
    [getEvents retrieveEvents:sport Team:team Token:user];
}

- (void)gotEvents:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EventListChangedNotification" object:nil];
    
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        if (getEvents.eventlist.count > 0)
            [_eventTableView reloadData];
        else {
            if (initialload) {
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MM-dd-yyyy"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                    message:[NSString stringWithFormat:@"No events for %@ from %@ to %@", team.team_name,
                                                             [dateFormat stringFromDate:beginsearchDate], [dateFormat stringFromDate:endsearchDate]]
                                                                   delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alertView show];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"No events found for search criteria."
                                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Refresh", nil];
                [alertView show];
            }
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[NSString stringWithFormat:@"%@. Try again?", [[notification userInfo] objectForKey:@"Resut"]]
                                                        delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Refresh", nil];
        [alertView show];
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
    return getEvents.eventlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [getEvents.eventlist objectAtIndex:indexPath.row];
    
    if ([event.videoevent intValue] == 1) {
        GameSchedule *game = [event getGame:sport Team:team User:user];
        EazeEventGameTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventGameTableCell" forIndexPath:indexPath];
        cell.eventLabel.text = @"Live Game!";
        cell.homeImageView.image = [team getImage:@"tiny"];
        cell.visitorImageView.image = game.vsimage;
        cell.hometeamLabel.text = team.mascot;
        cell.visitorTeamLabel.text = game.opponent_mascot;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM-dd-yyyy"];
        cell.dateLabel.text = [dateFormat stringFromDate:game.gamedatetime];
        cell.timeLabel.text = game.starttime;
        return cell;
    } else {
        EazeEventTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventTableCell" forIndexPath:indexPath];
        cell.eventLabel.text = event.eventname;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM-dd-yyyy"];
        cell.dateLabel.text = [dateFormat stringFromDate:event.startdate];
        dateFormat.dateFormat = @"HH:mm:ss";
        cell.starttimeLabel.text = [dateFormat stringFromDate:event.startdate];
        dateFormat.dateFormat =  @"MM-dd-yyyy";
        cell.dateLabel.text = [dateFormat stringFromDate:event.enddate];
        dateFormat.dateFormat = @"HH:mm:ss";
        cell.endtimeLabel.text = [dateFormat stringFromDate:event.enddate];
        cell.descriptionTextView.text = event.eventdesc;
        return cell;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    NSIndexPath *indexPath = [_eventTableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"DateSearchEventSegue"]) {
        dateController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"PlayEventSegue"]) {
        
    } else if ([segue.identifier isEqualToString:@"GameSelectSegue"]) {
        gameController = segue.destinationViewController;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *today = [NSDate date];
    Event *selectedEvent = [getEvents.eventlist objectAtIndex:indexPath.row];
    
    if (([today compare:selectedEvent.startdate] == NSOrderedDescending) && ([today compare:selectedEvent.enddate] == NSOrderedAscending)) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@.m3u8", sport.streamingurl, selectedEvent.event_id, team.teamid]];
        
        _moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL:url];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
        
        _moviePlayer.controlStyle = MPMovieControlStyleDefault;
        _moviePlayer.shouldAutoplay = YES;
        [self.view addSubview:_moviePlayer.view];
        [_moviePlayer setFullscreen:YES animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Event is not being broadcast at this time." delegate:self
                                              cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    
    if ([player respondsToSelector:@selector(setFullscreen:animated:)]) {
        [player.view removeFromSuperview];
    }
}

- (IBAction)datesSelected:(UIStoryboardSegue *)segue {
    beginsearchDate = dateController.startDate;
    endsearchDate = dateController.endDate;
    searchName = nil;
    gameController.thegame = nil;
    _dateContainer.hidden = YES;
    [self retrieveEvents];
}

- (IBAction)datesSelectCanceled:(UIStoryboardSegue *)segue {
    _dateContainer.hidden = YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (searchName) {
        return [NSString stringWithFormat:@"Live Events for %@", searchName];
    } else if (gameController.thegame) {
        return [NSString stringWithFormat:@"Events for game %@", [gameController.thegame vsOpponent]];
    } else {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM-dd-yyyy HH:mm"];
        return [NSString stringWithFormat:@"%@ to %@", [dateFormat stringFromDate:beginsearchDate], [dateFormat stringFromDate:endsearchDate]];
    }
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
    
    if ([title isEqualToString:@"Date"]) {
        _dateContainer.hidden = NO;
    } else if ([title isEqualToString:@"Name"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Search" message:@"Enter event name" delegate:self cancelButtonTitle:@"Submit" otherButtonTitles:@"Skip", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertView show];
    } else if ([title isEqualToString:@"Game"]) {
        [self performSegueWithIdentifier:@"GameSelectSegue" sender:self];
    } else if ([title isEqualToString:@"Refresh"]) {
        [self retrieveEvents];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Submit"]) {
        UITextField *nameInput = [alertView textFieldAtIndex:0];
        if (nameInput.text.length > 0) {
            searchName = nameInput.text;
            gameController.thegame = nil;
            [self retrieveEvents];
        }
    }
}

@end
