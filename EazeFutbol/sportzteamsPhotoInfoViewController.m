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
#import "EazesportzCheckAdImageViewController.h"

@interface sportzteamsPhotoInfoViewController () <UIScrollViewDelegate>

@property(nonatomic, strong) UIImageView *animage;
- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;

@end

@implementation sportzteamsPhotoInfoViewController {
    NSDictionary *serverData;
    NSMutableData *theData;
    int responseStatusCode;
    UIView *subview;
    int currentphoto, adcount;
    
    EazesportzCheckAdImageViewController *adController;
}

@synthesize photo;
@synthesize photoid;
@synthesize photos;
@synthesize photoindex;

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
    
    // 3
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backPhoto)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired = 1;
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextPhoto)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeft.numberOfTouchesRequired = 1;
    
    [self.scrollView addGestureRecognizer:swipeLeft];
    [self.scrollView addGestureRecognizer:swipeRight];
}

- (void)nextPhoto {
    adcount++;
    
    if (currentphoto < photos.count - 1) {
        currentphoto++;
        [self displayPhoto:[photos objectAtIndex:currentphoto]];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                        message:[NSString stringWithFormat:@"%@%@", @"No more photos to display for ", currentSettings.team.team_name]
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
    
    if ((adcount == 5) && (currentSettings.sponsors.sponsors.count > 0)) {
        _adContainer.hidden = NO;
        adController.sponsor = nil;
        [adController viewWillAppear:YES];
        adcount = 0;
    }
}

- (void)backPhoto {
    adcount++;
    
    if (currentphoto > 0) {
        currentphoto--;
        [self displayPhoto:[photos objectAtIndex:currentphoto]];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                        message:[NSString stringWithFormat:@"%@%@", @"No more photos to display for ", currentSettings.team.team_name]
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
    
    if ((adcount == 5) && (currentSettings.sponsors.sponsors.count > 0)) {
        _adContainer.hidden = NO;
        adController.sponsor = nil;
        [adController viewWillAppear:YES];
        adcount = 0;
    }
}

- (IBAction)closeAdSponsor:(UIStoryboardSegue *)segue {
    _adContainer.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    currentphoto = photoindex;
    _adContainer.hidden = YES;
    adcount = 0;
    
    if (photoid == nil) {
        if (subview)
            [subview removeFromSuperview];
        
        self.title = photo.displayname;
        [self displayPhoto:[photos objectAtIndex:currentphoto]];
    } else {
        NSURL *url;
        
        if (currentSettings.user.authtoken)
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                                        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl" ],
                                        @"/sports/", currentSettings.sport.id, @"/photos/", photoid, @".json?auth_token=", currentSettings.user.authtoken]];
        else
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@",
                                        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SportzServerUrl" ],
                                        @"/sports/", currentSettings.sport.id, @"/photos/", photoid, @".json"]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];        
    }
    
    self.title = photo.displayname;
    
    if (currentSettings.sport.hideAds)
        _bannerView.hidden = YES;
}

- (void)displayPhoto:(Photo *)thephoto {
    if (subview)
        [subview removeFromSuperview];
    
    while (thephoto.largeimage == nil) {
        sleep(1);
    }
    
    self.animage = [[UIImageView alloc] initWithImage:thephoto.largeimage];
    self.animage.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size = thephoto.largeimage.size};
    [self.scrollView addSubview:self.animage];
    subview = self.animage;
    
    // 2
    self.scrollView.contentSize = thephoto.largeimage.size;
    // 4
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    
    // 5
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale = minScale;
    
    // 6
    [self centerScrollViewContents];
}


#pragma Zooming

- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.animage.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.animage.frame = contentsFrame;
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    // 1
    CGPoint pointInView = [recognizer locationInView:self.animage];
    
    // 2
    CGFloat newZoomScale = self.scrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    
    // 3
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    // 4
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    [self.scrollView setZoomScale:newZoomScale animated:YES];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.animage;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PhotoDetailSegue"]) {
        sportzteamsPhotoDescriptionViewController *destViewController = segue.destinationViewController;
        destViewController.photo = [photos objectAtIndex:currentphoto];
    } else if ([segue.identifier isEqualToString:@"AdSegue"]) {
        adController = segue.destinationViewController;
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
    
    if (responseStatusCode == 200) {
        Photo *aphoto = [[Photo alloc] init];
        photos = [[NSMutableArray alloc] init];
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
//        photo = aphoto;
        [photos addObject:aphoto];
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
