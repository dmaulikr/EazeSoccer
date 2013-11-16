//
//  sportzteamsPlayerInfoViewController.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 3/27/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "Athlete.h"

@interface PlayerInfoViewController : UIViewController

@property (nonatomic, strong) Athlete *player;

@property (weak, nonatomic) IBOutlet UIImageView *playerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *alertButton;
@property (weak, nonatomic) IBOutlet UISwitch *followSwitch;
- (IBAction)followPlayerSwitch:(id)sender;
- (IBAction)playerStatsButtonClicked:(id)sender;
- (IBAction)alertButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *photoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *videoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *statsButton;

@end