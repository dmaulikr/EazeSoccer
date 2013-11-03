//
//  BlogViewController.m
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/5/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "BlogViewController.h"
#import "BlogCell.h"
#import "Blog.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "sportzServerInit.h"
#import "sportzteamsCoachDataJSON.h"
#import "PlayerSelectionViewController.h"
#import "HeaderSelectCollectionReusableView.h"
#import "CoachSelectionViewController.h"
#import "UsersViewController.h"
#import "BlogEntryViewController.h"
#import "GameScheduleViewController.h"
//#import "GamePlayViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface BlogViewController ()

@end

@implementation BlogViewController {
    NSMutableArray *blogfeed;
    NSMutableArray *serverData;
    int responseStatusCode;
    NSMutableData *theData;
    
    PlayerSelectionViewController *playerController;
    CoachSelectionViewController *coachController;
    GameScheduleViewController *gameController;
    UsersViewController *usersController;
//    GamePlayViewController *gameplayController;
    
    UIRefreshControl *refreshControl;
}

@synthesize game;
@synthesize team;
@synthesize player;
@synthesize coach;
@synthesize user;
//@synthesize gamelog;

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
    team = currentSettings.team;

    refreshControl = UIRefreshControl.alloc.init;
    [refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
    [_blogTableView addSubview:refreshControl];
    _activityIndicator.hidesWhenStopped = YES;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.addBlogEntryButton, self.refreshButton, nil];
    
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _playerSelectionContainer.hidden = YES;
    _coachSelectionContainer.hidden = YES;
    _gameScheduleContainer.hidden = YES;
    _userContainer.hidden = YES;
    [self getBlogs:nil];
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
    return blogfeed.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BlogTableCell";
    BlogCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[BlogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Blog *blog;
    
    blog = [blogfeed objectAtIndex:indexPath.row];
    
    UIImage *image;
    
    if (blog.tinyavatar.length == 0) {
        image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
    } else if ((blog.tinyimage.CIImage == nil) && (blog.tinyimage.CGImage == nil)) {
        NSURL * imageURL = [NSURL URLWithString:blog.tinyavatar];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        image = [UIImage imageWithData:imageData];
        blog.tinyimage = image;
    } else
        image = blog.tinyimage;
    
    [cell.bloggerImage setImage:image];
    cell.blogEntryTextView.text = blog.entry;
    
    if (blog.athlete.length > 0)
        cell.playerLabel.text = [[currentSettings findAthlete:blog.athlete] logname];
    else {
        cell.playerLabel.text = @"";
    }
    
    if (blog.gameschedule.length > 0) {
        cell.gameLabel.text = [[currentSettings findGame:blog.gameschedule] game_name];
        
        //        if (blog.gamelog.length > 0)
        //            cell.gameplaylabel.text = [[[currentSettings findGame:blog.gameschedule] findGamelog:blog.gamelog] logentry];
        //        else
        
    } else {
        cell.gameLabel.text = @"";
    }
    
    if (blog.coach.length > 0)
        cell.coachLabel.text = [[currentSettings findCoach:blog.coach] fullname];
    else {
        cell.coachLabel.text = @"";
    }
    
    cell.bloggerUser.text = blog.username;
    cell.blogTitle.text = blog.blogtitle;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Monitor Blog";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayerSelectionSegue"])
        playerController = segue.destinationViewController;
    else if ([segue.identifier isEqualToString:@"GameSelectionSegue"])
        gameController = segue.destinationViewController;
    else if ([segue.identifier isEqualToString:@"BlogEntrySegue"]) {
        NSIndexPath *indexPath = [_blogTableView indexPathForSelectedRow];
        BlogEntryViewController *destController = segue.destinationViewController;
        destController.blog = [blogfeed objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"CoachSelectionSegue"]) {
        coachController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"UsersSegue"]) {
        usersController = segue.destinationViewController;
//    } else if ([segue.identifier isEqualToString:@"GamePlaySelectionSegue"]) {
//        gameplayController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"NewBlogEntry"]) {
        BlogEntryViewController *destController = segue.destinationViewController;
        destController.blog = nil;
    }
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
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:nil error:nil];
    NSLog(@"%@", serverData);
    
    if (responseStatusCode == 200) {
        blogfeed = [self extractBlogData:serverData];
        [_activityIndicator stopAnimating];
        [_blogTableView reloadData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Blog Feed"
                                                        message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (IBAction)gameButtonClicked:(id)sender {
    _gameScheduleContainer.hidden = NO;
    [gameController viewWillAppear:YES];
}

- (IBAction)allButtonClicked:(id)sender {
    team = currentSettings.team;
    player = nil;
    game = nil;
    coach = nil;
    user = nil;
    [self getBlogs:nil];
}

- (IBAction)newBlogButtonClicked:(id)sender {
    game = nil;
    user = nil;
    team = nil;
    game = nil;
    [self performSegueWithIdentifier:@"BlogEntrySegue" sender:self];
}

- (IBAction)userButtonClicked:(id)sender {
    _userContainer.hidden = NO;
}

- (IBAction)playerButtonClicked:(id)sender {
    _playerSelectionContainer.hidden = NO;
    [playerController viewWillAppear:YES];
}

- (IBAction)coachButtonClicked:(id)sender {
    _coachSelectionContainer.hidden = NO;
    [coachController viewWillAppear:YES];
}

- (IBAction)selectBlogSearchPlayer:(UIStoryboardSegue *)segue {
    player = playerController.player;
    
    if (player != nil) {
        game = nil;
        team = nil;
        coach = nil;
        user = nil;
//        gamelog = nil;
        [self getBlogs:nil];
     }
    _playerSelectionContainer.hidden = YES;
}

- (IBAction)selectBlogSearchCoach:(UIStoryboardSegue *)segue {
    coach = coachController.coach;
    
    if (coach != nil) {
        game = nil;
        player = nil;
        team = nil;
        user = nil;
//        gamelog = nil;
        [self getBlogs:nil];
    }
    _coachSelectionContainer.hidden = YES;
}

- (IBAction)selectBlogSearchGame:(UIStoryboardSegue *)segue {
    game = gameController.thegame;
    
    if (game != nil) {
        team = nil;
        player = nil;
        coach = nil;
        user = nil;
//        gamelog = nil;
        [self getBlogs:nil];
    }
    _gameScheduleContainer.hidden = YES;
}

- (IBAction)selectBlogSearchUser:(UIStoryboardSegue *)segue {
    user = usersController.user;
    
    if (user != nil) {
        game = nil;
        player = nil;
        team = nil;
        coach = nil;
//        gamelog = nil;
        [self getBlogs:nil];
    }
    _userContainer.hidden = YES;
}

- (IBAction)blogCellUserButtonClicked:(id)sender {
    NSLog(@"%@", @"I am here");
}

- (IBAction)refreshButtonClicked:(id)sender {
    [self getBlogs:nil];
}

- (NSMutableArray *)extractBlogData:(NSArray *)blogdict {
    NSMutableArray *blogs = [[NSMutableArray alloc] init];
    for (int i = 0; i < [blogdict count]; i++) {
        [blogs addObject:[[Blog alloc] initWithDictionary:[blogdict objectAtIndex:i]]];
    }
    
    return blogs;
}

- (void)startRefresh {
    Blog *lastblog = [blogfeed lastObject];
    [self getBlogs:lastblog.updatedat];
    [refreshControl endRefreshing];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

- (void)getBlogs:(NSString *)fromdate {
    NSURL *url;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if (player) {
        url = [NSURL URLWithString:[sportzServerInit getAthleteBlogs:player.athleteid updatedAt:fromdate
                                                                      Token:currentSettings.user.authtoken]];
    } else if (game) {
        url = [NSURL URLWithString:[sportzServerInit getGameBlogs:game.id updatedAt:fromdate Token:currentSettings.user.authtoken]];
    } else if (coach) {
        url = [NSURL URLWithString:[sportzServerInit getCoachBlogs:coach.coachid updatedAt:fromdate Token:currentSettings.user.authtoken]];
    } else if (user) {
        url = [NSURL URLWithString:[sportzServerInit getUserBlogs:user.userid updatedAt:fromdate Token:currentSettings.user.authtoken]];
//    } else if (gamelog) {
//        url = [NSURL URLWithString:[sportzServerInit getBigPlayBlogs:gamelog.gamelogid updatedAt:fromdate Token:currentSettings.user.authtoken]];
    } else {
        url = [NSURL URLWithString:[sportzServerInit getBlogs:currentSettings.team.teamid updatedAt:fromdate Token:currentSettings.user.authtoken]];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_activityIndicator startAnimating];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

@end
