//
//  sportzteamsCoachesInfoViewController.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/2/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

#import "Coach.h"

@interface CoachesInfoViewController : UIViewController

@property(nonatomic, strong) Coach * coach;
@property (weak, nonatomic) IBOutlet UIImageView *coachImage;
@property (weak, nonatomic) IBOutlet UILabel *years;
@property (weak, nonatomic) IBOutlet UILabel *staffPosition;
@property (weak, nonatomic) IBOutlet UITextView *bioTextVeiw;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *yearsonstaffLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end
