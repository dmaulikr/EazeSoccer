//
//  sportzteamsVideoCollectionViewController.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/5/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "sportzteamsVideoCollectionViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzServerInit.h"
#import "VideoCell.h"
#import "Video.h"
#import "sportzteamsMovieViewController.h"

@interface sportzteamsVideoCollectionViewController ()

@end

@implementation sportzteamsVideoCollectionViewController {
    NSMutableArray *videos;
    NSArray *serverData;
    NSMutableData *theData;
    int responseStatusCode;
}

@synthesize game;
@synthesize player;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSURL *url = [[NSURL alloc] init];
    
    if ((player != nil) && (game != nil))
        url = [NSURL URLWithString:[sportzServerInit getAthleteGameVideos:player.athleteid Game:game.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken]];
    else if (player != nil)
        url = [NSURL URLWithString:[sportzServerInit getAthleteVideos:player.athleteid Team:currentSettings.team.teamid Token:currentSettings.user.authtoken]];
    else if (game != nil)
        url = [NSURL URLWithString:[sportzServerInit getGameVideos:game.id Team:currentSettings.team.teamid Token:currentSettings.user.authtoken]];
    else
        url = [NSURL URLWithString:[sportzServerInit getTeamVideos:currentSettings.team.teamid Token:currentSettings.user.authtoken]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [videos count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath];
    Video *video = [videos objectAtIndex:indexPath.row];
    NSURL * imageURL = [NSURL URLWithString:video.poster_url];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    [cell.videoImage setImage:image];
    [cell.videoName setText:video.displayName];
    cell.videoName.numberOfLines = 2;
    [cell.videoDuration setText:[video.duration stringValue]];
    return cell;
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
    //    [self performSegueWithIdentifier:@"RosterInfoSegue" sender:self];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"VideoPlaySegue"]) {
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        sportzteamsMovieViewController *destViewController = segue.destinationViewController;
        destViewController.videoclip = [videos objectAtIndex:indexPath.row];
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
        videos =[[NSMutableArray alloc] init];

        for (int i = 0; i < [serverData count]; i++) {
            NSDictionary *items = [serverData objectAtIndex:i];
            NSLog(@"%@", items);
            Video *video = [[Video alloc] init];
            video.poster_url = [items objectForKey:@"poster_url"];
            video.video_url = [items objectForKey:@"video_url"];
            video.description = [items objectForKey:@"description"];
            video.displayName = [items objectForKey:@"displayname"];
            video.duration = [items objectForKey:@"duration"];
            video.videoid = [items objectForKey:@"id"];
            video.teamid = [items objectForKey:@"teamid"];
            video.schedule = [items objectForKey:@"gameschedule"];
            video.resolution = [items objectForKey:@"resoultion"];
            video.players = [items objectForKey:@"players"];
            [videos addObject:video];
        }
        [self.collectionView reloadData];
        if (videos.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Videos"
                                                            message:@"No Videos uploaded for search criteria"
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem Retrieving Videos"
                                                        message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

@end
