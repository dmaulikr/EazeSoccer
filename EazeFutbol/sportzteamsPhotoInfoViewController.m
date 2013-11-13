//
//  sportzteamsPhotoInfoViewController.m
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/5/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import "sportzteamsPhotoInfoViewController.h"
#import "sportzteamsPhotoDescriptionViewController.h"
#import "sportzServerInit.h"
#import "EazesportzAppDelegate.h"
#import "sportzCurrentSettings.h"

@interface sportzteamsPhotoInfoViewController () <UIScrollViewDelegate>

@end

@implementation sportzteamsPhotoInfoViewController {
    NSDictionary *serverData;
    NSMutableData *theData;
    int responseStatusCode;
}

@synthesize photo;
@synthesize photoImage;
@synthesize photoid;

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
    
    _scrollView.minimumZoomScale = 0.5f;
    _scrollView.maximumZoomScale = 5.0f;
    _scrollView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (photoid == nil) {
        self.title = photo.displayname;
        NSURL * imageURL = [NSURL URLWithString:photo.medium_url];
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage * image = [UIImage imageWithData:imageData];
        [photoImage setImage:image];
        photoImage.frame = CGRectMake(0, 0, photoImage.image.size.width, photoImage.image.size.height);
        _scrollView.contentSize = photoImage.image.size;
        _scrollView.zoomScale = 2.0f;
    } else {
        NSURL *url = [NSURL URLWithString:[sportzServerInit getPhoto:photoid Token:currentSettings.user.authtoken]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];        
    }
    
    self.title = photo.displayname;
}

#pragma Zooming

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return photoImage;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PhotoDetailSegue"]) {
        sportzteamsPhotoDescriptionViewController *destViewController = segue.destinationViewController;
        destViewController.photo = photo;
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
        Photo *aphoto = [[Photo alloc] init];
        aphoto.large_url = [serverData objectForKey:@"large_url"];
        aphoto.medium_url = [serverData objectForKey:@"medium_url"];
        aphoto.thumbnail_url = [serverData objectForKey:@"thumbnail_url"];
        aphoto.description = [serverData objectForKey:@"description"];
        aphoto.displayname = [serverData objectForKey:@"displayname"];
        aphoto.teamid = [serverData objectForKey:@"teamid"];
        aphoto.schedule = [serverData objectForKey:@"gameschedule"];
        aphoto.photoid = [serverData objectForKey:@"id"];
        aphoto.owner = [serverData objectForKey:@"owner"];
        aphoto.players = [serverData objectForKey:@"players"];
        aphoto.gamelog = [serverData objectForKey:@"gamelog"];
        photoid = nil;
        photo = aphoto;
        [self viewWillAppear:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem Retrieving Photo"
                                                        message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    _bannerView.hidden = NO;
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    _bannerView.hidden = YES;
}

@end
