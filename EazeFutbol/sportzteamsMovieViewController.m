//
//  sportzteamsMovieViewController.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/6/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "sportzteamsMovieViewController.h"
#import "sportzServerInit.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"
#import "EazesportzSoccerGameSummaryViewController.h"
#import "PlayerInfoViewController.h"
#import "EazeBasketballGameSummaryViewController.h"

@interface sportzteamsMovieViewController ()

@end

@implementation sportzteamsMovieViewController {
    NSDictionary *serverData;
    NSMutableData *theData;
    int responseStatusCode;
}

@synthesize videoclip;
@synthesize videoid;

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (videoid == nil) {
        NSURL * imageURL = [NSURL URLWithString:videoclip.poster_url];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        [_videoImage setImage:image];
        
        if (videoclip.schedule.length > 0) {
            _gameButton.enabled = YES;
            [_gameButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            _gameButtonLabel.text = [NSString stringWithFormat:@"%@%@", @"vs. ", [[currentSettings findGame:videoclip.schedule] opponent_mascot]];
        } else {
            [_gameButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            _gameButtonLabel.hidden = YES;
            _gameButton.enabled = NO;
        }
        
        if (videoclip.players.count > 0) {
            [_playerTagTableView reloadData];
        } else {
            _playerTagTableView.hidden = YES;
        }
    } else {
        NSURL *url = [NSURL URLWithString:[sportzServerInit getVideo:videoid Token:currentSettings.user.authtoken]];
        NSLog(@"%@", url);
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return videoclip.players.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlayerTagCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Athlete *aplayer = [currentSettings findAthlete:[videoclip.players objectAtIndex:indexPath.row]];
    cell.textLabel.font = [UIFont fontWithName:@"ArialMT" size:10];
    cell.textLabel.text = aplayer.logname;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (IBAction)playButtonClicked:(id)sender {
    NSURL *url = [NSURL URLWithString:videoclip.video_url];
    
    _moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(moviePlayBackDidFinish:)
                                          name:MPMoviePlayerPlaybackDidFinishNotification
                                          object:_moviePlayer];
    
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:YES animated:YES];
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                          name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    
    if ([player respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player.view removeFromSuperview];
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
        Video *avideo = [[Video alloc] initWithDirectory:serverData];
        videoclip = avideo;
        videoid = nil;
        [self viewWillAppear:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem Retrieving Video Clip"
                                                        message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GameInfoSegue"]) {
        EazesportzSoccerGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings findGame:videoclip.schedule];
    } else if ([segue.identifier isEqualToString:@"PlayerInfoSegue"]) {
        PlayerInfoViewController *destController = segue.destinationViewController;
        destController.player = [currentSettings findAthlete:[videoclip.players objectAtIndex:[[_playerTagTableView indexPathForSelectedRow] row]]];
    } else if ([segue.identifier isEqualToString:@"BasketballGameInfoSegue"]) {
        EazeBasketballGameSummaryViewController *destController = segue.destinationViewController;
        destController.game = [currentSettings findGame:videoclip.schedule];
    }
}
@end
