//
//  EditCoachViewController.h
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 6/17/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Coach.h"

@interface EditCoachViewController : UIViewController

@property(nonatomic, strong) Coach *coach;
@property(nonatomic, strong) UIPopoverController *popover;

@property (weak, nonatomic) IBOutlet UITextField *coachLastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *coachFirstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *coachMiddleNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *responsibilityTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearsOnStaffTextField;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;
@property (weak, nonatomic) IBOutlet UIImageView *coachImage;
- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)cameraButtonClicked:(id)sender;
- (IBAction)cameraRollButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
