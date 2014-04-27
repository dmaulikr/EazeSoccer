//
//  ProgramInfoViewController.h
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 7/9/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Sport.h"

@interface ProgramInfoViewController : UIViewController

@property(nonatomic, strong) Sport *sport;
@property (nonatomic, strong) NSString *sportid;
@property(nonatomic, strong) UIPopoverController *popover;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *sitenameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mascotTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;

@property (weak, nonatomic) IBOutlet UIButton *cameraRollButton;
- (IBAction)cameraRollButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *sportTextField;

- (IBAction)submitButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
- (IBAction)saveBarButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *userPicsSwitch;
- (IBAction)userPicsSwitchSelected:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *userVideosSwitch;
- (IBAction)userVideosSwitchSelected:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *reviewMediaSwitch;
- (IBAction)reviewMediaSwitchSelected:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *paypalEmailTextField;

@end
