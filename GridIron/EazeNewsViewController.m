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
#import "EazeNewsFeedInfoViewController.h"
#import "EazesportzRetrieveNews.h"
#import "EazeWebViewController.h"
#import "EazesportzRetrieveVideos.h"

#import <QuartzCore/QuartzCore.h>

@interface EazeNewsViewController () <UIAlertViewDelegate>

@end

@implementation EazeNewsViewController {
    EazesportzRetrieveNews *getNews;
    UIRefreshControl *refreshControl;
}

@synthesize news;

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
    
//    refreshControl = UIRefreshControl.alloc.init;
//    [refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
//    [self.tableView addSubview:refreshControl];
    _activityIndicator.hidesWhenStopped = YES;
    getNews = [[EazesportzRetrieveNews alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    //    [super viewWillAppear:animated];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotNews:) name:@"NewsListChangedNotification" object:nil];
    
    if (getNews.news.count == 0) {
        [self startRefresh];
    }
    
    if (currentSettings.sport.hideAds)
        _bannerView.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startRefresh {
    [_activityIndicator startAnimating];
    [getNews retrieveNews:currentSettings.sport Team:currentSettings.team User:currentSettings.user];
}

- (void)gotNews:(NSNotification *)notification {
    if ([[[notification userInfo] objectForKey:@"Result"] isEqualToString:@"Success"]) {
        [_activityIndicator stopAnimating];
        [_tableView reloadData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"Error getting news!" delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
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
    return getNews.news.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Newsfeed *feeditem = [getNews.news objectAtIndex:indexPath.row];
    static NSString *CellIdentifier;
    
    CellIdentifier = @"NewsTableCell";    
    NewsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.tag = indexPath.row;
    
    cell.newsTitleLabel.numberOfLines = 3;
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
                    [_tableView reloadData];
                    [cell setNeedsLayout];
                }
            });
        });
    } else if (feeditem.athlete.length > 0) {
        cell.imageView.image = [currentSettings normalizedImage:[[currentSettings findAthlete:feeditem.athlete] getImage:@"tiny"] scaledToSize:50];
    } else if (feeditem.game.length > 0) {
        cell.imageView.image = [currentSettings normalizedImage:[[currentSettings findGame:feeditem.game] vsimage] scaledToSize:50];
    } else if (feeditem.coach.length > 0) {
        cell.imageView.image = [[currentSettings findCoach:feeditem.coach] getImage:@"tiny"];
    } else {
        cell.imageView.image = [currentSettings.team getImage:@"tiny"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Newsfeed *newsitem = [getNews.news objectAtIndex:indexPath.row];
    
    if (newsitem.external_url.length > 0) {
        [self performSegueWithIdentifier:@"NewsExternalUrlSegue" sender:self];
    } else {
        [self performSegueWithIdentifier:@"NewsInfoSegue" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"NewsInfoSegue"]) {
        EazeNewsFeedInfoViewController *destController = segue.destinationViewController;
        destController.newsitem = [getNews.news objectAtIndex:indexPath.row];
    } else if ([segue.identifier isEqualToString:@"NewsExternalUrlSegue"]) {
        EazeWebViewController *destController = segue.destinationViewController;
        destController.external_url = [NSURL URLWithString:[[getNews.news objectAtIndex:indexPath.row] external_url]];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ((getNews.news.count > 0) && (currentSettings.team.teamid.length > 0))
        return [NSString stringWithFormat:@"%@%@", @"News for ", currentSettings.team.team_name];
    else if (currentSettings.team.teamid.length > 0)
        return [NSString stringWithFormat:@"%@%@", @"No news for ", currentSettings.team.team_name];
    else
        return @"";
}

- (void)stopRefresh {
    [refreshControl endRefreshing];
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

- (IBAction)refreshButtonClicked:(id)sender {
    [self startRefresh];
}

@end
