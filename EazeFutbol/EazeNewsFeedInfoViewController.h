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
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
- (IBAction)imageButtonClicked:(id)sender;
- (IBAction)athleteButtonClicked:(id)sender;
- (IBAction)coachButtonClicked:(id)sender;
- (IBAction)gameButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end
