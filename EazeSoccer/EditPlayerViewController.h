//
//  EditPlayerViewController.h
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/2/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Athlete.h"

@interface EditPlayerViewController : UIViewController

@property(nonatomic,strong) Athlete *player;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *statsButton;
- (IBAction)statsButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *middlenameTextField;
- (IBAction)submitButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *heightTextField;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UITextField *gradeageclassTextField;
@property (weak, nonatomic) IBOutlet UITextField *positionTextField;
@property (weak, nonatomic) IBOutlet UITextField *seasonTextField;
@property (weak, nonatomic) IBOutlet UIImageView *playerImage;
- (IBAction)camerarollButtonClicked:(id)sender;
- (IBAction)cameraButtonClicked:(id)sender;

@property(nonatomic, strong) UIPopoverController *popover;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;
@property (weak, nonatomic) IBOutlet UIButton *warningDeleteButton;
- (IBAction)warningDeleteButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *videosButton;
@property (weak, nonatomic) IBOutlet UIButton *photosButton;
@property (weak, nonatomic) IBOutlet UIPickerView *positionPicker;
- (IBAction)addPositionControl:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *addPositionControl;
@property (weak, nonatomic) IBOutlet UIPickerView *heightPicker;
@property (weak, nonatomic) IBOutlet UIView *soccerStatsContainer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
- (IBAction)doneButtonClicked:(id)sender;

@end
