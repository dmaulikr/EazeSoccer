//
//  EazeFeaturedPhotosViewController.m
//  EazeSportz
//
//  Created by Gil on 1/15/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import "EazeFeaturedPhotosViewController.h"
#import "EazesportzAppDelegate.h"
#import "EazesportzRetrieveFeaturedPhotos.h"
#import "Photo.h"

@interface EazeFeaturedPhotosViewController () <UIGestureRecognizerDelegate>

@property(nonatomic, strong) UIImageView *animage;

- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;

@end

@implementation EazeFeaturedPhotosViewController {
    EazesportzRetrieveFeaturedPhotos *getPhotos;
    
    int currentphoto;
    UIView *subview;
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
    self.view.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backFeaturedPhoto)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired = 1;
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextFeaturedPhoto)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeft.numberOfTouchesRequired = 1;
    
    [self.scrollView addGestureRecognizer:swipeLeft];
    [self.scrollView addGestureRecognizer:swipeRight];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.photosButton, self.videoButton, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    currentphoto = 0;
    
    if (currentSettings.featuredPhotos.count > 0)
        [self displayPhoto:[currentSettings.featuredPhotos objectAtIndex:0]];
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                        message:[NSString stringWithFormat:@"%@%@", @"No photos featured for ", currentSettings.team.team_name]
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)gotFeaturedPhotos:(NSNotification *)notification {
    if (getPhotos.featuredphotos.count > 0) {
        [self displayPhoto:[getPhotos.featuredphotos objectAtIndex:0]];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                    message:[NSString stringWithFormat:@"%@%@", @"No photos featured for ", currentSettings.team.team_name]
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

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

- (void)displayPhoto:(Photo *)photo {
    if (subview)
        [subview removeFromSuperview];
    
    for (;;) {
        if (photo.largeimage)
            sleep(1);
            break;
    }
    
    self.animage = [[UIImageView alloc] initWithImage:photo.largeimage];
    self.animage.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=photo.largeimage.size};
    [self.scrollView addSubview:self.animage];
    subview = self.animage;
    
    // 2
    self.scrollView.contentSize = photo.largeimage.size;
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

-(BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}

- (void)nextFeaturedPhoto {
    if (currentphoto < currentSettings.featuredPhotos.count - 1) {
        currentphoto++;
        [self displayPhoto:[currentSettings.featuredPhotos objectAtIndex:currentphoto]];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                        message:[NSString stringWithFormat:@"%@%@", @"No more photos to display for ", currentSettings.team.team_name]
                                        delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

- (void)backFeaturedPhoto {
    if (currentphoto > 0) {
        currentphoto--;
        [self displayPhoto:[currentSettings.featuredPhotos objectAtIndex:currentphoto]];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                        message:[NSString stringWithFormat:@"%@%@", @"No more photos to display for ", currentSettings.team.team_name]
                                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

@end
