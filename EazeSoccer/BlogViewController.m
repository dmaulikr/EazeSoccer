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
#import "PlayerSelectionViewController.h"
#import "HeaderSelectCollectionReusableView.h"
#import "CoachSelectionViewController.h"
#import "UsersViewController.h"
#import "BlogEntryViewController.h"
//#import "GamePlayViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface BlogViewController () <UIAlertViewDelegate>

@end

@implementation BlogViewController {
    NSMutableArray *serverData;
    int responseStatusCode;
    NSMutableData *theData;
    
    PlayerSelectionViewController *playerController;
    CoachSelectionViewController *coachController;
    UsersViewController *usersController;
//    GamePlayViewController *gameplayController;
    
    UIRefreshControl *refreshControl;
    BOOL refresh;
    NSIndexPath *deleteIndexPath;
}

@synthesize game;
@synthesize team;
@synthesize player;
@synthesize coach;
@synthesize user;
//@synthesize gamelog;
@synthesize gameController;
@synthesize blogfeed;
@synthesize activityIndicator;

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
    activityIndicator.hidesWhenStopped = YES;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.addBlogEntryButton, self.refreshButton, self.searchButton, self.teamButton, nil];
    
    self.navigationController.toolbarHidden = YES;
}

- (void)stopRefresh {
    [refreshControl endRefreshing];
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
    refresh = NO;
    
    [self getBlogs:nil];
}

