//
//  sportzteamsBlogDetailViewController.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/25/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "Blog.h"

@interface EazeBlogDetailViewController : UIViewController

@property(nonatomic, strong) Blog *blog;

@property (weak, nonatomic) IBOutlet UILabel *blogtitle;
@property (weak, nonatomic) IBOutlet UIImageView *bloggerImage;
@property (weak, nonatomic) IBOutlet UILabel *bloggerName;
@property (weak, nonatomic) IBOutlet UITextView *blogEntry;
- (IBAction)commentButton:(id)sender;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *playerButton;
@property (weak, nonatomic) IBOutlet UIButton *gameButton;
@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coachNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *coachButton;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
- (IBAction)gameButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteBarButton;
- (IBAction)deleteBarButtonClicked:(id)sender;

@end
