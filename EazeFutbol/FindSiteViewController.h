//
//  FindSiteViewController.h
//  Eazebasketball
//
//  Created by Gil on 9/28/13.
//  Copyright (c) 2013 Gil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindSiteViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *stateListContainer;
@property (weak, nonatomic) IBOutlet UITextField *sitenameTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
- (IBAction)submitButtonClicked:(id)sender;

- (IBAction)selectStateFindSite:(UIStoryboardSegue *)segue;

@end
