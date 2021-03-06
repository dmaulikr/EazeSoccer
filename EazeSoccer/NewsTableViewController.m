//
//  NewsTableViewController.m
//  EazeSportz
//
//  Created by Gil on 11/3/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "NewsTableViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "sportzServerInit.h"
#import "NewsFeedEditViewController.h"
#import "NewsTableCell.h"
#import "EazesportzRetrieveVideos.h"

@interface NewsTableViewController () <UIAlertViewDelegate>

@end

@implementation NewsTableViewController  {
    NSArray *serverData;
    NSMutableData *theData;
    int responseStatusCode;
    
    UIRefreshControl *refreshControl;
    
    NSIndexPath *deleteIndex;
}

@synthesize newsfeed;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    refreshControl = UIRefreshControl.alloc.init;
    [refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.addButton, self.searchButton, self.teamButton, nil];
    
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)stopRefresh {
    [refreshControl endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    if ([[[NSDate alloc] init] timeIntervalSinceDate:currentSettings.lastAlertUpdate] > [currentSettings.sport.newsfeed_interval integerValue]) {
    [self getNews:nil AllNews:YES];
    //    }
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
    return newsfeed.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsTableCell";
    NewsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.tag = indexPath.row;
    
    Newsfeed *feeditem = [newsfeed objectAtIndex:indexPath.row];
    
    cell.newsTitleLabel.text = feeditem.title;
    cell.newsTextView.text = feeditem.news;
    cell.newsTextView.editable = NO;
    
    if (feeditem.team.length > 0)
        cell.teamLabel.text = [[currentSettings findTeam:feeditem.team] team_name];
    else
        cell.teamLabel.text = @"";
    
    if (feeditem.athlete.length > 0)
        cell.athleteLabel.text = [[currentSettings findAthlete:feeditem.athlete] full_name];
    else
        cell.athleteLabel.text = @"";
    
    if (feeditem.coach.length > 0)
        cell.coachLabel.text = [[currentSettings findCoach:feeditem.coach] fullname];
    else
        cell.coachLabel.text = @"";
    
    if (feeditem.game.length > 0)
        cell.gameLabel.text = [[currentSettings findGame:feeditem.game] vsOpponent];
    else
        cell.gameLabel.text = @"";
    
    if (feeditem.videoclip_id.length > 0) {
        if (feeditem.videoPoster == nil) {
            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //this will start the image loading in bg
            dispatch_async(concurrentQueue, ^{
                Video *video = [[[EazesportzRetrieveVideos alloc] init] getVideoSynchronous:currentSettings.sport Team:currentSettings.team
                                                                                    VideoId:feeditem.videoclip_id User:currentSettings.user];
                NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:video.poster_url]];
                
                //this will set the image when loading is finished
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (cell.tag == indexPath.row) {
                        UIImage *animage = [UIImage imageWithData:image];
                        cell.imageView.image = [currentSettings normalizedImage:animage scaledToSize:50];
                        [cell setNeedsLayout];
                    }
                });
            });
        } else {
            cell.imageView.image = [currentSettings normalizedImage:feeditem.videoPoster scaledToSize:50];
        }
    } else if (feeditem.tinyurl.length > 0) {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:feeditem.tinyurl]];
            
            //this will set the image when loading is finished
            dispatch_async(dispatch_get_main_queue(), ^{
                if (cell.tag == indexPath.row) {
                    cell.imageView.image = [UIImage imageWithData:image];
                    [cell setNeedsLayout];
                }
            });
        });
    } else if (feeditem.athlete.length > 0) {
        cell.imageView.image = [currentSettings normalizedImage:[currentSettings getRosterTinyImage:[currentSettings findAthlete:feeditem.athlete]] scaledToSize:50];
    } else if (feeditem.game.length > 0) {
        cell.imageView.image = [currentSettings normalizedImage:[currentSettings getOpponentImage:[currentSettings findGame:feeditem.game]] scaledToSize:50];
    } else if (feeditem.coach.length > 0) {
        cell.imageView.image = [[currentSettings findCoach:feeditem.coach] tinyimage];
    } else {
        cell.imageView.image = [currentSettings.team getImage:@"tiny"];
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%@%@", currentSettings.sport.sitename, @" News"];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        deleteIndex = indexPath;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm!" message:@"Delete News Entry?"
                                                       delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:@"Cancel", nil];
        
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"EditNewsItemSegue"]) {
        NewsFeedEditViewController *destViewController = segue.destinationViewController;
        destViewController.newsitem = [newsfeed objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"NewNewsFeedSegue"]) {
        NewsFeedEditViewController *destController = segue.destinationViewController;
        destController.newsitem = nil;
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
    newsfeed = [[NSMutableArray alloc] init];
    
    if (responseStatusCode == 200) {
        for (int i = 0; i < [serverData count]; i++) {
            [newsfeed addObject:[[Newsfeed alloc] initWithDirectory:[serverData objectAtIndex:i]]];
        }
        if ([newsfeed count] == 0) {
            NSString * nonews = @"No news entered for ";
            nonews = [nonews stringByAppendingString:currentSettings.sport.sitename];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No News!"
                                                            message:@"Adminstrator has not created any news."
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
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

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [newsfeed count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (void)startRefresh {
    Newsfeed *lastnews = [newsfeed lastObject];
    [self getNews:lastnews.updated_at AllNews:YES];
    [refreshControl endRefreshing];
}

- (void)getNews:(NSString *)updated_at AllNews:(BOOL)allnews {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url;
    
    if (allnews) {
        if (currentSettings.user.authtoken)
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                   @"/sports/", currentSettings.sport.id, @"/newsfeeds.json?auth_token=", currentSettings.user.authtoken]];
        else
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/newsfeeds.json"]];
    } else {
        if (currentSettings.user.authtoken)
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/newsfeeds.json?auth_token=", currentSettings.user.authtoken,
                                        @"&team_id=", currentSettings.team.teamid]];
        else
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl"],
                                        @"/sports/", currentSettings.sport.id, @"/newsfeeds.json?&team_id=", currentSettings.team.teamid]];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"]) {
        if (![[newsfeed objectAtIndex:deleteIndex.row] initDeleteNewsFeed]) {
            [newsfeed removeObjectAtIndex:deleteIndex.row];
            [self.tableView reloadData];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error deleting News Item"
                                                            message:[[newsfeed objectAtIndex:deleteIndex.row] httperror]
                                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else if ([title isEqualToString:@"All"]) {
        [self getNews:nil AllNews:YES];
    } else if ([title isEqualToString:currentSettings.team.team_name]) {
        [self getNews:nil AllNews:NO];
    }
}

- (IBAction)changeTeamButtonClicked:(id)sender {
    currentSettings.team = nil;
    UITabBarController *tabBarController = self.tabBarController;
    
    for (UIViewController *viewController in tabBarController.viewControllers)
    {
        if ([viewController isKindOfClass:[UINavigationController class]])
            [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
    }
    
    UIView * fromView = tabBarController.selectedViewController.view;
    UIView * toView = [[tabBarController.viewControllers objectAtIndex:0] view];
    currentSettings.selectedTab = tabBarController.selectedIndex;
    
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

- (IBAction)searchButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sort News"
                                        message:[NSString stringWithFormat:@"%@%@", @"Get all news for program or news for ", currentSettings.team.team_name ]
                                        delegate:self cancelButtonTitle:@"All" otherButtonTitles:currentSettings.team.team_name, nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

@end
