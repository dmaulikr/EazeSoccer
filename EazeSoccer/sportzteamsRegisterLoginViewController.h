//
//  sportzteamsRegisterLoginViewController.h
//  smpwlions
//
//  Created by Gilbert Zaldivar on 4/23/13.
//  Copyright (c) 2013 Gilbert Zaldivar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sport.h"

@interface sportzteamsRegisterLoginViewController : UIViewController

@property(nonatomic, strong) Sport *sport;
@property(nonatomic, assign) BOOL admin;

@property (weak, nonatomic) IBOutlet UILabel *siteLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *confirmText;
- (IBAction)createLoginButtonClicked:(id)sender;
- (IBAction)learnmoreButtonClicked:(id)sender;


@end
