//
//  sportzteamsPhotoInfoViewController.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/5/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

#import "Photo.h"
#import "EazePhotosViewController.h"

@interface sportzteamsPhotoInfoViewController : UIViewController

@property(nonatomic, strong) Photo *photo;
@property(nonatomic, strong) NSString *photoid;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, assign) int photoindex;

@end
