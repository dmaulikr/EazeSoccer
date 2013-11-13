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
    
    if (videoid == nil) {
        NSURL * imageURL = [NSURL URLWithString:videoclip.poster_url];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        [_videoImage setImage:image];
    } else {
        NSURL *url = [NSURL URLWithString:[sportzServerInit getVideo:videoid Token:currentSettings.user.authtoken]];
        NSLog(@"%@", url);
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    serverData = [NSJSONSerialization JSONObjectWithData:theData options:nil error:nil];
    NSLog(@"%@", serverData);
    
    if (responseStatusCode == 200) {
        Video *avideo = [[Video alloc] init];
        avideo.poster_url = [serverData objectForKey:@"poster_url"];
        avideo.video_url = [serverData objectForKey:@"video_url"];
        avideo.description = [serverData objectForKey:@"description"];
        avideo.displayName = [serverData objectForKey:@"displayname"];
        avideo.duration = [serverData objectForKey:@"duration"];
        avideo.videoid = [serverData objectForKey:@"id"];
        avideo.teamid = [serverData objectForKey:@"teamid"];
        avideo.schedule = [serverData objectForKey:@"gameschedule"];
        avideo.resolution = [serverData objectForKey:@"resoultion"];
        videoclip = avideo;
        videoid = nil;
        [self viewDidLoad];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem Retrieving Video Clip"
                                                        message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

@end
