//
//  EditUserViewController.h
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/10/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"

@interface EditUserViewController : UIViewController

@property(nonatomic, strong) NSString *userid;
@property(nonatomic, strong) User *theuser;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *userimage;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UILabel *activeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *activeSwitch;
@property (weak, nonatomic) IBOutlet UIButton *deleteAvatarButton;
- (IBAction)deleteAvatarButtonClicked:(id)sender;
- (IBAction)submitButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
- (IBAction)cameraRollButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *camerarollButton;
- (IBAction)cameraButtonClicked:(id)sender;
@property(nonatomic, strong) UIPopoverController *popover;
;
@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UIButton *resetPassword;
- (IBAction)resetPasswordButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

@end
