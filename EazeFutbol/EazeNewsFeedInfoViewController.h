//
//  sportzteamsNewsFeedInfoViewController.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/7/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

#import "Newsfeed.h"

@interface EazeNewsFeedInfoViewController : UIViewController

@property(nonatomic, strong) Newsfeed *newsitem;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *newsTextView;
@property (weak, nonatomic) IBOutlet UIButton *athleteButton;
@property (weak, nonatomic) IBOutlet UIButton *coachButton;
@property (weak, nonatomic) IBOutlet UIButton *gameButton;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
- (IBAction)gameButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *readArticleButton;
- (IBAction)readArticleButtonClicked:(id)sender;

@end
