//
//  sportzteamsUserSettingsViewController.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 5/13/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface EazeUserSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UISwitch *bioSwitch;
@property (weak, nonatomic) IBOutlet UILabel *blogLabel;
@property (weak, nonatomic) IBOutlet UISwitch *blogSwitch;
@property (weak, nonatomic) IBOutlet UILabel *statsLabel;
@property (weak, nonatomic) IBOutlet UISwitch *statsSwitch;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISwitch *scoreSwitch;
@property (weak, nonatomic) IBOutlet UILabel *mediaLabel;
@property (weak, nonatomic) IBOutlet UISwitch *mediaSwitch;
- (IBAction)submitButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
- (IBAction)cameraRollButtonClicked:(id)sender;
- (IBAction)cameraButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *camerarollButton;
@property (weak, nonatomic) IBOutlet UIButton *camerabutton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
