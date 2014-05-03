//
//  EazesportzDisplayAdBannerViewController.h
//  EazeSportz
//
//  Created by Gilbert Zaldivar on 4/27/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Sponsor.h"
#import "Athlete.h"

@interface EazesportzDisplayAdBannerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UIImageView *fullBannerImageView;

- (void)displayPlayerAd:(Athlete *)player;
- (void)displayAd;
@property (weak, nonatomic) IBOutlet UIButton *fullBanerButton;
- (IBAction)fullBannerButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *sponsorLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;

@end
