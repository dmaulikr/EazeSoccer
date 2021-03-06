//
//  FindSiteViewController.h
//  Eazebasketball
//
//  Created by Gil on 9/28/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindSiteViewController : UIViewController

@property (nonatomic, assign) BOOL findsite;

@property (weak, nonatomic) IBOutlet UIView *stateListContainer;
@property (weak, nonatomic) IBOutlet UITextField *sitenameTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
- (IBAction)submitButtonClicked:(id)sender;

- (IBAction)selectStateFindSite:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UIPickerView *sportPicker;
@property (weak, nonatomic) IBOutlet UITextField *sportTextField;
@property (weak, nonatomic) IBOutlet UIView *siteselectView;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *countryPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *statePicker;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginButtonClicked:(id)sender;

@end
