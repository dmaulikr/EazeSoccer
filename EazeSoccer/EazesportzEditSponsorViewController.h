//
//  EazesportzEditSponsorViewController.h
//  EazeSportz
//
//  Created by Gil on 1/13/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

#import "Sponsor.h"
#import "InAppProducts.h"
#import "Athlete.h"

@interface EazesportzEditSponsorViewController : UIViewController

@property(nonatomic, strong) Sponsor *sponsor;

@property (nonatomic, strong) SKProduct *storekitProduct;
@property (nonatomic, strong) InAppProducts *adproduct;
@property (nonatomic, strong) Athlete *player;

@property(nonatomic, strong) UIPopoverController *popover;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;

@property (weak, nonatomic) IBOutlet UIPickerView *countryPicker;
@property (weak, nonatomic) IBOutlet UIImageView *sponsorImage;
@property (weak, nonatomic) IBOutlet UITextField *sponsorName;
@property (weak, nonatomic) IBOutlet UITextField *streetNumber;
@property (weak, nonatomic) IBOutlet UITextField *streetName;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *state;
@property (weak, nonatomic) IBOutlet UITextField *zipcode;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UITextField *faxnumber;
@property (weak, nonatomic) IBOutlet UITextField *sponsorurl;
@property (weak, nonatomic) IBOutlet UITextField *sponsorEmail;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sponsorLevel;
- (IBAction)cameraRollButtonClicked:(id)sender;
- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)deleteButtonClicked:(id)sender;
- (IBAction)cameraButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkImageButton;
@property (weak, nonatomic) IBOutlet UITextField *adInventoryTextField;
@property (weak, nonatomic) IBOutlet UITextField *playerTextField;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UIButton *bannerCameraRollButton;
@property (weak, nonatomic) IBOutlet UIButton *bannerCameraButton;

@property (weak, nonatomic) IBOutlet UIImageView *bannerlogoImage;
@property (weak, nonatomic) IBOutlet UILabel *bannerlogoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bannerlogoMessageLabel;
@property (weak, nonatomic) IBOutlet UIButton *sponsorCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *sponsorCameraRollButton;

@end
