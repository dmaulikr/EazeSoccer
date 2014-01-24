//
//  EazeLoginViewController.h
//  EazeSportz
//
//  Created by Gil on 1/22/14.
//  Copyright (c) 2014 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EazeLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)loginButtonClicked:(id)sender;
- (IBAction)registerButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *loginMessageLabel;
@end
