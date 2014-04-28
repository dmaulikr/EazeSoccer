//
//  EazesportzDisplayAdBannerViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/27/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Sponsor.h"

@interface EazesportzDisplayAdBannerViewController : UIViewController

- (IBAction)sponsorButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UIButton *sponsorButton;
@property (weak, nonatomic) IBOutlet UIButton *teamButton;
- (IBAction)ateamButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *fullBannerImageView;

@end
