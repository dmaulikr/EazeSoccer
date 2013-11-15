//
//  sportzteamsNewBlogViewController.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 5/1/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface NewBlogViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *titleTextEtnry;
@property (weak, nonatomic) IBOutlet UITextView *entryTextView;

@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)postBlogButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *playerButton;
@property (weak, nonatomic) IBOutlet UIButton *gameButton;
@property (weak, nonatomic) IBOutlet UIButton *coachButton;
@property (weak, nonatomic) IBOutlet UITextField *playerTextField;
@property (weak, nonatomic) IBOutlet UITextField *gameTextField;
@property (weak, nonatomic) IBOutlet UITextField *coachTextField;


@end