- (void)displayUpgradeAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrade Required"
                         message:[NSString stringWithFormat:@"%@%@", @"Blog support not available for ", currentSettings.team.team_name]
                                                   delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Info", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
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
    
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptype"] isEqualToString:@"client"]) {
        if (blog.tinyavatar.length == 0) {
            image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
        } else if ((blog.tinyimage.CIImage == nil) && (blog.tinyimage.CGImage == nil)) {
            NSURL * imageURL = [NSURL URLWithString:blog.tinyavatar];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            image = [UIImage imageWithData:imageData];
            blog.tinyimage = image;
        } else
            image = blog.tinyimage;
    } else {
        if (blog.avatar.length == 0) {
            image = [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"photo_not_available.png"], 1)];
        } else if ((blog.thumbimage.CIImage == nil) && (blog.thumbimage.CGImage == nil)) {
            NSURL * imageURL = [NSURL URLWithString:blog.avatar];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            image = [UIImage imageWithData:imageData];
            blog.thumbimage = image;
        } else
            image = blog.thumbimage;
    }
    
    [cell.bloggerImage setImage:image];
    cell.blogEntryTextView.text = blog.entry;
    
    if (blog.athlete.length > 0)
        cell.playerLabel.text = [[currentSettings findAthlete:blog.athlete] logname];
    else {
        cell.playerLabel.text = @"";
    }
    
    if (blog.gameschedule.length > 0) {
        cell.gameLabel.text = [NSString stringWithFormat:@"%@%@", @"vs ", [[currentSettings findGame:blog.gameschedule] opponent_name]];
        
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
    if ([currentSettings isSiteOwner])
        return YES;
    else
        return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([currentSettings isSiteOwner]) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            deleteIndexPath = [_blogTableView indexPathForSelectedRow];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confrim"
                                                            message:@"Delete Blog Entry"
                                                           delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlayerSelectSegue"])
        playerController = segue.destinationViewController;
    else if ([segue.identifier isEqualToString:@"GameSelectSegue"])
        gameController = segue.destinationViewController;
    else if ([segue.identifier isEqualToString:@"BlogEntrySegue"]) {
        NSIndexPath *indexPath = [_blogTableView indexPathForSelectedRow];
        BlogEntryViewController *destController = segue.destinationViewController;
        destController.blog = [blogfeed objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"CoachSelectSegue"])
        coachController = segue.destinationViewController;
    else if ([segue.identifier isEqualToString:@"UserSelectSegue"]) {
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
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    NSLog(@"%@", serverData);
    
    if (responseStatusCode == 200) {
        
        if (refresh)
            [blogfeed addObjectsFromArray:[self extractBlogData:serverData]];
        else
            blogfeed = [self extractBlogData:serverData];
        
        [activityIndicator stopAnimating];
        
        if ((blogfeed.count == 0) && ((player) || (coach) || (user) || (game))) {
            NSString *criteria;
            
            if (player)
                criteria = player.logname;
            else if (coach)
                criteria = coach.fullname;
            else if (user)
                criteria = user.username;
            else if (game)
                criteria = game.game_name;
            else
                criteria = @"Search Criteria.";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Blogs" message:[NSString stringWithFormat:@"%@%@", @"No blogs for ", criteria]
                                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        } else if (blogfeed.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Blogs" message:@"No blogs entered for team"
                                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
        [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2.5];
        [_blogTableView reloadData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Blog Feed"
                                                        message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
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

- (IBAction)coachSelected:(UIStoryboardSegue *)segue {
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

- (IBAction)gameSelected:(UIStoryboardSegue *)segue {
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

- (IBAction)selectUser:(UIStoryboardSegue *)segue {
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

- (IBAction)searchBurronClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search" message:@"Select Search Criteria"
                delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Player", @"Game", @"User", @"Coach", @"All", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
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
    refresh = YES;
    Blog *lastblog = [blogfeed lastObject];
    [self getBlogs:lastblog.updatedat];
    [refreshControl endRefreshing];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

- (void)getBlogs:(NSString *)fromdate {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *urlstring;
    
    if (player) {
        urlstring = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",
                    [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                    @"/sports/", currentSettings.sport.id, @"/blogs.json?team_id=", currentSettings.team.teamid, @"&athlete_id=",
                    player.athleteid, @"&updated_at", fromdate];
        
        
    } else if (game) {
        urlstring = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                     @"/sports/", currentSettings.sport.id, @"/blogs.json?team_id=", currentSettings.team.teamid, @"&gameschedule_id=",
                     game.id, @"&updated_at", fromdate];
    } else if (coach) {
        urlstring = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                     @"/sports/", currentSettings.sport.id, @"/blogs.json?team_id=", currentSettings.team.teamid, @"&coach_id=",
                     game.id, @"&updated_at", fromdate];
    } else if (user) {
        urlstring = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                     @"/sports/", currentSettings.sport.id, @"/blogs.json?team_id=", currentSettings.team.teamid, @"&user_id=",
                     coach.coachid, @"&updated_at", fromdate];
//    } else if (gamelog) {
//        url = [NSURL URLWithString:[sportzServerInit getBigPlayBlogs:gamelog.gamelogid updatedAt:fromdate Token:currentSettings.user.authtoken]];
    } else if (team) {
        urlstring = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                     @"/sports/", currentSettings.sport.id, @"/blogs.json?team_id=", currentSettings.team.teamid, @"&updated_at", fromdate];
    }
    
    if (currentSettings.user.authtoken)
        urlstring = [urlstring stringByAppendingFormat:@"%@%@", @"&auth_token=", currentSettings.user.authtoken];
    
    NSURL *url = [NSURL URLWithString:urlstring];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [activityIndicator startAnimating];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"]) {
        if (![[blogfeed objectAtIndex:deleteIndexPath.row] initDeleteBlog]) {
            [blogfeed removeObjectAtIndex:deleteIndexPath.row];
            [_blogTableView reloadData];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[[blogfeed objectAtIndex:deleteIndexPath.row] httperror]
                                                           delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:@"Cancel", nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else if ([title isEqualToString:@"Player"]) {
        _playerSelectionContainer.hidden = NO;
        playerController.player = nil;
        [playerController viewWillAppear:YES];
    } else if ([title isEqualToString:@"Game"]) {
        _gameScheduleContainer.hidden = NO;
        gameController.thegame = nil;
        [gameController viewWillAppear:YES];
    } else if ([title isEqualToString:@"User"]) {
        _userContainer.hidden = NO;
        usersController.user = nil;
        [usersController viewWillAppear:YES];
    } else if ([title isEqualToString:@"Coach"]) {
        _coachSelectionContainer.hidden = NO;
        coachController.coach = nil;
        [coachController viewWillAppear:YES];
    } else if ([title isEqualToString:@"All"]) {
        team = currentSettings.team;
        player = nil;
        game = nil;
        coach = nil;
        user = nil;
        [self getBlogs:nil];
    } else if ([title isEqualToString:@"Info"]) {
        [self performSegueWithIdentifier:@"UpgradeInfoSegue" sender:self];
    } else if ([title isEqualToString:@"Dismiss"]) {
        self.tabBarController.selectedIndex = 0;
    }
}

- (IBAction)teamButtonClicked:(id)sender {
    currentSettings.team = nil;
    UITabBarController *tabBarController = self.tabBarController;
    
    for (UIViewController *viewController in tabBarController.viewControllers)
    {
        if ([viewController isKindOfClass:[UINavigationController class]])
            [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
    }
    
    UIView * fromView = tabBarController.selectedViewController.view;
    UIView * toView = [[tabBarController.viewControllers objectAtIndex:0] view];
    
    // Transition using a page curl.
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:(4 > tabBarController.selectedIndex ? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown)
                    completion:^(BOOL finished) {
                        if (finished) {
                            tabBarController.selectedIndex = 0;
                        }
                    }];
}

- (IBAction)playerSelected:(UIStoryboardSegue *)segue {
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


@end
