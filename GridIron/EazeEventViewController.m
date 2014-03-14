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

@interface EazeEventViewController ()

@end

@implementation EazeEventViewController {
    EazesportzRetrieveEvents *getEvents;
}

@synthesize sport;
@synthesize team;
@synthesize game;
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    getEvents = [[EazesportzRetrieveEvents alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotEvents:) name:@"EventListChangedNotification" object:nil];
    [getEvents retrieveEvents:sport Team:team Token:user];
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
}

- (IBAction)refreshButtonClicked:(id)sender {
}

- (void)gotEvents:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EventListChangedNotification" object:nil];
    
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        [_eventTableView reloadData];
    } else {
        
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
    static NSString *CellIdentifier;
    
    CellIdentifier = @"EventTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    // Add image
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Live Events for %@", team.team_name];
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
    }
}

@end
