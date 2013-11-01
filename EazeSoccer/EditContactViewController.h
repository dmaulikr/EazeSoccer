//
//  EditContactViewController.h
//  FootballStatsConsole
//
//  Created by Gilbert Zaldivar on 7/12/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Contact.h"

@interface EditContactViewController : UIViewController

@property(nonatomic, strong) Contact *contact;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *contacttitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *faxTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteButtonClicked:(id)sender;
- (IBAction)submitButtonClicked:(id)sender;

@end
