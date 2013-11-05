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

@interface NewsTableViewController ()

@end

@implementation NewsTableViewController  {
    NSArray *serverData;
    NSMutableData *theData;
    NSMutableArray *newsfeed;
    int responseStatusCode;
    
    UIRefreshControl *refreshControl;
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    if ([[[NSDate alloc] init] timeIntervalSinceDate:currentSettings.lastAlertUpdate] > [currentSettings.sport.newsfeed_interval integerValue]) {
    [self getNews:nil];
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
    static NSString *CellIdentifier = @"Cell";
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
    
    if (feeditem.athlete.length > 0)
        cell.athleteLabel.text = [[currentSettings findAthlete:feeditem.athlete] full_name];
    else
        cell.athleteLabel.text = @"";
    
    if (feeditem.coach.length > 0)
        cell.coachLabel.text = [[currentSettings findCoach:feeditem.coach] fullname];
    else
        cell.coachLabel.text = @"";
    
    if (feeditem.game.length > 0)
        cell.gameLabel.text = [[currentSettings findGame:feeditem.game] game_name];
    else
        cell.gameLabel.text = @"";
    
    // Add image
    
    if (feeditem.athlete.length > 0) {
        cell.imageView.image = [[currentSettings findAthlete:feeditem.athlete] getImage:@"thumb"];
    } else if (feeditem.coach.length > 0) {
        cell.imageView.image = [[currentSettings findCoach:feeditem.coach] getImage:@"thumb"];
    } else if (feeditem.team.length > 0) {
        cell.imageView.image = [[currentSettings findTeam:feeditem.team] getImage:@"thumb"];
    }
    return cell;
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    [self getNews:lastnews.updated_at];
    [refreshControl endRefreshing];
}

- (void)getNews:(NSString *)fromdate {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url = [NSURL URLWithString:[sportzServerInit newsfeed:fromdate Token:currentSettings.user.authtoken]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

@end
