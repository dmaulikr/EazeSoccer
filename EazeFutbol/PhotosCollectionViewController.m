//
//  PhotosCollectionViewController.m
//  Eazebasketball
//
//  Created by Gil on 10/3/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "PhotosCollectionViewController.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "sportzServerInit.h"
#import "PhotoCell.h"
#import "sportzteamsPhotoInfoViewController.h"

@interface PhotosCollectionViewController ()

@end

@implementation PhotosCollectionViewController {
    NSMutableArray *photos;
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
    
    if (photos == nil) {
        photos =[[NSMutableArray alloc] init];
        if ((player != nil) && (game != nil))
            url = [NSURL URLWithString:[sportzServerInit getAthleteGamePhotos:player.athleteid Game:game.id Team:currentSettings.team.teamid
                                                                        Token:currentSettings.user.authtoken]];
        else if (player != nil)
            url = [NSURL URLWithString:[sportzServerInit getAthletePhotos:player.athleteid Team:currentSettings.team.teamid
                                                                    Token:currentSettings.user.authtoken]];
        else if (game != nil)
            url = [NSURL URLWithString:[sportzServerInit getGamePhotos:game.id Team:currentSettings.team.teamid
                                                                     Token:currentSettings.user.authtoken]];
        else
            url = [NSURL URLWithString:[sportzServerInit getTeamPhotos:currentSettings.team.teamid Token:currentSettings.user.authtoken]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [photos count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 6;
    cell.backgroundColor = [UIColor whiteColor];
    Photo *photo = [photos objectAtIndex:indexPath.row];
    NSURL * imageURL = [NSURL URLWithString:photo.thumbnail_url];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    [cell.photoImage setImage:image];
    [cell.photoLabel setText:photo.displayname];
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
    if ([segue.identifier isEqualToString:@"PhotoViewSegue"]) {
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        sportzteamsPhotoInfoViewController *destViewController = segue.destinationViewController;
        Photo *photo = [photos objectAtIndex:indexPath.row];
        destViewController.photo = photo;
        for (int cnt = 0; cnt < [currentSettings.roster count]; cnt++) {
            NSLog(@"%d", [photo.players count]);
            for (int i = 0; i < [photo.players count]; i++) {
                NSLog(@"%@", [photo.players objectAtIndex:i]);
                NSLog(@"%@", [[currentSettings.roster objectAtIndex:cnt] athleteid]);
                if ([[photo.players objectAtIndex:i] isEqualToString:[[currentSettings.roster objectAtIndex:cnt] athleteid]]) {
                    [photo.athletes addObject:[currentSettings.roster objectAtIndex:cnt]];
                }
            }
        }
        for (int cnt = 0; cnt < [currentSettings.gameList count]; cnt++) {
            if ([[[currentSettings.gameList objectAtIndex:cnt] id] isEqualToString:photo.schedule]) {
                photo.game = [currentSettings.gameList objectAtIndex:cnt];
            }
        }
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
    
    if (responseStatusCode == 200) {
        for (int i = 0; i < [serverData count]; i++) {
            NSDictionary *items = [serverData objectAtIndex:i];
            Photo *photo = [[Photo alloc] init];
            photo.large_url = [items objectForKey:@"large_url"];
            photo.medium_url = [items objectForKey:@"medium_url"];
            photo.thumbnail_url = [items objectForKey:@"thumbnail_url"];
            photo.description = [items objectForKey:@"description"];
            photo.displayname = [items objectForKey:@"displayname"];
            photo.teamid = [items objectForKey:@"teamid"];
            photo.schedule = [items objectForKey:@"gameschedule"];
            photo.photoid = [items objectForKey:@"id"];
            photo.owner = [items objectForKey:@"owner"];
            photo.players = [items objectForKey:@"players"];
            photo.gamelog = [items objectForKey:@"gamelog"];
            [photos addObject:photo];
        }
        [self.collectionView reloadData];
        
        if (photos.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Photos"
                                                            message:@"No Photos uploaded for search criteria"
                                                           delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem Retrieving Photos"
                                                        message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

@end
