//
//  EazePhotosViewController.h
//  EazeSportz
//
//  Created by Gil on 11/13/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import "PhotosViewController.h"

#import <iAd/iAd.h>

@interface EazePhotosViewController : PhotosViewController

- (IBAction)searchButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *videoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addPhotoButton;
@property (weak, nonatomic) IBOutlet UIView *gamelogContainer;

@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;

- (IBAction)searchBlogGameLog:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UIView *adBannerContainer;

@end
