//
//  EazeFeaturedVideosViewController.m
//  EazeSportz
//
//  Created by Gil on 1/18/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazeFeaturedVideosViewController.h"
#import "EazesportzRetrieveFeaturedVideosController.h"
#import "EazesportzAppDelegate.h"
#import "Video.h"
#import "VideoCell.h"
#import "sportzteamsMovieViewController.h"

@interface EazeFeaturedVideosViewController ()

@end

@implementation EazeFeaturedVideosViewController {
    EazesportzRetrieveFeaturedVideosController *getVideos;
    
    int currentvideo;
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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotFeaturedVideos:) name:@"FeaturedVideosChangedNotification" object:nil];
    getVideos = [[EazesportzRetrieveFeaturedVideosController alloc] init];
    [getVideos retrieveFeaturedVideos:currentSettings.sport.id Token:currentSettings.user.authtoken];
    currentvideo = 0;
}

- (void)gotFeaturedVideos:(NSNotification *)notification {
    if (getVideos.featuredvideos.count > 0) {
        [_videoCollectionView reloadData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                        message:[NSString stringWithFormat:@"%@%@", @"No videos featured for ", currentSettings.team.team_name]
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [getVideos.featuredvideos count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 6;
    cell.backgroundColor = [UIColor whiteColor];
    Video *video = [getVideos.featuredvideos objectAtIndex:indexPath.row];
    NSURL * imageURL = [NSURL URLWithString:video.poster_url];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    [cell.videoImage setImage:image];
    [cell.videoName setText:video.displayName];
    [cell.videoDuration setText:[NSString stringWithFormat:@"%d", video.duration.intValue]];
    
    if (video.schedule.length > 0) {
        cell.gametagLabel.hidden = NO;
        cell.gametagLabel.text = [NSString stringWithFormat:@"%@%@", @"vs. ", [[currentSettings findGame:video.schedule] opponent_mascot]];
    } else
        cell.gametagLabel.hidden = YES;
    
    return cell;
}

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
        NSIndexPath *indexPath = [[_videoCollectionView indexPathsForSelectedItems] objectAtIndex:0];
        sportzteamsMovieViewController *destController = segue.destinationViewController;
        destController.videoclip = [getVideos.featuredvideos objectAtIndex:indexPath.row];
    }
}

@end
